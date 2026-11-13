-- =====================================================================
-- CoopFacil - Base de datos para MariaDB (XAMPP) / MySQL (Railway)
--
-- Tablas: Usuarios, Movimientos, Transferencias, Creditos, Sesiones, IntentosAcceso y RecuperacionClave.
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
    UNIQUE KEY UQ_Usuarios_DUI (DUI),                 -- un DUI, una cuenta (los NULL no cuentan)
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

-- 5. TABLA SESIONES (sesiones iniciadas; sobreviven a los reinicios del servidor)
-- Se guarda el hash SHA-256 del identificador de la cookie, nunca el identificador en sí.
CREATE TABLE IF NOT EXISTS Sesiones (
    IdSesionHash CHAR(64)  NOT NULL,
    IdUsuario    INT       NOT NULL,
    Creada       DATETIME  NOT NULL,
    Expira       DATETIME  NOT NULL,
    PRIMARY KEY (IdSesionHash),
    KEY IX_Sesiones_Usuario (IdUsuario),
    KEY IX_Sesiones_Expira (Expira),
    CONSTRAINT FK_Sesiones_Usuarios FOREIGN KEY (IdUsuario)
        REFERENCES Usuarios (IdUsuario) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. TABLA INTENTOSACCESO (intentos fallidos de inicio de sesión y de recuperación; limita los abusos)
CREATE TABLE IF NOT EXISTS IntentosAcceso (
    IdIntento BIGINT       NOT NULL AUTO_INCREMENT,
    Tipo      VARCHAR(12)  NOT NULL,            -- 'login' o 'recuperar'
    Correo    VARCHAR(100) NOT NULL,
    Ip        VARCHAR(45)  NOT NULL,
    Fecha     DATETIME     NOT NULL,
    PRIMARY KEY (IdIntento),
    KEY IX_Intentos_Correo (Tipo, Correo, Fecha),
    KEY IX_Intentos_Ip (Tipo, Ip, Fecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. TABLA RECUPERACIONCLAVE (enlaces de un solo uso para restablecer la contraseña)
-- Se guarda el hash SHA-256 del token; el token real solo viaja en el correo.
CREATE TABLE IF NOT EXISTS RecuperacionClave (
    IdRecuperacion INT      NOT NULL AUTO_INCREMENT,
    IdUsuario      INT      NOT NULL,
    TokenHash      CHAR(64) NOT NULL,
    Creada         DATETIME NOT NULL,
    Expira         DATETIME NOT NULL,
    Usado          TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (IdRecuperacion),
    UNIQUE KEY UQ_Recuperacion_Token (TokenHash),
    KEY IX_Recuperacion_Usuario (IdUsuario),
    CONSTRAINT FK_Recuperacion_Usuarios FOREIGN KEY (IdUsuario)
        REFERENCES Usuarios (IdUsuario) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. ACTUALIZACION PARA BASES YA CREADAS: un DUI solo puede pertenecer a un socio.
-- (En una base nueva el indice ya viene en CREATE TABLE; aqui se agrega a las que ya existian.)
SET @existe_dui := (SELECT COUNT(*) FROM information_schema.statistics
                    WHERE table_schema = DATABASE() AND table_name = 'Usuarios' AND index_name = 'UQ_Usuarios_DUI');
-- Si ya hubiera dos socios con el mismo DUI, no se crea el indice (la aplicacion igual impide nuevos duplicados).
SET @duplicados_dui := (SELECT COUNT(*) FROM (SELECT DUI FROM Usuarios WHERE DUI IS NOT NULL GROUP BY DUI HAVING COUNT(*) > 1) d);
SET @sql_dui := IF(@existe_dui = 0 AND @duplicados_dui = 0, 'ALTER TABLE Usuarios ADD UNIQUE KEY UQ_Usuarios_DUI (DUI)', 'SELECT 1');
PREPARE stmt_dui FROM @sql_dui;
EXECUTE stmt_dui;
DEALLOCATE PREPARE stmt_dui;
