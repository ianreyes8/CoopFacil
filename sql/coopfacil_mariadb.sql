-- =====================================================================
-- CoopFacil - Base de datos para MariaDB (XAMPP) / MySQL (Railway)
-- Es la misma estructura del proyecto original (SQL Server: App_Data/CoopFacil.sql)
-- con los mismos nombres de tablas y columnas, más las columnas que el código ya usa
-- (DUI, Telefono, TieneCuentaAhorro, NumeroCuenta).
--
-- En Railway la base ya viene creada: omite las dos primeras sentencias (CREATE DATABASE y USE).
-- Los nombres respetan mayúsculas y minúsculas (en Linux MariaDB las distingue).
-- =====================================================================

CREATE DATABASE IF NOT EXISTS coopfacil
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE coopfacil;

-- 1. TABLA USUARIOS
CREATE TABLE Usuarios (
    IdUsuario         INT            NOT NULL AUTO_INCREMENT,
    NombreCompleto    VARCHAR(150)   NOT NULL,
    Email             VARCHAR(100)   NOT NULL,
    Password          VARCHAR(100)   NOT NULL,
    TipoAcceso        VARCHAR(50)    NOT NULL DEFAULT 'Socio Individual',
    NumeroSocio       VARCHAR(20)    NOT NULL,
    Saldo             DECIMAL(18,2)  NOT NULL DEFAULT 0.00,
    CDT               DECIMAL(18,2)  NOT NULL DEFAULT 0.00,
    Prestamo          DECIMAL(18,2)  NOT NULL DEFAULT 0.00,
    DUI               VARCHAR(20)    NULL,
    Telefono          VARCHAR(20)    NULL,
    TieneCuentaAhorro TINYINT(1)     NOT NULL DEFAULT 0,
    NumeroCuenta      VARCHAR(30)    NULL,
    PRIMARY KEY (IdUsuario),
    UNIQUE KEY UQ_Usuarios_Email (Email),
    UNIQUE KEY UQ_Usuarios_NumeroSocio (NumeroSocio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. TABLA MOVIMIENTOS
CREATE TABLE Movimientos (
    IdMovimiento    INT            NOT NULL AUTO_INCREMENT,
    IdUsuario       INT            NOT NULL,
    Fecha           DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Descripcion     VARCHAR(255)   NOT NULL,
    Monto           DECIMAL(18,2)  NOT NULL,
    SaldoResultante DECIMAL(18,2)  NOT NULL,
    Estado          VARCHAR(30)    NOT NULL DEFAULT 'Completado',
    EsPositivo      TINYINT(1)     NOT NULL,
    PRIMARY KEY (IdMovimiento),
    CONSTRAINT FK_Movimientos_Usuarios FOREIGN KEY (IdUsuario)
        REFERENCES Usuarios (IdUsuario) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
