#Professors
#    Name
#    Last Name
#    Start time of work
#    End time of work

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
    CREATE TABLE IF NOT EXISTS professor (
        id_professor INT AUTO_INCREMENT PRIMARY KEY,
        professor_name VARCHAR(50),
        professor_last_name VARCHAR(50),
        professor_email VARCHAR(50),
        professor_start_time VARCHAR(5), 
        professor_end_time VARCHAR(5)
    )
""")
# Insertar datos
cursor.execute("INSERT INTO professor (professor_name, professor_last_name, professor_email, professor_start_time, professor_end_time) VALUES (%s, %s,%s, %s, %s)", ("Jeff", "Lehman", "jlehman@huntington.edu", "08:00", "17:00"))
cursor.execute("INSERT INTO professor (professor_name, professor_last_name, professor_email, professor_start_time, professor_end_time) VALUES (%s, %s,%s, %s, %s)", ("Kevin", "Drury", "kdrury@huntington.edu", "08:00", "17:00"))
cursor.execute("INSERT INTO professor (professor_name, professor_last_name, professor_email, professor_start_time, professor_end_time) VALUES (%s, %s,%s, %s, %s)", ("Debby", "Cherry", "cherryd@huntington.edu", "08:00", "17:00"))
cursor.execute("INSERT INTO professor (professor_name, professor_last_name, professor_email, professor_start_time, professor_end_time) VALUES (%s, %s,%s, %s, %s)", ("An", "Hoffman", "horrmana@huntington.edu", "08:00", "17:00"))
cursor.execute("INSERT INTO professor (professor_name, professor_last_name, professor_email, professor_start_time, professor_end_time) VALUES (%s, %s,%s, %s, %s)", ("Mat", "Wright", "wrightm@huntington.edu", "08:00", "17:00"))
#cursor.execute("INSERT INTO professor (professor_name, professor_last_name, professor_email, professor_start_time, professor_end_time) VALUES (%s, %s,%s, %s, %s)", ("Ru", "Nalliah", "nalliahru@huntington.edu", "08:00", "17:00"))
#cursor.execute("INSERT INTO professor (professor_name, professor_last_name, professor_email, professor_start_time, professor_end_time) VALUES (%s, %s,%s, %s, %s)", ("STAFF", "", "@huntington.edu", "08:00", "17:00"))
#cursor.execute("INSERT INTO professor (professor_name, professor_last_name, professor_email, professor_start_time, professor_end_time) VALUES (%s, %s,%s, %s, %s)", ("Mic", "Rowley", "rowleym@huntington.edu", "08:00", "17:00"))

conexion.commit()  # Confirmar cambios
# Cerrar la conexión
cursor.close()
conexion.close()