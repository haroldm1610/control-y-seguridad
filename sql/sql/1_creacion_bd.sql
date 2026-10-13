-- 1. CREACIÓN DE LA BASE DE DATOS Y TABLAS BASE
CREATE DATABASE IF NOT EXISTS ControlAcceso DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE ControlAcceso;

CREATE TABLE persona (
    id_persona INT AUTO_INCREMENT PRIMARY KEY,
    tipo_documento VARCHAR(10) NOT NULL,
    numero_documento VARCHAR(30) NOT NULL UNIQUE,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    tipo_persona VARCHAR(20) NOT NULL,
    estado VARCHAR(12) NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE tipo_credencial (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE credencial (
    id_credencial INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL,
    id_tipo INT NOT NULL,
    identificador VARCHAR(120) NOT NULL UNIQUE,
    plantilla_hash VARCHAR(255),
    estado VARCHAR(12) NOT NULL,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE,
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona),
    FOREIGN KEY (id_tipo) REFERENCES tipo_credencial(id_tipo)
);

CREATE TABLE zona (
    id_zona INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    nivel_seguridad INT NOT NULL
);

CREATE TABLE punto_acceso (
    id_punto INT AUTO_INCREMENT PRIMARY KEY,
    id_zona INT NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    ubicacion VARCHAR(150) NOT NULL,
    estado VARCHAR(12) NOT NULL DEFAULT 'ACTIVO',
    FOREIGN KEY (id_zona) REFERENCES zona(id_zona),
    UNIQUE (id_zona, nombre)
);

CREATE TABLE dispositivo (
    id_dispositivo INT AUTO_INCREMENT PRIMARY KEY,
    id_punto INT NOT NULL,
    serial VARCHAR(60) NOT NULL UNIQUE,
    tipo VARCHAR(20) NOT NULL,
    estado VARCHAR(15) NOT NULL DEFAULT 'OPERATIVO',
    FOREIGN KEY (id_punto) REFERENCES punto_acceso(id_punto)
);

CREATE TABLE permiso (
    id_permiso INT AUTO_INCREMENT PRIMARY KEY,
    id_persona INT NOT NULL,
    id_zona INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    dias_semana VARCHAR(20) NOT NULL,
    estado VARCHAR(12) NOT NULL DEFAULT 'ACTIVO',
    FOREIGN KEY (id_persona) REFERENCES persona(id_persona),
    FOREIGN KEY (id_zona) REFERENCES zona(id_zona)
);

CREATE TABLE evento_acceso (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    id_credencial INT,
    id_punto INT NOT NULL,
    id_dispositivo INT,
    fecha_hora DATETIME NOT NULL,
    direccion VARCHAR(7) NOT NULL,
    resultado VARCHAR(9) NOT NULL,
    motivo VARCHAR(120) NOT NULL,
    FOREIGN KEY (id_credencial) REFERENCES credencial(id_credencial),
    FOREIGN KEY (id_punto) REFERENCES punto_acceso(id_punto),
    FOREIGN KEY (id_dispositivo) REFERENCES dispositivo(id_dispositivo)
);

CREATE TABLE tipo_alerta (
    id_tipo_alerta INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL UNIQUE,
    descripcion VARCHAR(200)
);

CREATE TABLE alerta (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    id_evento INT NOT NULL,
    id_tipo_alerta INT NOT NULL,
    prioridad VARCHAR(8) NOT NULL,
    estado VARCHAR(12) NOT NULL DEFAULT 'ABIERTA',
    fecha_generacion DATETIME NOT NULL,
    observacion VARCHAR(300),
    FOREIGN KEY (id_evento) REFERENCES evento_acceso(id_evento),
    FOREIGN KEY (id_tipo_alerta) REFERENCES tipo_alerta(id_tipo_alerta)
);