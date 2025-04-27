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
    CREATE TABLE IF NOT EXISTS majors (
        id_major INT AUTO_INCREMENT PRIMARY KEY,
        major_name VARCHAR(100)
    )
""")
# Insertar datos
cursor.execute("INSERT INTO majors (major_name) VALUES (%s)", ("Computer Science",))
cursor.execute("INSERT INTO majors (major_name) VALUES (%s)", ("Math",))
cursor.execute("INSERT INTO majors (major_name) VALUES (%s)", ("Business Finance",))
cursor.execute("INSERT INTO majors (major_name) VALUES (%s)", ("Business Managment",))
cursor.execute("INSERT INTO majors (major_name) VALUES (%s)", ("Entrepeneurship",))
cursor.execute("INSERT INTO majors (major_name) VALUES (%s)", ("Business Marketing",))






conexion.commit()  # Confirmar cambios


# Cerrar la conexión
cursor.close()
conexion.close()