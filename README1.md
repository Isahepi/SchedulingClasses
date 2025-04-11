# SchedulingClasses

This project manages class schedules for students and professors.
# Database Model

## 📊 UML Diagram

```mermaid
classDiagram
    class Course {
        +int id_classes
        +varchar course_number
        +varchar class_name
        +int class_credit
    }

    class MajorClasses {
        +int id_majorclasses
        +int id_major
        +int id_classes
    }

    class Major {
        +int id_major
        +varchar major_name
    }

    class Student {
        +int id
        +varchar name
        +varchar last_name
        +varchar email
        +int year
        +varchar major
        +varchar minor
    }

    Course --> MajorClasses : "has"
    MajorClasses --> Major : "belongs to"
    MajorClasses --> Course : "includes"
    Student --> Major : "pursues"

