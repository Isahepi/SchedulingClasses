# SchedulingClasses

This project manages class schedules for students and professors.

## 📊 UML Class Diagram

```mermaid
classDiagram
    class Student {
        +String name
        +int id
        +List<Class> classes
    }

    class Professor {
        +String name
        +int employeeId
        +List<Class> courses
    }

    class Class {
        +String name
        +String time
        +Professor professor
        +List<Student> students
    }

    Student --> Class
    Professor --> Class
