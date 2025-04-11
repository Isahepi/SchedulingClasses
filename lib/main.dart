import 'package:flutter/material.dart';

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
  }

  void loadMajors() async {
    setState(() {
      majors = ['Computer Science', 'Finance', 'Biology', 'Engineering'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Enter your name:'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) => setState(() {
                  userName = value;
                }),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your name',
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Select your major:'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedMajor,
                hint: const Text('Choose your major'),
                items: majors.map((String major) {
                  return DropdownMenuItem<String>(
                    value: major,
                    child: Text(major),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMajor = newValue;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            if (userName.isNotEmpty && selectedMajor != null) ...[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Classes for $selectedMajor:',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
                child: Text('Class 1: Introduction to $selectedMajor'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
                child: Text('Class 2: Advanced $selectedMajor Concepts'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 20),
                child: Text('Class 3: $selectedMajor Practice'),
              ),
            ],

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: ElevatedButton(
                onPressed: () {
                  if (userName.isNotEmpty && selectedMajor != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SchedulePage(userName: userName)),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Please enter your name and select a major'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('View Schedule'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SchedulePage extends StatefulWidget {
  final String userName;
  
  const SchedulePage({super.key, required this.userName});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<String> selectedNames = [];
  
  final Map<String, Map<String, List<String>>> studentSchedules = {
    'John Doe': {
      'Monday': ['08:00 - 08:50', '10:00 - 10:50'],
      'Tuesday': ['09:00 - 09:50', '11:00 - 11:50'],
      'Wednesday': ['08:00 - 08:50', '10:00 - 10:50'],
      'Thursday': ['09:00 - 09:50', '11:00 - 11:50'],
      'Friday': ['08:00 - 08:50'],
    },
    'Jane Smith': {
      'Monday': ['09:00 - 09:50', '11:00 - 11:50'],
      'Tuesday': ['08:00 - 08:50', '10:00 - 10:50'],
      'Wednesday': ['09:00 - 09:50', '11:00 - 11:50'],
      'Thursday': ['08:00 - 08:50', '10:00 - 10:50'],
      'Friday': ['09:00 - 09:50'],
    },
    'Alex Johnson': {
      'Monday': ['10:00 - 10:50', '12:00 - 12:50'],
      'Tuesday': ['11:00 - 11:50', '13:00 - 13:50'],
      'Wednesday': ['10:00 - 10:50', '12:00 - 12:50'],
      'Thursday': ['11:00 - 11:50', '13:00 - 13:50'],
      'Friday': ['10:00 - 10:50'],
    },
    'Sarah Williams': {
      'Monday': ['08:00 - 08:50', '14:00 - 14:50'],
      'Tuesday': ['09:00 - 09:50', '15:00 - 15:50'],
      'Wednesday': ['08:00 - 08:50', '14:00 - 14:50'],
      'Thursday': ['09:00 - 09:50', '15:00 - 15:50'],
      'Friday': ['08:00 - 08:50'],
    },
    'Michael Brown': {
      'Monday': ['08:00 - 08:50', '10:00 - 10:50'],
      'Tuesday': ['09:00 - 09:50', '11:00 - 11:50'],
      'Wednesday': ['08:00 - 08:50', '10:00 - 10:50'],
      'Thursday': ['09:00 - 09:50', '11:00 - 11:50'],
      'Friday': ['08:00 - 08:50'],
    },
  };

  List<String> generateTimes() {
    List<String> times = [];
    DateTime start = DateTime(0, 0, 0, 8, 0);
    while (start.hour < 17) {
      DateTime end = start.add(const Duration(minutes: 50));
      String range =
          "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}";
      times.add(range);
      start = end;
    }
    return times;
  }

  Color getScheduleColor(String name) {
    final hash = name.hashCode;
    const goldenRatioConjugate = 0.618033988749895;
    final hue = (hash * goldenRatioConjugate) % 1.0;
    final hsvColor = HSVColor.fromAHSV(
      0.6,
      hue * 360.0,
      0.8,
      0.95,
    );
    return hsvColor.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final times = generateTimes();
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}\'s Schedule'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Card(
              margin: const EdgeInsets.all(12),
              elevation: 4,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 8,
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 80,
                  columns: [
                    DataColumn(
                      label: Text('Time', style: theme.textTheme.bodyLarge),
                    ),
                    ...days.map((day) => DataColumn(
                      label: Text(day, style: theme.textTheme.bodyLarge),
                    )),
                  ],
                  rows: times.map((time) {
                    return DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: 120,
                            child: Text(time, style: theme.textTheme.bodyMedium),
                          ),
                        ),
                        ...days.map((day) {
                          final studentsAtThisTime = selectedNames.where((name) => 
                            studentSchedules[name]?[day]?.contains(time) ?? false
                          ).toList();
                          
                          return DataCell(
                            Container(
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                gradient: studentsAtThisTime.length > 1
                                  ? LinearGradient(
                                      colors: studentsAtThisTime
                                        .map((name) => getScheduleColor(name))
                                        .toList(),
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                                color: studentsAtThisTime.length == 1
                                  ? getScheduleColor(studentsAtThisTime.first)
                                  : null,
                                border: studentsAtThisTime.length > 1
                                  ? Border.all(color: Colors.red, width: 2)
                                  : null,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: studentsAtThisTime.isEmpty
                                ? null
                                : ListView(
                                    shrinkWrap: true,
                                    children: studentsAtThisTime.map((name) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: Text(
                                          name.split(' ').first,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                            builder: (context) => AlertDialog(
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
    );
  }

  String findConflicts() {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final conflicts = <String, List<String>>{};
    
    for (var day in days) {
      final timeSlots = <String, List<String>>{};
      
      for (var name in selectedNames) {
        final schedule = studentSchedules[name]?[day] ?? [];
        for (var time in schedule) {
          timeSlots.putIfAbsent(time, () => []).add(name);
        }
      }
      
      for (var entry in timeSlots.entries) {
        if (entry.value.length > 1) {
          conflicts.putIfAbsent(day, () => []).add(
            '${entry.key}: ${entry.value.join(', ')}'
          );
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
