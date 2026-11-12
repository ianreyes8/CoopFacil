# CoopFacil

Sitio web de una cooperativa de ahorro y crédito: los socios abren su cuenta, solicitan créditos, reciben su
tarjeta virtual y envían dinero a otros socios, todo desde el navegador.

**Stack:** ASP.NET Core Razor Pages (.NET 10) · MariaDB / MySQL · Tailwind CSS · iTextSharp (PDF) · Resend (correo)

> Proyecto académico: los saldos, la tarjeta y las transferencias son datos de demostración y no representan
> dinero real.

## Qué incluye

| Área | Qué hace |
|---|---|
| **Sitio público** | Inicio, Quiénes somos, Servicios, Educación financiera, Transparencia y Contacto, con tema claro y oscuro. |
| **Cuentas de socio** | Registro e inicio de sesión. Cada socio recibe número de socio, número de cuenta de 12 dígitos y $100.00 de bienvenida. Las contraseñas se guardan con hash PBKDF2-SHA256. |
| **Créditos y ahorro** | Solicitud de crédito personal, vehicular e hipotecario, cuenta de ahorro, ahorro programado y calculadoras de cuotas. Cada solicitud genera un comprobante en PDF que se envía por correo. |
| **Transferencias** | Tarjeta virtual de débito, transferencias por número de cuenta o correo, depósitos y movimientos (rojo: enviado, verde: recibido o depositado). |
| **Perfil** | Panel de perfil con los datos del socio y accesos rápidos. |

## Estructura

```
CoopFacil/
├── Program.cs              Configuración de la aplicación (rutas, puerto, cultura, configuración)
├── Pages/                  Páginas: X.cshtml (HTML), X.cshtml.cs (lógica) y X.controles.cs (controles)
├── Helpers/
│   ├── BancoDatos.cs       Cuentas, transferencias, depósitos, movimientos y créditos (base de datos)
│   ├── PasswordHasher.cs   Hash de contraseñas (PBKDF2-SHA256)
│   └── ComprobanteServicioHelper.cs   Comprobante PDF y envío de correo
├── Compat/                 Controles de servidor, sesión y ciclo de vida que usan las páginas
└── wwwroot/                Estilos (css), scripts (Js), documentos y descargas
sql/coopfacil_mariadb.sql   Estructura de la base de datos
```

## Base de datos

| Tabla | Contenido |
|---|---|
| `Usuarios` | Socios: datos personales, hash de contraseña, número de socio, número de cuenta y saldo. |
| `Movimientos` | Historial de cada cuenta (bono, depósitos, transferencias, desembolsos) con el saldo resultante. |
| `Transferencias` | Una fila por transferencia entre dos socios, con su referencia única. |
| `Creditos` | Créditos solicitados por cada socio. |

El saldo no puede quedar negativo (restricción `CHECK`) y cada transferencia se ejecuta en una sola transacción:
o se descuenta y se acredita, o no ocurre nada.

## Ejecutar en local

**Requisitos:** .NET SDK 10 (`dotnet --version` debe mostrar 10.x), VS Code con la extensión C# Dev Kit y XAMPP
con el módulo MySQL.

1. Inicia **MySQL** en el panel de XAMPP.
2. En phpMyAdmin (`http://localhost/phpmyadmin`) importa `sql/coopfacil_mariadb.sql`. Si ya existe una base
   `coopfacil` con una estructura anterior, elimínala antes de importar.
3. Opcional, para el envío de correos: copia `CoopFacil/appsettings.Local.example.json` como
   `CoopFacil/appsettings.Local.json` y completa tus datos. Ese archivo no se sube a Git.
4. En la terminal:

   ```
   cd CoopFacil
   dotnet run
   ```

5. Abre `http://localhost:5080`.

## Configuración

| Dato | Local | Railway |
|---|---|---|
| Base de datos | `ConnectionStrings:CoopFacilDB` en `appsettings.json` (XAMPP: usuario `root` sin clave) | Variable `MYSQL_URL` |
| Correo con Resend | `ResendApiKey` y `ResendRemitente` en `appsettings.Local.json` | `AppSettings__ResendApiKey`, `AppSettings__ResendRemitente` |
| Correo con SMTP (respaldo en local) | `SmtpCorreoEmisor`, `SmtpPassword`, `SmtpHost`, `SmtpPort` | `AppSettings__Smtp...` |
| Zona horaria | la del equipo | `TZ=America/El_Salvador` |

Si `ResendApiKey` está vacía se usa SMTP; si tampoco hay datos de SMTP, el sitio funciona igual pero no envía correos.
Nunca subas claves al repositorio: van en `appsettings.Local.json` (ignorado por Git) o en las variables de Railway.

## Despliegue en Railway

1. En Railway crea un proyecto con un servicio **MySQL**.
2. Importa `sql/coopfacil_mariadb.sql` en esa base, sin las dos primeras sentencias (`CREATE DATABASE` y `USE`).
3. Agrega un servicio **desde este repositorio de GitHub** (rama `master`); Railway detecta ASP.NET Core.
4. En las variables del servicio web agrega `MYSQL_URL` (con la referencia `${{ NombreDelServicioDB.MYSQL_URL }}`),
   las variables `AppSettings__...` del correo y `TZ=America/El_Salvador`.
5. En **Settings → Networking** genera un dominio público o conecta el tuyo.

Notas:
- Los archivos del contenedor no persisten entre despliegues y las sesiones viven en la memoria del servidor, así
  que las sesiones abiertas se cierran cada vez que el servicio se reinicia o se vuelve a desplegar.
- En los planes Free, Trial y Hobby de Railway el SMTP saliente está bloqueado: en línea el correo se envía con la
  API de Resend. Para enviar a cualquier usuario hay que verificar un dominio en Resend (registros DNS) y usar un
  remitente de ese dominio, por ejemplo `CoopFácil <comprobantes@tudominio.com>`. Sin dominio verificado, Resend solo
  permite enviar desde `onboarding@resend.dev` al correo de la propia cuenta de Resend (sirve para pruebas).
