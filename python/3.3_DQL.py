from mysql.connector import Error
from db_config import get_connection


def historial_accesos_por_documento(numero_documento: str) -> list[dict]:
    sql = """
        SELECT
            p.numero_documento,
            p.nombres,
            p.apellidos,
            e.fecha_hora,
            z.nombre AS zona,
            e.direccion,
            e.resultado,
            e.motivo
        FROM evento_acceso e
        JOIN credencial c ON c.id_credencial = e.id_credencial
        JOIN persona p ON p.id_persona = c.id_persona
        JOIN punto_acceso pa ON pa.id_punto = e.id_punto
        JOIN zona z ON z.id_zona = pa.id_zona
        WHERE p.numero_documento = %s
        ORDER BY e.fecha_hora DESC
    """
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(sql, (numero_documento,))
        return cursor.fetchall()
    except Error as e:
        print(f"Error en Consulta 1: {e}")
        return []
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()


def intentos_denegados_por_fecha_y_zona() -> list[dict]:
    sql = """
        SELECT
            DATE(e.fecha_hora) AS fecha,
            z.nombre AS zona,
            COUNT(*) AS total_denegados
        FROM evento_acceso e
        JOIN punto_acceso pa ON pa.id_punto = e.id_punto
        JOIN zona z ON z.id_zona = pa.id_zona
        WHERE e.resultado = 'DENEGADO'
        GROUP BY DATE(e.fecha_hora), z.nombre
        ORDER BY fecha DESC, total_denegados DESC
    """
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(sql)
        return cursor.fetchall()
    except Error as e:
        print(f"Error en Consulta 2: {e}")
        return []
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()


def alertas_alta_o_critica_abiertas() -> list[dict]:
    sql = """
        SELECT
            a.id_alerta,
            a.fecha_generacion,
            a.prioridad,
            ta.nombre AS tipo_alerta,
            pa.nombre AS punto_acceso,
            a.observacion
        FROM alerta a
        JOIN tipo_alerta ta ON ta.id_tipo_alerta = a.id_tipo_alerta
        JOIN evento_acceso e ON e.id_evento = a.id_evento
        JOIN punto_acceso pa ON pa.id_punto = e.id_punto
        WHERE a.estado != 'CERRADA' AND a.prioridad IN ('ALTA', 'CRITICA')
        ORDER BY a.fecha_generacion DESC
    """
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(sql)
        return cursor.fetchall()
    except Error as e:
        print(f"Error en Consulta 3: {e}")
        return []
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()


if __name__ == "__main__":
    print("--- Consulta 1: Historial de accesos ---")
    for fila in historial_accesos_por_documento("1020304050"):
        print(fila)

    print("\n--- Consulta 2: Intentos denegados por fecha y zona ---")
    for fila in intentos_denegados_por_fecha_y_zona():
        print(fila)

    print("\n--- Consulta 3: Alertas ALTA o CRITICA no cerradas ---")
    for fila in alertas_alta_o_critica_abiertas():
        print(fila)