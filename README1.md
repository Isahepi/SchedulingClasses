# Scheduling Classes App
### 1.✅ Project Introduction (1 or 2 paragraphs)
__What does your app do?__
This app is designed to identify and display scheduling conflicts among students in the CS386 class (excluding current seniors). The main goal is to visually represent when students' classes overlap, helping users understand which time slots are already occupied. By doing this, the app can assist professors or the registrar's office in finding potential time windows where a new class could be added, without yet considering room or instructor availability.
__Who is the target user?__
The primary users of this app are professors and the registrar’s office, as it supports academic planning. However, the app also includes a feature for students to input the classes they’ve already taken, allowing the system to simulate real-time schedules. This way, users can see a complete view of everyone’s availability and conflicts in one place.
### 2.✅ Design and Architecture

Description of how the app is structured.
Include Mermaid class diagrams for all classes.

# Database Model
## 📊 UML Diagram
Here's a **Mermaid UML class diagram** that represents the structure of your Flutter code and its relationship with the database/API:

```mermaid
classDiagram
  class MyApp {
    +build(BuildContext context) Widget
  }

 classDiagram
class _MyHomePageState {
  String? selectedName
  String? selectedMajor
  List<String> majors
  List<String> studentNames
  List<String> classList

  void initState()
  Widget build(BuildContext context)
  Future<void> loadMajors()
  Future<void> loadStudentNames()
  Future<void> loadClassesForMajor(String major)
}

  class SchedulePage {
    +userName: String
    +createState() _SchedulePageState
  }

  class _SchedulePageState {
    -selectedNames: List<String>
    -studentSchedules: Map<String, Map<String, List<String>>>
    +initState()
    +fetchSchedule()
    +generateTimes(): List<String>
    +getScheduleColor(String name): Color
    +build(BuildContext context): Widget
  }

  class API {
    +GET /api/major : List<Major>
    +GET /api/students : List<Student>
    +GET /api/classes : List<Class>
    +GET /api/schedule : List<Schedule>
  }

  class Student {
    +name: String
  }

  class Major {
    +major_name: String
  }

  class Class {
    +class_name: String
  }

  class Schedule {
    +name: String
    +day: String
    +schedules: String
  }

  MyApp --> MyHomePage
  MyHomePage --> _MyHomePageState
  SchedulePage --> _SchedulePageState
  _MyHomePageState --> API
  _SchedulePageState --> API
  API --> Student
  API --> Major
  API --> Class
  API --> Schedule
```

### 3.✅ Instructions 
