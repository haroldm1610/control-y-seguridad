from mysql.connector import Error
from db_config import get_connection


def ejecutar_ddl():
    sentencias_ddl = [
        "USE ControlAcceso",
        # Tabla temporal de prueba
        """
        CREATE TABLE IF NOT EXISTS tabla_prueba (
            id_prueba INT AUTO_INCREMENT PRIMARY KEY,
            descripcion VARCHAR(100) NOT NULL
        )
        """,
        # Modificaciones estructurales
        "ALTER TABLE persona ADD COLUMN fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP",
        "ALTER TABLE credencial ADD COLUMN ultima_validacion DATETIME NULL",
        # Creación de índices para optimización de búsquedas
        "CREATE INDEX ix_evento_fecha ON evento_acceso (fecha_hora)",
        "CREATE INDEX ix_evento_cred_fecha ON evento_acceso (id_credencial, fecha_hora)",
        # Eliminación de la tabla de prueba
        "DROP TABLE IF EXISTS tabla_prueba",
    ]

    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        for sql in sentencias_ddl:
            cursor.execute(sql)
        conn.commit()
        print("DDL ejecutado correctamente.")
    except Error as e:
        if conn:
            conn.rollback()
        print(f"Error en DDL: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()


if __name__ == "__main__":
    ejecutar_ddl()