-- Crear base de datos
DROP DATABASE IF EXISTS tutorias;
CREATE DATABASE IF NOT EXISTS tutorias
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
USE tutorias;

-- Tabla Persona
CREATE TABLE Persona (
  DPI VARCHAR(20) NOT NULL PRIMARY KEY,
  Primer_Nombre VARCHAR(100) NOT NULL,
  Segundo_Nombre VARCHAR(100),
  Primer_Apellido VARCHAR(100) NOT NULL,
  Segundo_Apellido VARCHAR(100),
  Fecha_Nacimiento DATE,
  Direccion VARCHAR(255)
) ENGINE=InnoDB;

-- Telefono (varios por persona)
CREATE TABLE Telefono (
  id_telefono INT AUTO_INCREMENT PRIMARY KEY,
  DPI VARCHAR(20) NOT NULL,
  telefono VARCHAR(30) NOT NULL,
  tipo ENUM('celular','fijo','otro') DEFAULT 'celular',
  FOREIGN KEY (DPI) REFERENCES Persona(DPI)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Emails (varios por persona)
CREATE TABLE Email (
  id_email INT AUTO_INCREMENT PRIMARY KEY,
  DPI VARCHAR(20) NOT NULL,
  email VARCHAR(100) NOT NULL,
  FOREIGN KEY (DPI) REFERENCES Persona(DPI)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Roles
CREATE TABLE Rol (
  id_rol INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Relación Rol_Persona (una persona puede tener varios roles)
CREATE TABLE Rol_Persona (
  DPI VARCHAR(20) NOT NULL,
  id_rol INT NOT NULL,
  PRIMARY KEY (DPI, id_rol),
  FOREIGN KEY (DPI) REFERENCES Persona(DPI)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id_rol) REFERENCES Rol(id_rol)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Materia
CREATE TABLE Materia (
  id_materia INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Nivel (Primaria, Secundaria, etc.)
CREATE TABLE Nivel (
  id_nivel INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Materia_Nivel (relación materia <-> nivel). Le ponemos id para referenciar fácil.
CREATE TABLE Materia_Nivel (
  id_materia_nivel INT AUTO_INCREMENT PRIMARY KEY,
  id_materia INT NOT NULL,
  id_nivel INT NOT NULL,
  UNIQUE (id_materia, id_nivel),
  FOREIGN KEY (id_materia) REFERENCES Materia(id_materia)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_nivel) REFERENCES Nivel(id_nivel)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Alumno_Nivel (qué nivel cursa un alumno)
CREATE TABLE Alumno_Nivel (
  DPI_alumno VARCHAR(20) NOT NULL,
  id_nivel INT NOT NULL,
  PRIMARY KEY (DPI_alumno, id_nivel),
  FOREIGN KEY (DPI_alumno) REFERENCES Persona(DPI)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id_nivel) REFERENCES Nivel(id_nivel)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Encargado_Alumno (encargado o tutor legal de un alumno)
CREATE TABLE Encargado_Alumno (
  DPI_encargado VARCHAR(20) NOT NULL,
  DPI_alumno VARCHAR(20) NOT NULL,
  PRIMARY KEY (DPI_encargado, DPI_alumno),
  FOREIGN KEY (DPI_encargado) REFERENCES Persona(DPI)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (DPI_alumno) REFERENCES Persona(DPI)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- TutorPuedeImpartir: relaciona tutor con materia_nivel (usar id_materia_nivel)
CREATE TABLE Tutor_Puede_Impartir (
  id_tutor VARCHAR(20) NOT NULL,
  id_materia_nivel INT NOT NULL,
  PRIMARY KEY (id_tutor, id_materia_nivel),
  FOREIGN KEY (id_tutor) REFERENCES Persona(DPI)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id_materia_nivel) REFERENCES Materia_Nivel(id_materia_nivel)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


-- Tutoria: almacena asignación y/o impartición
CREATE TABLE Tutoria (
  id_tutoria INT AUTO_INCREMENT PRIMARY KEY,
  DPI_tutor VARCHAR(20) NOT NULL,
  DPI_alumno VARCHAR(20) NOT NULL,
  id_materia_nivel INT NOT NULL,
  fecha DATE NOT NULL,
  hora_inicio TIME NOT NULL, -- hora en punto (ej. 14)
  hora_fin TIME NOT NULL,    -- hora en punto (ej. 15)
  estado ENUM('asignada','cancelada','impartida','no_presento') NOT NULL DEFAULT 'asignada',
  direccion VARCHAR(120) NOT NULL,
  CHECK (hora_inicio >= 0 AND hora_inicio <= 23),
  CHECK (hora_fin >= 1 AND hora_fin <= 24),
  CHECK (hora_fin > hora_inicio),
  FOREIGN KEY (DPI_tutor) REFERENCES Persona(DPI)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (DPI_alumno) REFERENCES Persona(DPI)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (id_materia_nivel) REFERENCES Materia_Nivel(id_materia_nivel)
    ON DELETE RESTRICT ON UPDATE CASCADE

) ENGINE=InnoDB;

-- ---------------          ---------------
-- --------------- Inciso 1 ---------------
-- ---------------          ---------------
CREATE TABLE Horario_Tutor (
  id_horario INT AUTO_INCREMENT PRIMARY KEY,
  id_tutor VARCHAR(20) NOT NULL,
  dia ENUM('Lunes','Martes','Miercoles','Jueves','Viernes','Sabado','Domingo') NOT NULL,
  hora_inicio TINYINT UNSIGNED NOT NULL,
  hora_fin TINYINT UNSIGNED NOT NULL,
  CHECK (hora_inicio >= 0 AND hora_inicio <= 23),
  CHECK (hora_fin > hora_inicio AND hora_fin <= 24),
  FOREIGN KEY (id_tutor) REFERENCES Persona(DPI)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


CREATE TABLE Sucursal (
  id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(200) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Salon (
  id_salon INT AUTO_INCREMENT PRIMARY KEY,
  id_sucursal INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  capacidad INT DEFAULT 0,
  FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

ALTER TABLE Tutoria
  ADD calificacion TINYINT UNSIGNED NULL,
  ADD CHECK (calificacion IS NULL OR (calificacion BETWEEN 1 AND 5));


ALTER TABLE Tutoria
  ADD id_salon INT NULL,
  ADD FOREIGN KEY (id_salon) REFERENCES Salon(id_salon)
    ON DELETE RESTRICT ON UPDATE CASCADE;






















