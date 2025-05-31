-- Organización y limpieza del script SQL para mayor claridad y mantenimiento

-- 1. CREACIÓN DE BASE DE DATOS Y USO
CREATE DATABASE IF NOT EXISTS baseDatosCitasMedicas252;
USE baseDatosCitasMedicas252;

-- 2. TABLAS PRINCIPALES
-- Usuarios (pacientes, especialistas, administradores)
CREATE TABLE IF NOT EXISTS Usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    correo VARCHAR(150) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    usuario_generado VARCHAR(100) UNIQUE,
    tipo_usuario ENUM('especialista', 'paciente', 'administrador') NOT NULL
);

-- Especialistas (datos adicionales)
CREATE TABLE IF NOT EXISTS Especialista (
    id_usuario INT PRIMARY KEY,
    especialidad VARCHAR(100),
    numero_tarjeta_profesional VARCHAR(50) UNIQUE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id)
);

-- Administradores (datos adicionales)
CREATE TABLE IF NOT EXISTS Administrador (
    id_usuario INT PRIMARY KEY,
    -- Campos adicionales si se requieren
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id)
);

-- Citas médicas
CREATE TABLE IF NOT EXISTS Cita (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT NOT NULL,
    id_especialista INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    motivo VARCHAR(255),
    estado ENUM('pendiente', 'confirmada', 'cancelada', 'realizada') DEFAULT 'pendiente',
    descripcion TEXT,
    FOREIGN KEY (id_paciente) REFERENCES Usuario(id),
    FOREIGN KEY (id_especialista) REFERENCES Usuario(id)
);

-- Facturación
CREATE TABLE IF NOT EXISTS Factura (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_cita INT NOT NULL,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descripcion TEXT,
    monto DECIMAL(10, 2) NOT NULL,
    estado ENUM('pendiente', 'pagada', 'anulada') DEFAULT 'pendiente',
    FOREIGN KEY (id_cita) REFERENCES Cita(id)
);

-- Catálogo de especialidades
CREATE TABLE IF NOT EXISTS Especialidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

-- Disponibilidad de especialistas
CREATE TABLE IF NOT EXISTS DisponibilidadEspecialista (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_especialista INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    FOREIGN KEY (id_especialista) REFERENCES Usuario(id)
);

-- 3. ÍNDICES PARA OPTIMIZACIÓN
-- Usuario
CREATE INDEX idx_usuario_tipo_usuario ON Usuario (tipo_usuario);
CREATE INDEX idx_usuario_correo ON Usuario (correo);
CREATE INDEX idx_usuario_usuario_generado ON Usuario (usuario_generado);

-- Especialista
CREATE INDEX idx_especialista_especialidad ON Especialista (especialidad);

-- Cita
CREATE INDEX idx_cita_id_paciente ON Cita (id_paciente);
CREATE INDEX idx_cita_id_especialista ON Cita (id_especialista);
CREATE INDEX idx_cita_estado ON Cita (estado);
CREATE INDEX idx_cita_fecha_hora ON Cita (fecha_hora);
CREATE INDEX idx_cita_especialista_fecha_estado ON Cita (id_especialista, fecha_hora, estado);

-- Factura
CREATE INDEX idx_factura_id_cita ON Factura (id_cita);
CREATE INDEX idx_factura_estado ON Factura (estado);

-- DisponibilidadEspecialista
CREATE INDEX idx_disponibilidad_id_especialista ON DisponibilidadEspecialista (id_especialista);
CREATE INDEX idx_disponibilidad_fecha ON DisponibilidadEspecialista (fecha);
CREATE INDEX idx_disponibilidad_especialista_fecha_horas ON DisponibilidadEspecialista (id_especialista, fecha, hora_inicio, hora_fin);

-- 4. DATOS DE EJEMPLO (Administrador por defecto)
INSERT INTO Usuario (nombre, apellidos, telefono, direccion, correo, contrasena, usuario_generado, tipo_usuario)
VALUES (
  'Administrador', 'Principal', '0000000000', 'Oficina Central', 'admin01@admin.com',
  '$2a$12$FwVPrXOwYi7TYAtV9cdYX.wv5hW0JqdT/dD4aEBTTRHIOAo.YPF1u',
  'admin01', 'administrador'
);
