-- 3.5 DCL (Data Control Language)
USE ControlAcceso;

-- Usuario para generación de reportes (solo lectura)
CREATE USER IF NOT EXISTS 'acceso_reportes'@'localhost' IDENTIFIED BY 'Reportes#2026';
GRANT SELECT ON ControlAcceso.* TO 'acceso_reportes'@'localhost';

-- Usuario operador (lectura, inserción y actualización)
CREATE USER IF NOT EXISTS 'acceso_operador'@'localhost' IDENTIFIED BY 'Operador#2026';
GRANT SELECT, INSERT, UPDATE ON ControlAcceso.* TO 'acceso_operador'@'localhost';
REVOKE DELETE ON ControlAcceso.* FROM 'acceso_operador'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'acceso_reportes'@'localhost';
SHOW GRANTS FOR 'acceso_operador'@'localhost';