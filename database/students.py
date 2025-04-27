#Student
#  Name
#   Last Name
#   Email
#   Year
#   Major

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
    CREATE TABLE IF NOT EXISTS students (
        id_student INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100),
        last_name VARCHAR(100),
        email VARCHAR(100),
        year INT,
        id_major INT,
        id_minor INT,
        FOREIGN KEY (id_major) REFERENCES majors(id_major)
    )
""")
# Insertar datos
cursor.execute("INSERT INTO students (name, last_name, email, year, id_major, id_minor) VALUES (%s, %s,%s, %s, %s, %s)", ("Isabella", "Herrera", "herrerai@huntington.edu", 3, 1, 0))
cursor.execute("INSERT INTO students (name, last_name, email, year, id_major, id_minor) VALUES (%s, %s,%s, %s, %s, %s)", ("Andres", "Jimenez", "jimeneza@huntington.edu", 4, 1, 2))
cursor.execute("INSERT INTO students (name, last_name, email, year, id_major, id_minor) VALUES (%s, %s,%s, %s, %s, %s)", ("Chidiebere", "Emenike", "emenikec@huntington.edu", 2, 2, 0))
cursor.execute("INSERT INTO students (name, last_name, email, year, id_major, id_minor) VALUES (%s, %s,%s, %s, %s, %s)", ("Leland", "Jones", "jonesl@huntington.edu",3 , 1, 0))
cursor.execute("INSERT INTO students (name, last_name, email, year, id_major, id_minor) VALUES (%s, %s,%s, %s, %s, %s)", ("Dylan", "Neese", "neesed@huntington.edu", 2, 1, 4))
cursor.execute("INSERT INTO students (name, last_name, email, year, id_major, id_minor) VALUES (%s, %s,%s, %s, %s, %s)", ("Ann", "Wahl", "wahla@huntington.edu", 2, 2, 2))
cursor.execute("INSERT INTO students (name, last_name, email, year, id_major, id_minor) VALUES (%s, %s,%s, %s, %s, %s)", ("Clay", "Wieringa", "herrerai@huntington.edu", 3, 1, 5))

conexion.commit()  # Confirmar cambios