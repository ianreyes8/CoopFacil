-- 1. CREACIÓN DE LA TABLA USUARIOS
CREATE TABLE [dbo].[Usuarios] (
    [IdUsuario]     INT            IDENTITY (1, 1) NOT NULL,
    [NombreCompleto] NVARCHAR (150) NOT NULL,
    [Email]          NVARCHAR (100) NOT NULL UNIQUE,
    [Password]       NVARCHAR (100) NOT NULL,
    [TipoAcceso]     NVARCHAR (50)  DEFAULT 'Socio Individual' NOT NULL,
    [NumeroSocio]    NVARCHAR (20)  NOT NULL UNIQUE,
    [Saldo]          DECIMAL (18, 2) DEFAULT 0.00 NOT NULL,
    [CDT]            DECIMAL (18, 2) DEFAULT 0.00 NOT NULL,
    [Prestamo]       DECIMAL (18, 2) DEFAULT 0.00 NOT NULL,
    PRIMARY KEY CLUSTERED ([IdUsuario] ASC)
);

-- 2. CREACIÓN DE LA TABLA MOVIMIENTOS
CREATE TABLE [dbo].[Movimientos] (
    [IdMovimiento]   INT            IDENTITY (1, 1) NOT NULL,
    [IdUsuario]      INT            NOT NULL,
    [Fecha]          DATETIME       DEFAULT GETDATE() NOT NULL,
    [Descripcion]    NVARCHAR (255) NOT NULL,
    [Monto]          DECIMAL (18, 2) NOT NULL,
    [SaldoResultante] DECIMAL (18, 2) NOT NULL,
    [Estado]         NVARCHAR (30)  DEFAULT 'Completado' NOT NULL,
    [EsPositivo]     BIT            NOT NULL,
    PRIMARY KEY CLUSTERED ([IdMovimiento] ASC),
    CONSTRAINT [FK_Movimientos_Usuarios] FOREIGN KEY ([IdUsuario]) REFERENCES [dbo].[Usuarios] ([IdUsuario]) ON DELETE CASCADE
);

select * from Usuarios;