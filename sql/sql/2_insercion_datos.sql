-- 2. INSERCIÓN DE DATOS INICIALES DE PRUEBA
USE ControlAcceso;

INSERT INTO persona (tipo_documento, numero_documento, nombres, apellidos, tipo_persona, estado) VALUES 
('CC', '1020304050', 'Sofia', 'Ramirez', 'ESTUDIANTE', 'ACTIVO'),
('CC', '1098765432', 'Carlos', 'Mendoza', 'EMPLEADO', 'ACTIVO'),
('CE', '5544332211', 'Ana', 'Gomez', 'VISITANTE', 'ACTIVO');

INSERT INTO tipo_credencial (nombre) VALUES 
('TARJETA'), 
('BIOMETRIA');

INSERT INTO credencial (id_persona, id_tipo, identificador, plantilla_hash, estado, fecha_emision, fecha_vencimiento) VALUES 
(1, 1, 'TAG-998877', NULL, 'ACTIVA', '2026-01-01', '2027-01-01'),
(2, 2, 'BIO-112233', 'hash_ejemplo_seguro_123', 'ACTIVA', '2026-02-01', '2028-02-01');

INSERT INTO zona (nombre, nivel_seguridad) VALUES 
('Entrada Principal', 1),
('Laboratorios de Sistemas', 3),
('Servidores / Data Center', 5);

INSERT INTO punto_acceso (id_zona, nombre, ubicacion, estado) VALUES 
(1, 'Molinete A1', 'Bloque A - Piso 1', 'ACTIVO'),
(2, 'Puerta Lab 201', 'Bloque B - Piso 2', 'ACTIVO'),
(3, 'Acceso Blindado DC', 'Sótano 1', 'ACTIVO');

INSERT INTO dispositivo (id_punto, serial, tipo, estado) VALUES 
(1, 'SN-MOL-001', 'LECTOR_TARJETA', 'OPERATIVO'),
(2, 'SN-BIO-002', 'LECTOR_BIOMETRICO', 'OPERATIVO'),
(3, 'SN-MIX-003', 'MIXTO', 'OPERATIVO');

INSERT INTO permiso (id_persona, id_zona, fecha_inicio, fecha_fin, hora_inicio, hora_fin, dias_semana, estado) VALUES 
(1, 1, '2026-01-01', '2026-12-31', '06:00:00', '22:00:00', 'L-V', 'ACTIVO'),
(2, 3, '2026-01-01', '2026-12-31', '00:00:00', '23:59:59', 'L-D', 'ACTIVO');

INSERT INTO evento_acceso (id_credencial, id_punto, id_dispositivo, fecha_hora, direccion, resultado, motivo) VALUES 
(1, 1, 1, '2026-06-01 07:30:00', 'ENTRADA', 'PERMITIDO', 'Acceso autorizado'),
(1, 3, 3, '2026-06-01 08:00:00', 'ENTRADA', 'DENEGADO', 'Nivel de seguridad no autorizado');

INSERT INTO tipo_alerta (nombre, descripcion) VALUES 
('Acceso No Autorizado', 'Intento de ingreso a zona restringida sin permisos'),
('Credencial Vencida', 'Uso de tarjeta o biometría expirada');

INSERT INTO alerta (id_evento, id_tipo_alerta, prioridad, estado, fecha_generacion, observacion) VALUES 
(2, 1, 'ALTA', 'ABIERTA', '2026-06-01 08:00:00', 'Estudiante intentó ingresar a Data Center');