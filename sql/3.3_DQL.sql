-- 3.3 DQL (Data Query Language)
USE ControlAcceso;

-- Consulta 1: Historial de accesos por documento de persona
SELECT p.numero_documento, p.nombres, p.apellidos, e.fecha_hora, z.nombre AS zona, e.direccion, e.resultado, e.motivo
FROM evento_acceso e
JOIN credencial c ON c.id_credencial = e.id_credencial
JOIN persona p ON p.id_persona = c.id_persona
JOIN punto_acceso pa ON pa.id_punto = e.id_punto
JOIN zona z ON z.id_zona = pa.id_zona
WHERE p.numero_documento = '1020304050'
ORDER BY e.fecha_hora DESC;

-- Consulta 2: Intentos denegados por fecha y zona
SELECT DATE(e.fecha_hora) AS fecha, z.nombre AS zona, COUNT(*) AS total_denegados
FROM evento_acceso e
JOIN punto_acceso pa ON pa.id_punto = e.id_punto
JOIN zona z ON z.id_zona = pa.id_zona
WHERE e.resultado = 'DENEGADO'
GROUP BY DATE(e.fecha_hora), z.nombre
ORDER BY fecha DESC, total_denegados DESC;

-- Consulta 3: Alertas de prioridad ALTA o CRITICA no cerradas
SELECT a.id_alerta, a.fecha_generacion, a.prioridad, ta.nombre AS tipo_alerta, pa.nombre AS punto_acceso, a.observacion
FROM alerta a
JOIN tipo_alerta ta ON ta.id_tipo_alerta = a.id_tipo_alerta
JOIN evento_acceso e ON e.id_evento = a.id_evento
JOIN punto_acceso pa ON pa.id_punto = e.id_punto
WHERE a.estado != 'CERRADA' AND a.prioridad IN ('ALTA', 'CRITICA')
ORDER BY a.fecha_generacion DESC;