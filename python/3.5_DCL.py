-- 3.5 DCL (Data Control Language)
from mysql.connector import Error
from db_config import get_connection


def configurar_permisos_y_usuarios():
    sentencias_dcl = [
        "USE ControlAcceso",
        # Usuario para generación de reportes (solo lectura)
        "CREATE USER IF NOT EXISTS 'acceso_reportes'@'localhost' IDENTIFIED BY 'Reportes#2026'",
        "GRANT SELECT ON ControlAcceso.* TO 'acceso_reportes'@'localhost'",
        # Usuario operador (lectura, inserción y actualización)
        "CREATE USER IF NOT EXISTS 'acceso_operador'@'localhost' IDENTIFIED BY 'Operador#2026'",
        "GRANT SELECT, INSERT, UPDATE ON ControlAcceso.* TO 'acceso_operador'@'localhost'",
        "REVOKE DELETE ON ControlAcceso.* FROM 'acceso_operador'@'localhost'",
        "FLUSH PRIVILEGES",
    ]

    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        for sql in sentencias_dcl:
            cursor.execute(sql)
        conn.commit()
        print("Usuarios y privilegios configurados correctamente.")

        print("\n--- Grants para 'acceso_reportes'@'localhost' ---")
        cursor.execute("SHOW GRANTS FOR 'acceso_reportes'@'localhost'")
        for grant in cursor.fetchall():
            print(grant[0])

        print("\n--- Grants para 'acceso_operador'@'localhost' ---")
        cursor.execute("SHOW GRANTS FOR 'acceso_operador'@'localhost'")
        for grant in cursor.fetchall():
            print(grant[0])
    except Error as e:
        if conn:
            conn.rollback()
        print(f"Error en DCL: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()


if __name__ == "__main__":
    configurar_permisos_y_usuarios()