-- =====================================================================
-- CoopFacil - Base de datos para MariaDB (XAMPP) / MySQL (Railway)
--
-- Tablas: Usuarios, Movimientos, Transferencias y Creditos.
-- El script se puede ejecutar más de una vez sin errores y sin borrar datos (CREATE ... IF NOT EXISTS).
-- Para recrear la estructura desde cero (por ejemplo, tras un cambio de esquema), elimina antes la base.
--
-- En Railway la base ya viene creada: omite las dos primeras sentencias (CREATE DATABASE y USE).
-- Los nombres respetan mayúsculas y minúsculas (en Linux MariaDB las distingue).
-- Todas las fechas las escribe la aplicación (zona horaria TZ del servicio web), no el motor de base de datos.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS coopfacil
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE coopfacil;

-- 1. TABLA USUARIOS
CREATE TABLE IF NOT EXISTS Usuarios (
    IdUsuario         INT            NOT NULL AUTO_INCREMENT,
    NombreCompleto    VARCHAR(150)   NOT NULL,
    Email             VARCHAR(100)   NOT NULL,
    Password          VARCHAR(255)   NOT NULL,   -- hash PBKDF2 (unos 90 caracteres)
    TipoAcceso        VARCHAR(50)    NOT NULL DEFAULT 'Socio Individual',
    NumeroSocio       VARCHAR(20)    NOT NULL,
    Saldo             DECIMAL(18,2)  NOT NULL DEFAULT 0.00,
    CDT               DECIMAL(18,2)  NOT NULL DEFAULT 0.00,
    Prestamo          DECIMAL(18,2)  NOT NULL DEFAULT 0.00,
    DUI               VARCHAR(20)    NULL,
    Telefono          VARCHAR(20)    NULL,
    TieneCuentaAhorro TINYINT(1)     NOT NULL DEFAULT 0,
    NumeroCuenta      VARCHAR(30)    NULL,
    FechaRegistro     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (IdUsuario),
    UNIQUE KEY UQ_Usuarios_Email (Email),
    UNIQUE KEY UQ_Usuarios_NumeroSocio (NumeroSocio),
    UNIQUE KEY UQ_Usuarios_NumeroCuenta (NumeroCuenta),
    CONSTRAINT CK_Usuarios_Saldo CHECK (Saldo >= 0)   -- el saldo nunca puede quedar negativo
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. TABLA MOVIMIENTOS
CREATE TABLE IF NOT EXISTS Movimientos (
    IdMovimiento    INT            NOT NULL AUTO_INCREMENT,
    IdUsuario       INT            NOT NULL,
    Fecha           DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Descripcion     VARCHAR(255)   NOT NULL,
    Monto           DECIMAL(18,2)  NOT NULL,
    SaldoResultante DECIMAL(18,2)  NOT NULL,
    Estado          VARCHAR(30)    NOT NULL DEFAULT 'Completado',
    EsPositivo      TINYINT(1)     NOT NULL,
    Tipo            VARCHAR(30)    NOT NULL DEFAULT 'Otro',   -- Bono, Deposito, TransferenciaEnviada, TransferenciaRecibida, Credito
    Referencia      VARCHAR(40)    NULL,
    PRIMARY KEY (IdMovimiento),
    KEY IX_Movimientos_Usuario_Fecha (IdUsuario, Fecha, IdMovimiento),   -- historial de cada socio, del más reciente al más antiguo
    KEY IX_Movimientos_Referencia (Referencia),
    CONSTRAINT CK_Movimientos_Monto CHECK (Monto > 0),
    CONSTRAINT FK_Movimientos_Usuarios FOREIGN KEY (IdUsuario)
        REFERENCES Usuarios (IdUsuario) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. TABLA TRANSFERENCIAS (dinero que se mueve entre cuentas de socios de la aplicación)
CREATE TABLE IF NOT EXISTS Transferencias (
    IdTransferencia INT            NOT NULL AUTO_INCREMENT,
    Referencia      VARCHAR(40)    NOT NULL,
    IdOrigen        INT            NOT NULL,
    IdDestino       INT            NOT NULL,
    Monto           DECIMAL(18,2)  NOT NULL,
    Concepto        VARCHAR(150)   NULL,
    Fecha           DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (IdTransferencia),
    UNIQUE KEY UQ_Transferencias_Referencia (Referencia),
    CONSTRAINT FK_Transf_Origen  FOREIGN KEY (IdOrigen)  REFERENCES Usuarios (IdUsuario),
    CONSTRAINT FK_Transf_Destino FOREIGN KEY (IdDestino) REFERENCES Usuarios (IdUsuario),
    CONSTRAINT CK_Transf_Monto CHECK (Monto > 0),
    CONSTRAINT CK_Transf_Distintas CHECK (IdOrigen <> IdDestino)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. TABLA CREDITOS (créditos solicitados por cada socio)
CREATE TABLE IF NOT EXISTS Creditos (
    IdCredito         INT            NOT NULL AUTO_INCREMENT,
    IdUsuario         INT            NOT NULL,
    NumeroTransaccion VARCHAR(40)    NOT NULL,
    TipoCredito       VARCHAR(60)    NOT NULL,
    Monto             DECIMAL(18,2)  NOT NULL,
    PlazoMeses        INT            NOT NULL,
    CuotaMensual      DECIMAL(18,2)  NOT NULL,
    Fecha             DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (IdCredito),
    CONSTRAINT CK_Creditos_Valores CHECK (Monto > 0 AND PlazoMeses > 0 AND CuotaMensual >= 0),
    CONSTRAINT FK_Creditos_Usuarios FOREIGN KEY (IdUsuario)
        REFERENCES Usuarios (IdUsuario) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
