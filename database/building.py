
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
    CREATE TABLE IF NOT EXISTS building (
        id_building INT AUTO_INCREMENT PRIMARY KEY,
        building_name VARCHAR(100),
        floor_number INT,
        room_number INT,
        room_capacity INT
    )
""")
# Insertar datos
cursor.execute("INSERT INTO building (building_name, floor_number, room_number, room_capacity) VALUES (%s, %s, %s, %s)", ("Science Hall", 1, 122, 24))
cursor.execute("INSERT INTO building (building_name, floor_number, room_number, room_capacity) VALUES (%s, %s, %s, %s)", ("Science Hall", 1, 121, 28))
cursor.execute("INSERT INTO building (building_name, floor_number, room_number, room_capacity) VALUES (%s, %s, %s, %s)", ("Science Hall", 1, 125, 48))
cursor.execute("INSERT INTO building (building_name, floor_number, room_number, room_capacity) VALUES (%s, %s, %s, %s)", ("Science Hall", 1, 126, 20))
cursor.execute("INSERT INTO building (building_name, floor_number, room_number, room_capacity) VALUES (%s, %s, %s, %s)", ("Science Hall", 1, 162, 10))
cursor.execute("INSERT INTO building (building_name, floor_number, room_number, room_capacity) VALUES (%s, %s, %s, %s)", ("Science Hall", 1, 175, 30))

conexion.commit()  # Confirmar cambios