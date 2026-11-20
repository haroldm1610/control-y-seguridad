from mysql.connector import Error
from db_config import get_connection


def registrar_evento_y_alerta_transaccional(
    id_credencial: int = 1,
    id_punto: int = 1,
    id_dispositivo: int = 1,
    direccion: str = "ENTRADA",
    resultado: str = "PERMITIDO",
    motivo: str = "Acceso correcto",
    id_tipo_alerta: int = 1,
    prioridad: str = "BAJA",
    estado: str = "ABIERTA",
    observacion: str = "Evento registrado correctamente",
):
    sql_evento = """
        INSERT INTO evento_acceso (
            id_credencial, id_punto, id_dispositivo, fecha_hora, direccion, resultado, motivo
        )
        VALUES (%s, %s, %s, NOW(), %s, %s, %s)
    """
    sql_alerta = """
        INSERT INTO alerta (
            id_evento, id_tipo_alerta, prioridad, estado, fecha_generacion, observacion
        )
        VALUES (LAST_INSERT_ID(), %s, %s, %s, NOW(), %s)
    """

    conn = None
    try:
        conn = get_connection()
        conn.autocommit = False  # Equivalente a START TRANSACTION
        cursor = conn.cursor()

        # Registrar intento de acceso
        cursor.execute(
            sql_evento,
            (id_credencial, id_punto, id_dispositivo, direccion, resultado, motivo),
        )

        # SAVEPOINT sp_evento_registrado
        cursor.execute("SAVEPOINT sp_evento_registrado")

        # Registrar alerta en la misma transacción si aplica
        cursor.execute(
            sql_alerta,
            (id_tipo_alerta, prioridad, estado, observacion),
        )

        conn.commit()
        print("Transacción completada con COMMIT.")
    except Error as e:
        if conn:
            conn.rollback()
        print(f"Error en transacción (ROLLBACK aplicado): {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()


def ejemplo_rollback_bloqueo_persona(id_persona: int = 1):
    sql_bloquear = """
        UPDATE persona
        SET estado = 'BLOQUEADO'
        WHERE id_persona = %s
    """
    conn = None
    try:
        conn = get_connection()
        conn.autocommit = False  # Equivalente a START TRANSACTION
        cursor = conn.cursor()

        cursor.execute(sql_bloquear, (id_persona,))
        print(f"Filas afectadas antes de ROLLBACK: {cursor.rowcount}")

        # Ejemplo de Rollback en caso de prueba fallida
        conn.rollback()
        print("ROLLBACK ejecutado correctamente; cambios revertidos.")
    except Error as e:
        if conn:
            conn.rollback()
        print(f"Error durante ejemplo de ROLLBACK: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()


if __name__ == "__main__":
    registrar_evento_y_alerta_transaccional()
    ejemplo_rollback_bloqueo_persona(id_persona=1)
 
