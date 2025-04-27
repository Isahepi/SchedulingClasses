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
    CREATE TABLE IF NOT EXISTS majorclasses (
        id_majorclasses INT AUTO_INCREMENT PRIMARY KEY,
        id_major INT,
        id_class INT,
        FOREIGN KEY (id_major) REFERENCES majors(id_major),
        FOREIGN KEY (id_class) REFERENCES classes(id_class)
    )
""")
# Insertar datos
#COMPUTER SCIENCE
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (1, 1))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (1, 2))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (1, 3))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (1, 4))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (1, 5))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (1, 6))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (1, 7))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (1, 8))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (1, 9))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (1, 10))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (1, 11))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (1, 12))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (1, 13))
#MATH

#BUSINESS FINANCE
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (3, 8))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (3, 9))

#BSUINESS MANAGMENT
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (3, 8))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (3, 9))

#ENTREPENEURSHIP
#BUSINESS MARKETING
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (3, 8))
cursor.execute("INSERT INTO majorclasses (id_major, id_class) VALUES (%s, %s)", (3, 9))



conexion.commit()  # Confirmar cambios