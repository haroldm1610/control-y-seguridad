-- 3.6 TCL (Transaction Control Language)
USE ControlAcceso;
 
START TRANSACTION;
 
-- Registrar intento de acceso
INSERT INTO evento_acceso (id_credencial, id_punto, id_dispositivo, fecha_hora, direccion, resultado, motivo)
VALUES (1, 1, 1, NOW(), 'ENTRADA', 'PERMITIDO', 'Acceso correcto');
 
SAVEPOINT sp_evento_registrado;
 
-- Registrar alerta en la misma transacción si aplica
INSERT INTO alerta (id_evento, id_tipo_alerta, prioridad, estado, fecha_generacion, observacion)
VALUES (LAST_INSERT_ID(), 1, 'BAJA', 'ABIERTA', NOW(), 'Evento registrado correctamente');
 
COMMIT;
 
-- Ejemplo de Rollback en caso de prueba fallida
START TRANSACTION;
 
UPDATE persona
SET estado = 'BLOQUEADO'
WHERE id_persona = 1;
 
ROLLBACK;
 
