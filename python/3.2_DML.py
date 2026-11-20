from mysql.connector import Error
from db_config import get_connection


def actualizar_estado_persona(id_persona: int, estado: str):
    sql = """
        UPDATE persona
        SET estado = %s
        WHERE id_persona = %s
    """
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(sql, (estado, id_persona))
        conn.commit()
        print(f"Filas actualizadas en persona ({id_persona}): {cursor.rowcount}")
    except Error as e:
        if conn:
            conn.rollback()
        print(f"Error al actualizar persona: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()


def actualizar_estado_dispositivo(id_dispositivo: int, estado: str):
    sql = """
        UPDATE dispositivo
        SET estado = %s
        WHERE id_dispositivo = %s
    """
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(sql, (estado, id_dispositivo))
        conn.commit()
        print(f"Filas actualizadas en dispositivo ({id_dispositivo}): {cursor.rowcount}")
    except Error as e:
        if conn:
            conn.rollback()
        print(f"Error al actualizar dispositivo: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()


def eliminar_permiso(id_persona: int, id_zona: int):
    sql = """
        DELETE FROM permiso
        WHERE id_persona = %s AND id_zona = %s
    """
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(sql, (id_persona, id_zona))
        conn.commit()
        print(f"Permisos eliminados: {cursor.rowcount}")
    except Error as e:
        if conn:
            conn.rollback()
        print(f"Error al eliminar permiso: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()


if __name__ == "__main__":
    # Modificación de estado de persona
    actualizar_estado_persona(id_persona=3, estado="INACTIVO")

    # Modificación de estado de dispositivo
    actualizar_estado_dispositivo(id_dispositivo=1, estado="MANTENIMIENTO")

    # Eliminación de un permiso específico
    eliminar_permiso(id_persona=1, id_zona=2)