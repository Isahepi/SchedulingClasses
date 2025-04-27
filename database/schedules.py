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
    CREATE TABLE schedules (
    id_schedule INT AUTO_INCREMENT PRIMARY KEY,
    id_student INT,
    id_class INT,
    FOREIGN KEY (id_student) REFERENCES students(id_student),
    FOREIGN KEY (id_class) REFERENCES classes(id_class)

    );
""")
# Insert datos
cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (1,2))
cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (1, 3))
cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (1, 4))



# person 2 Andres
cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (2, 1))
cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (2, 5))
cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (2, 6))
cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (2, 7))


#Person 3 Chidi
cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (3, 2))
cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (3, 3))
cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (3, 13))

#Person 5 Dylan (added manually in the workbench)
#cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (5, 8))
#cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (5, 2))
#cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (5, 3))
#cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (5, 16))
#cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (5, 17))

#Person 6 Anna (added manually in the workbench)
#cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (6, 2))
#cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (6, 3))
#cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (6, 17))


#Person 7 Clay (added manually in the workbench)
#cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (7, 2))
#cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (7, 3))
#cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (7, 4))
#cursor.execute("INSERT INTO schedules (id_student, id_class) VALUES (%s, %s)", (7, 18))



conexion.commit()  # Confirmar cambios

# Cerrar la conexión
cursor.close()
conexion.close()