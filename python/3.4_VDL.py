from mysql.connector import Error
from db_config import get_connection


def crear_vistas():
    vistas = [
        # Vista 1: Historial de accesos detallado
        """
        CREATE OR REPLACE VIEW v_accesos_detallados AS
        SELECT
            e.id_evento,
            p.numero_documento,
            CONCAT(p.nombres, ' ', p.apellidos) AS persona,
            z.nombre AS zona,
            pa.nombre AS punto_acceso,
            e.fecha_hora,
            e.direccion,
            e.resultado,
            e.motivo
        FROM evento_acceso e
        JOIN credencial c ON c.id_credencial = e.id_credencial
        JOIN persona p ON p.id_persona = c.id_persona
        JOIN punto_acceso pa ON pa.id_punto = e.id_punto
        JOIN zona z ON z.id_zona = pa.id_zona
        """,
        # Vista 2: Alertas pendientes de atención
        """
        CREATE OR REPLACE VIEW v_alertas_activas AS
        SELECT
            a.id_alerta,
            a.fecha_generacion,
            ta.nombre AS tipo_alerta,
            a.prioridad,
            a.estado,
            a.observacion
        FROM alerta a
        JOIN tipo_alerta ta ON ta.id_tipo_alerta = a.id_tipo_alerta
        WHERE a.estado != 'CERRADA'
        """,
    ]

    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor()
        for vista_sql in vistas:
            cursor.execute(vista_sql)
        conn.commit()
        print("Vistas creadas/actualizadas correctamente.")
    except Error as e:
        if conn:
            conn.rollback()
        print(f"Error al crear vistas: {e}")
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()


def consultar_accesos_detallados() -> list[dict]:
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM v_accesos_detallados ORDER BY fecha_hora DESC")
        return cursor.fetchall()
    except Error as e:
        print(f"Error al consultar v_accesos_detallados: {e}")
        return []
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()


def consultar_alertas_activas() -> list[dict]:
    conn = None
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM v_alertas_activas ORDER BY id_alerta")
        return cursor.fetchall()
    except Error as e:
        print(f"Error al consultar v_alertas_activas: {e}")
        return []
    finally:
        if conn and conn.is_connected():
            cursor.close()
            conn.close()


if __name__ == "__main__":
    crear_vistas()

    print("\n--- v_accesos_detallados ---")
    for row in consultar_accesos_detallados():
        print(row)

    print("\n--- v_alertas_activas ---")
    for row in consultar_alertas_activas():
        print(row)