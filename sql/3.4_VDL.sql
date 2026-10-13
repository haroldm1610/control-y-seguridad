-- 3.4 VDL (View Definition Language)
USE ControlAcceso;

-- Vista 1: Historial de accesos detallado
CREATE OR REPLACE VIEW v_accesos_detallados AS
SELECT e.id_evento, p.numero_documento, CONCAT(p.nombres, ' ', p.apellidos) AS persona, z.nombre AS zona, pa.nombre AS punto_acceso, e.fecha_hora, e.direccion, e.resultado, e.motivo
FROM evento_acceso e
JOIN credencial c ON c.id_credencial = e.id_credencial
JOIN persona p ON p.id_persona = c.id_persona
JOIN punto_acceso pa ON pa.id_punto = e.id_punto
JOIN zona z ON z.id_zona = pa.id_zona;

SELECT * FROM v_accesos_detallados ORDER BY fecha_hora DESC;

-- Vista 2: Alertas pendientes de atención
CREATE OR REPLACE VIEW v_alertas_activas AS
SELECT a.id_alerta, a.fecha_generacion, ta.nombre AS tipo_alerta, a.prioridad, a.estado, a.observacion
FROM alerta a
JOIN tipo_alerta ta ON ta.id_tipo_alerta = a.id_tipo_alerta
WHERE a.estado != 'CERRADA';

SELECT * FROM v_alertas_activas ORDER BY id_alerta;