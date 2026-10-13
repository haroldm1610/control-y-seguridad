-- 3.1 DDL (Data Definition Language)
USE ControlAcceso;

-- Tabla temporal de prueba
CREATE TABLE IF NOT EXISTS tabla_prueba (
    id_prueba INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(100) NOT NULL
);

-- Modificaciones estructurales
ALTER TABLE persona ADD COLUMN fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE credencial ADD COLUMN ultima_validacion DATETIME NULL;

-- Creación de índices para optimización de búsquedas
CREATE INDEX ix_evento_fecha ON evento_acceso (fecha_hora);
CREATE INDEX ix_evento_cred_fecha ON evento_acceso (id_credencial, fecha_hora);

-- Eliminación de la tabla de prueba
DROP TABLE IF EXISTS tabla_prueba;