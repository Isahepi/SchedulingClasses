//Final project
//Isabella Herrera
//April 30th, 2025
//Main proogram that shows the visual dn the schedule
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule Viewer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Schedule Viewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userName = '';
  String? selectedMajor;
  List<String> majors = [];

  @override
  void initState() {
    super.initState();
    loadMajors();
    loadStudentNames();
  }

//Call the API to get the majors in the SQL table "majors"
  void loadMajors() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/majors'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        majors = data.map((e) => e['major_name'].toString()).toList();
      });
    }
  }

//Call the API to get the names of the students
  List<String> studentNames = [];
  String? selectedName;
  void loadStudentNames() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/students'),
    );

    setState(() {
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        studentNames = data.map((e) => e['name'] as String).toList();
      } else {
        studentNames = [];
      }
    });
  }

  List<Map<String, dynamic>> classList = [];
  Map<String, bool> takenClasses = {};

//Call the API to get the classes for each major
  void loadClassesForMajor(String major) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/classes'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        classList =
            data.map((e) => {'name': e['class_name'] as String}).toList();
        takenClasses = {for (var cls in classList) cls['name']: false};
      });
    } else {
      setState(() {
        classList = [];
        takenClasses = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2E0854), Color(0xFF4A148C), Color(0xFF7B1FA2)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Button for the view schedule students
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SchedulePage(userName: 'User'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'View Student Schedule',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              //Button for the view professors schedule
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => TeacherSchedulePage(userName: 'User'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'View Teacher Schedule',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              //Button for the majors
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MajorsPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Majors',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Create the page for the schedule 
class SchedulePage extends StatefulWidget {
  final String userName;

  const SchedulePage({super.key, required this.userName});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<String> selectedNames = [];
  Map<String, Map<String, List<Map<String, String>>>> studentSchedules = {};
  //Retrieves the days in the API of shedules and depending on the letter it put it in the schedule
  List<String> convertInitialsToDays(String initials) {
    final Map<String, String> dayMap = {
      'M': 'Monday',
      'T': 'Tuesday',
      'W': 'Wednesday',
      'R': 'Thursday',
      'F': 'Friday',
      'S': 'Saturday',
      'U': 'Sunday',
    };

    return initials
        .split('')
        .map((initial) => dayMap[initial] ?? '')
        .where((day) => day.isNotEmpty)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    fetchSchedule();
  }

  Future<void> fetchSchedule() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/schedule'),
    );

    if (response.statusCode == 200) {
      setState(() {
        final List<dynamic> data = jsonDecode(response.body);
        studentSchedules = {};

        for (var item in data) {
          String name = item['name'];
          String dayInitials = item['days'];
          String schedules = item['schedules'];
          String courseNumber = item['course_number'];

          List<String> days = convertInitialsToDays(dayInitials);

          for (String day in days) {
            if (!studentSchedules.containsKey(name)) {
              studentSchedules[name] = {};
            }

            if (!studentSchedules[name]!.containsKey(day)) {
              studentSchedules[name]![day] = [];
            }

            List<String> scheduleList =
                schedules.split(',').map((s) => s.trim()).toList();
            for (String schedule in scheduleList) {
              studentSchedules[name]![day]!.add({
                'time': schedule,
                'course_number': courseNumber,
              });
            }
          }
        }
      });
    } else {
      throw Exception('Error to upload schedule');
    }
  }

  List<String> generateTimes() {
    List<String> times = [
      '08:00 - 08:50',
      '09:00 - 09:50',
      '09:00 - 10:50',
      '10:00 - 10:50',
      '11:00 - 11:50',
      '12:00 - 13:15',
      '13:00 - 13:50',
      '13:30 - 14:45',
      '14:00 - 14:50',
      '15:00 - 15:50',
      '16:00 - 17:15',
      '17:00 - 17:15',
    ];
    return times;
  }

  Color getScheduleColor(String name) {
    final hash = name.hashCode;
    const goldenRatioConjugate = 0.618033988749895;
    final hue = (hash * goldenRatioConjugate) % 1.0;
    final hsvColor = HSVColor.fromAHSV(0.6, hue * 360.0, 0.8, 0.95);
    return hsvColor.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final times = generateTimes();
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${widget.userName}\'s Schedule',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2E0854), Color(0xFF4A148C), Color(0xFF7B1FA2)],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 8,
                    dataRowMinHeight: 20,
                    dataRowMaxHeight: 60,
                    columns: [
                      DataColumn(
                        label: Text('Time', style: theme.textTheme.bodyLarge),
                      ),
                      ...days.map(
                        (day) => DataColumn(
                          label: Text(day, style: theme.textTheme.bodyLarge),
                        ),
                      ),
                    ],
                    rows:
                        times.map((time) {
                          return DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    time,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              ...days.map((day) {
                                final studentsAtThisTime =
                                    selectedNames
                                        .where(
                                          (name) =>
                                              studentSchedules[name]?[day]?.any(
                                                (schedule) =>
                                                    schedule['time'] == time,
                                              ) ??
                                              false,
                                        )
                                        .toList();

                                return DataCell(
                                  Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      gradient:
                                          studentsAtThisTime.length > 1
                                              ? LinearGradient(
                                                colors:
                                                    studentsAtThisTime
                                                        .map(
                                                          (name) =>
                                                              getScheduleColor(
                                                                name,
                                                              ),
                                                        )
                                                        .toList(),
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                              : null,
                                      color:
                                          studentsAtThisTime.length == 1
                                              ? getScheduleColor(
                                                studentsAtThisTime.first,
                                              )
                                              : null,
                                      border:
                                          studentsAtThisTime.length > 1
                                              ? Border.all(
                                                color: Colors.red,
                                                width: 2,
                                              )
                                              : null,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child:
                                        studentsAtThisTime.isEmpty
                                            ? null
                                            : ListView(
                                              shrinkWrap: true,
                                              children:
                                                  studentsAtThisTime.map((
                                                    name,
                                                  ) {
                                                    final schedule =
                                                        studentSchedules[name]?[day]
                                                            ?.firstWhere(
                                                              (s) =>
                                                                  s['time'] ==
                                                                  time,
                                                              orElse:
                                                                  () => {
                                                                    'time':
                                                                        time,
                                                                    'course_number':
                                                                        '',
                                                                  },
                                                            );
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 2,
                                                          ),
                                                      child: Text(
                                                        schedule?['course_number'] ??
                                                            '',
                                                        style: theme
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                                  ),
                                );
                              }),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Students',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: studentSchedules.keys.length,
                        itemBuilder: (context, index) {
                          final name = studentSchedules.keys.elementAt(index);
                          final isSelected = selectedNames.contains(name);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: getScheduleColor(name),
                                child: Text(
                                  name.split(' ').map((n) => n[0]).join(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(name),
                              trailing: Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedNames.add(name);
                                    } else {
                                      selectedNames.remove(name);
                                    }
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedNames.remove(name);
                                  } else {
                                    selectedNames.add(name);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    if (selectedNames.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FilledButton.icon(
                          icon: const Icon(Icons.warning_amber_rounded),
                          label: const Text('Check Conflicts'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Schedule Conflicts'),
                                    content: SingleChildScrollView(
                                      child: Text(
                                        findConflicts(),
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //Conflicts button, shows the different conflicts depending on the names of the students or professors selected
  String findConflicts() {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final conflicts = <String, List<String>>{};

    for (var day in days) {
      final timeSlots = <String, List<String>>{};

      for (var name in selectedNames) {
        final schedule = studentSchedules[name]?[day] ?? [];
        for (var timeMap in schedule) {
          timeSlots.putIfAbsent(timeMap['time'] ?? '', () => []).add(name);
        }
      }

      for (var entry in timeSlots.entries) {
        if (entry.value.length > 1) {
          conflicts
              .putIfAbsent(day, () => [])
              .add('${entry.key}: ${entry.value.join(', ')}');
        }
      }
    }

    if (conflicts.isEmpty) {
      return 'No schedule conflicts found!';
    } else {
      String result = 'Found conflicts:\n\n';
      for (var entry in conflicts.entries) {
        result += '${entry.key}:\n';
        result += entry.value.map((e) => '  • $e').join('\n');
        result += '\n\n';
      }
      return result;
    }
  }
}

//Professors schedule page
class TeacherSchedulePage extends StatefulWidget {
  final String userName;

  const TeacherSchedulePage({super.key, required this.userName});

  @override
  State<TeacherSchedulePage> createState() => _TeacherSchedulePageState();
}

class _TeacherSchedulePageState extends State<TeacherSchedulePage> {
  List<String> selectedNames = [];
  Map<String, Map<String, List<Map<String, String>>>> teacherSchedules = {};

  List<String> convertInitialsToDays(String initials) {
    final Map<String, String> dayMap = {
      'M': 'Monday',
      'T': 'Tuesday',
      'W': 'Wednesday',
      'R': 'Thursday',
      'F': 'Friday',
      'S': 'Saturday',
      'U': 'Sunday',
    };

    return initials
        .split('')
        .map((initial) => dayMap[initial] ?? '')
        .where((day) => day.isNotEmpty)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    fetchTeacherSchedule();
  }
  //Get the names of the professors that are in the database
  Future<void> fetchTeacherSchedule() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/schedule'),
    );

    if (response.statusCode == 200) {
      setState(() {
        final List<dynamic> data = jsonDecode(response.body);
        teacherSchedules = {};

        for (var item in data) {
          String name = item['professor_name'];
          String dayInitials = item['days'];
          String schedules = item['schedules'];
          String courseNumber = item['course_number'];

          List<String> days = convertInitialsToDays(dayInitials);

          for (String day in days) {
            if (!teacherSchedules.containsKey(name)) {
              teacherSchedules[name] = {};
            }

            if (!teacherSchedules[name]!.containsKey(day)) {
              teacherSchedules[name]![day] = [];
            }

            List<String> scheduleList =
                schedules.split(',').map((s) => s.trim()).toList();
            for (String schedule in scheduleList) {
              teacherSchedules[name]![day]!.add({
                'time': schedule,
                'course_number': courseNumber,
              });
            }
          }
        }
      });
    } else {
      throw Exception('Error to upload teacher schedule');
    }
  }

  List<String> generateTimes() {
    List<String> times = [
      '08:00 - 08:50',
      '09:00 - 09:50',
      '09:00 - 10:50',
      '10:00 - 10:50',
      '11:00 - 11:50',
      '12:00 - 13:15',
      '13:00 - 13:50',
      '13:30 - 14:45',
      '14:00 - 14:50',
      '15:00 - 15:50',
      '16:00 - 17:15',
      '17:00 - 17:15',
    ];
    return times;
  }

  Color getScheduleColor(String name) {
    final hash = name.hashCode;
    const goldenRatioConjugate = 0.618033988749895;
    final hue = (hash * goldenRatioConjugate) % 1.0;
    final hsvColor = HSVColor.fromAHSV(0.6, hue * 360.0, 0.8, 0.95);
    return hsvColor.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final times = generateTimes();
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${widget.userName}\'s Teacher Schedule',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2E0854), Color(0xFF4A148C), Color(0xFF7B1FA2)],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columnSpacing: 8,
                    dataRowMinHeight: 20,
                    dataRowMaxHeight: 60,
                    columns: [
                      DataColumn(
                        label: Text('Time', style: theme.textTheme.bodyLarge),
                      ),
                      ...days.map(
                        (day) => DataColumn(
                          label: Text(day, style: theme.textTheme.bodyLarge),
                        ),
                      ),
                    ],
                    rows:
                        times.map((time) {
                          return DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    time,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              ...days.map((day) {
                                final teachersAtThisTime =
                                    selectedNames
                                        .where(
                                          (name) =>
                                              teacherSchedules[name]?[day]?.any(
                                                (schedule) =>
                                                    schedule['time'] == time,
                                              ) ??
                                              false,
                                        )
                                        .toList();

                                return DataCell(
                                  Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      gradient:
                                          teachersAtThisTime.length > 1
                                              ? LinearGradient(
                                                colors:
                                                    teachersAtThisTime
                                                        .map(
                                                          (name) =>
                                                              getScheduleColor(
                                                                name,
                                                              ),
                                                        )
                                                        .toList(),
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                              : null,
                                      color:
                                          teachersAtThisTime.length == 1
                                              ? getScheduleColor(
                                                teachersAtThisTime.first,
                                              )
                                              : null,
                                      border:
                                          teachersAtThisTime.length > 1
                                              ? Border.all(
                                                color: Colors.red,
                                                width: 2,
                                              )
                                              : null,
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child:
                                        teachersAtThisTime.isEmpty
                                            ? null
                                            : ListView(
                                              shrinkWrap: true,
                                              children:
                                                  teachersAtThisTime.map((
                                                    name,
                                                  ) {
                                                    final schedule =
                                                        teacherSchedules[name]?[day]
                                                            ?.firstWhere(
                                                              (s) =>
                                                                  s['time'] ==
                                                                  time,
                                                              orElse:
                                                                  () => {
                                                                    'time':
                                                                        time,
                                                                    'course_number':
                                                                        '',
                                                                  },
                                                            );
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 2,
                                                          ),
                                                      child: Text(
                                                        schedule?['course_number'] ??
                                                            '',
                                                        style: theme
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                                  ),
                                );
                              }),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Teachers',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: teacherSchedules.keys.length,
                        itemBuilder: (context, index) {
                          final name = teacherSchedules.keys.elementAt(index);
                          final isSelected = selectedNames.contains(name);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: getScheduleColor(name),
                                child: Text(
                                  name.split(' ').map((n) => n[0]).join(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(name),
                              trailing: Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedNames.add(name);
                                    } else {
                                      selectedNames.remove(name);
                                    }
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedNames.remove(name);
                                  } else {
                                    selectedNames.add(name);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Creates the major page
class MajorsPage extends StatefulWidget {
  const MajorsPage({super.key});

  @override
  State<MajorsPage> createState() => _MajorsPageState();
}

class _MajorsPageState extends State<MajorsPage> {
  List<String> majors = [];
  String? selectedMajor;
  List<Map<String, dynamic>> classes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadMajors();
  }
  //Load the majors from the API and shows it in the page for the user to select the major
  Future<void> loadMajors() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/majors'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        majors = data.map((e) => e['major_name'].toString()).toList();
      });
    }
  }
  //Depending on the major they choose the classes will appear, this code conects the logic between the majors and the classes for each major
  Future<void> loadClasses(String majorName) async {
    setState(() {
      isLoading = true;
      classes = [];
    });

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/majorclasses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'major': majorName}),
    );

    setState(() {
      isLoading = false;
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        classes =
            data
                .map(
                  (e) => {
                    'course_number': e['course_number']?.toString() ?? '',
                    'class_name': e['class_name']?.toString() ?? '',
                    'hours': int.tryParse(e['hours']?.toString() ?? '0') ?? 0,
                    'start_time': e['start_time']?.toString() ?? '',
                    'end_time': e['end_time']?.toString() ?? '',
                    'year': e['year']?.toString() ?? '',
                    'days': e['days']?.toString() ?? '',
                  },
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Majors and Classes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2E0854), Color(0xFF4A148C), Color(0xFF7B1FA2)],
          ),
        ),
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButtonFormField<String>(
                  value: selectedMajor,
                  decoration: const InputDecoration(
                    labelText: 'Select Major',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      majors.map((String major) {
                        return DropdownMenuItem<String>(
                          value: major,
                          child: Text(major),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMajor = newValue;
                      if (newValue != null) {
                        loadClasses(newValue);
                      }
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child:
                  isLoading
                      ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                      : classes.isEmpty
                      ? const Center(
                        child: Text(
                          'Select a major to view classes',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                      : Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListView.builder(
                          itemCount: classes.length,
                          itemBuilder: (context, index) {
                            final classData = classes[index];
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.deepPurple.shade300,
                                      Colors.deepPurple.shade500,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            classData['course_number'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            classData['class_name'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${classData['hours']} hours',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            classData['days'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${classData['start_time']} - ${classData['end_time']}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            classData['year'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
