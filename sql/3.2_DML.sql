-- 3.2 DML (Data Manipulation Language)
USE ControlAcceso;

-- Modificación de estado de persona
UPDATE persona
SET estado = 'INACTIVO'
WHERE id_persona = 3;

-- Modificación de estado de dispositivo
UPDATE dispositivo
SET estado = 'MANTENIMIENTO'
WHERE id_dispositivo = 1;

-- Eliminación de un permiso específico
DELETE FROM permiso
WHERE id_persona = 1 AND id_zona = 2;