import mysql.connector

# Conectar a la base de datos
conexion = mysql.connector.connect(
    host="localhost",       # Dirección del servidor MySQL
    user="root",      # Usuario de MySQL
    password="Isaprojects2025", # Contraseña del usuario
    database="db_schedule" # Base de datos a usar
)

# Crear un cursor para ejecutar consultas
cursor = conexion.cursor()

# Crear una tabla si no existe
cursor.execute("""
    CREATE TABLE classes (
        id_class INT AUTO_INCREMENT PRIMARY KEY,
        course_number VARCHAR(10),
        class_name VARCHAR(100),
        hours INT,
        start_time VARCHAR(100),
        end_time VARCHAR(100),
        year VARCHAR(10),
        days VARCHAR(7),
        id_professor INT,
        FOREIGN KEY (id_professor) REFERENCES professor(id_professor)
    )
""")
# Data of all the classes
course = [
    ("CS111", "Introduction to Computer Science", 3, "09:00", "09:50", "FA'2026","MWF",1),
    ("CS325", "Data Structures & Algorithms",  3, "13:00", "13:50", "FA'2026","MWF",1),
    ("CS415", "Database Managament Systems", 3, "12:00", "13:15", "FA'2026","TR", 1),
    ("CS435", "Sr Proj I: Analysis and Design", 3, "16:00", "17:15", "FA'2026","TR", 5),
    ("MA100A","Mathematical Foundations", 2, "14:00", "14:50", "FA'2026","MW", 3),
    ("MA111", "Analyzing Arithmetic for Eductrs",3, "13:00", "13:50", "FA'2026","MWF", 4),
    ("MA115", "Math for Society/Liberal Arts",3, "09:00", "09:50", "FA'2026","MWF", 4),
    ("MA151", "Intro to Probability and stats",3, "08:00", "08:50", "FA'2026","MWF", 2),
    ("MA151", "Intro to Probability and stats",3, "14:00", "14:50", "FA'2026","MWF", 2),
    ("MA165", "Intro to Discrete Matehmatics", 3, "10:00", "10:50", "FA'2025", "MWF", 2),
    ("MA171", "Calculus I", 4, "14:00", "14:50", "FA'2026","MWRF", 2),
    ("MA205", "Intro to Mathematical Proofs", 2, "10:00", "10:50", "FA'2026","MWF", 4),
    ("MA273", "Calculus III", 4, "15:00", "15:50", "FA'2026","MWRF", 2),
    ("MA411", "Abstract Algebra", 4, "14:00", "14:50", "FA'2026","MTWRF", 4),
    ("MA480", "Seminar in Mathematics Education", 1, "11:00", "11:50", "FA'2026","M", 4)
    #("CH161", "Principles of Chemistry I", 3, "09:00", "09:50", "FA'2025","MWF", 6)
    #("BA281", "Principles of Marketing ", 3, "10:00", "10:50", "FA'2025","MWF", 7)
    #("CO215", "Public Speaking", 3, "09:00", "09:50", "FA'2025","MWF", 8)


]

cursor.executemany("INSERT INTO classes (course_number, class_name, hours, start_time, end_time, year, days, id_professor) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)", course)

# Guardar cambios  
conexion.commit()

# Cerrar conexión
cursor.close()
conexion.close()


#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("CS111", "Introduction to Computer Science", 3, "9:00am", "9:50am", "FA'2026","MWF"))
#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("CS325", "Data Structures & Algorithms",  3, "1:00pm", "1:50pm", "FA'2026","MWF"))
#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("CS415", "Database Managament Systems", 3, "12:00", "1:15pm", "FA'2026","MWF"))
#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("CS435", "Sr Proj I: Analysis and Design", 3, "4:00", "5:15pm", "FA'2026","TR"))
#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("MA100A", "Mathematical Foundations", 2, "2:00", "2:50am", "FA'2026","MW"))
#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("MA111", "Analyzing Arithmetic for Eductrs",3, "1:00", "1:50am", "FA'2026","MWF"))
#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("MA115", "Math for Society/Liberal Arts",3, "9:00", "9:50am", "FA'2026","MWF"))
#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("MA151", "Intro to Probability and stats",3, "8:00", "8:50pm", "FA'2026","MWF"))
#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("MA151", "Intro to Probability and stats",3, "2:00", "2:50pm", "FA'2026","MWF"))
#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("MA171", "Calculus I", 4, "2:00", "2:50pm", "FA'2026","MWRF", "Science Hall", 121))
#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("MA205", "Intro to Mathematical Proofs", 2, "10:00am", "10:50am", "FA'2026","MWF"))
#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("MA273", "Calculus III", 4, "3:00", "3:50pm", "FA'2026","MWRF"))
#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("MA411", "Abstract Algebra", 4, "2:00", "2:50PM", "FA'2026","MTWRF"))
#cursor.execute("INSERT INTO course (course_number, name, hours, start_time, end_time, year, days) VALUES (%s, %s, %s, %s, %s, %s, %s)", ("MA480", "Seminar in Mathematics Education", 1, "11:00", "11:50am", "FA'2026","M"))


