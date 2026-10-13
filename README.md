# Sistema de Control de Acceso y Seguridad Institucional

##  Descripción del Proyecto
Este proyecto implementa el diseño físico y lógico de una base de datos relacional para gestionar el control de acceso y seguridad institucional en MySQL/MariaDB.
Permite administrar personas, credenciales (tarjetas y referencias biométricas), puntos de acceso, permisos por zonas y horarios, registro de intentos y generación de alertas.

## Estructura del Repositorio
sql/
 1_creacion_bd.sql       # Creación de la base de datos y esquema base
 2_insercion_datos.sql   # Inserción de datos iniciales de prueba
 3.1_DDL.sql             # Modificaciones estructurales (ALTER, DROP, INDEX)
 3.2_DML.sql             # Operaciones DML (INSERT, UPDATE, DELETE)
 3.3_DQL.sql             # Consultas de operación y auditoría
 3.4_VDL.sql             # Vistas del sistema
 3.5_DCL.sql             # Creación de usuarios y asignación de permisos
 3.6_TCL.sql             # Control de transacciones y puntos de restauración