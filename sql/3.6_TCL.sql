-- 3.6 TCL (Transaction Control Language)
-- Proyecto: Sistema de Control de Acceso y Seguridad Institucional
-- Motor: MySQL / MariaDB
 
USE ControlAcceso;
 
-- =========================================================
-- 1. START TRANSACTION y COMMIT
-- Registrar un intento de acceso y su alerta en una sola
-- transaccion. Si ambas operaciones funcionan, se confirman.
-- Los IDs usados corresponden a los datos de prueba iniciales.
-- =========================================================
 
START TRANSACTION;
 
INSERT INTO evento_acceso
    (id_credencial, id_punto, id_dispositivo, fecha_hora,
     direccion, resultado, motivo)
VALUES
    (1, 3, 3, NOW(), 'ENTRADA', 'DENEGADO',
     'Prueba TCL: intento de acceso no autorizado');
 
-- LAST_INSERT_ID() obtiene el ID del evento recién creado.
SET @id_evento_tcl = LAST_INSERT_ID();
 
INSERT INTO alerta
    (id_evento, id_tipo_alerta, prioridad, estado,
     fecha_generacion, observacion)
VALUES
    (@id_evento_tcl, 1, 'ALTA', 'ABIERTA', NOW(),
     'Alerta generada durante la prueba de transacciones TCL');
 
-- Confirma el evento y la alerta como una sola unidad de trabajo.
COMMIT;
 
 
-- =========================================================
-- 2. ROLLBACK
-- Esta transacción muestra cómo deshacer un cambio.
-- El estado de la persona queda igual que antes de la prueba.
-- =========================================================
 
START TRANSACTION;
 
UPDATE persona
SET estado = 'INACTIVO'
WHERE id_persona = 1;
 
-- Deshace el UPDATE anterior.
ROLLBACK;
 
 
-- =========================================================
-- 3. SAVEPOINT y ROLLBACK TO SAVEPOINT
-- Se modifica temporalmente el dispositivo. Después se vuelve
-- al punto de restauración para cancelar solo ese cambio.
-- =========================================================
 
START TRANSACTION;
 
SAVEPOINT antes_cambio_dispositivo;
 
UPDATE dispositivo
SET estado = 'MANTENIMIENTO'
WHERE id_dispositivo = 1;
 
-- Revierte el UPDATE realizado después del SAVEPOINT.
ROLLBACK TO SAVEPOINT antes_cambio_dispositivo;
 
-- Finaliza la transacción sin conservar el cambio del dispositivo.
COMMIT;
 
 
-- =========================================================
-- 4. Consultas de comprobación
-- Permiten revisar el evento/alerta creados y los estados actuales.
-- =========================================================
 
SELECT id_evento, id_credencial, id_punto, fecha_hora,
       direccion, resultado, motivo
FROM evento_acceso
WHERE motivo = 'Prueba TCL: intento de acceso no autorizado'
ORDER BY id_evento DESC;
 
SELECT id_alerta, id_evento, id_tipo_alerta, prioridad,
       estado, fecha_generacion, observacion
FROM alerta
WHERE observacion =
      'Alerta generada durante la prueba de transacciones TCL'
ORDER BY id_alerta DESC;
 
SELECT id_persona, nombres, apellidos, estado
FROM persona
WHERE id_persona = 1;
 
SELECT id_dispositivo, serial, estado
FROM dispositivo
WHERE id_dispositivo = 1;
