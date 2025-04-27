import mysql.connector

# Conectar a la base de datos
conexion = mysql.connector.connect(
    host="localhost",       # Dirección del servidor MySQL
    user="root",      # Usuario de MySQL
    password="Isaprojects2025@", # Contraseña del usuario
    database="db_schedules" # Base de datos a usar
)

# Crear un cursor para ejecutar consultas
cursor = conexion.cursor()

# Crear una tabla si no existe
cursor.execute("""
    CREATE TABLE IF NOT EXISTS year (
        id_year INT AUTO_INCREMENT PRIMARY KEY,
        name_year VARCHAR(100)
    )
""")
# Insertar datos
cursor.execute("INSERT INTO year (name_year) VALUES ('Freshman')")
cursor.execute("INSERT INTO year (name_year) VALUES ('Sophomore')")
cursor.execute("INSERT INTO year (name_year) VALUES ('Junior')")
cursor.execute("INSERT INTO year (name_year) VALUES ('Senior')")

conexion.commit()  # Confirmar cambios
# Cerrar la conexión
cursor.close()
conexion.close()