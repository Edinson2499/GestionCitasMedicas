-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS baseDatosCitasMedicas252;

-- Usar la base de datos
USE baseDatosCitasMedicas252;

-- Tabla para Usuarios (combina información de especialistas y pacientes)
CREATE TABLE IF NOT EXISTS Usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    contrasena VARCHAR(255) NOT NULL,
    usuario_generado VARCHAR(100) UNIQUE,
    tipo_usuario ENUM('especialista', 'paciente', 'administrador') NOT NULL
);

-- Tabla para Especialistas (información adicional específica)
CREATE TABLE IF NOT EXISTS Especialista (
    id_usuario INT PRIMARY KEY,
    especialidad VARCHAR(100),
    numero_tarjeta_profesional VARCHAR(50) UNIQUE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id)
);

-- Tabla para Administradores (información adicional específica)
CREATE TABLE IF NOT EXISTS Administrador (
    id_usuario INT PRIMARY KEY,
    -- Puedes agregar campos específicos del administrador aquí si es necesario
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id)
);

-- Tabla para Citas
CREATE TABLE IF NOT EXISTS Cita (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_paciente INT NOT NULL,
    id_especialista INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    motivo VARCHAR(255),
    estado ENUM('pendiente', 'confirmada', 'cancelada', 'realizada') DEFAULT 'pendiente',
    FOREIGN KEY (id_paciente) REFERENCES Usuario(id),
    FOREIGN KEY (id_especialista) REFERENCES Usuario(id)
);

-- Tabla para Facturas
CREATE TABLE IF NOT EXISTS Factura (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_cita INT NOT NULL,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descripcion TEXT,
    monto DECIMAL(10, 2) NOT NULL,
    estado ENUM('pendiente', 'pagada', 'anulada') DEFAULT 'pendiente',
    FOREIGN KEY (id_cita) REFERENCES Cita(id)
);

CREATE TABLE DisponibilidadEspecialista (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_especialista INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    FOREIGN KEY (id_especialista) REFERENCES Usuario(id)
);
SELECT nombre, usuario_generado FROM Usuario;