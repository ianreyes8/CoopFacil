# CoopFacil — migración a ASP.NET Core + MariaDB

Este es el mismo proyecto CoopFacil de Web Forms, **migrado sin rediseñarlo** para poder ejecutarse
en Linux (Railway) con MariaDB. Las 14 páginas conservan su HTML, su estilo y su código C#.

**Stack:** ASP.NET Core Razor Pages (.NET 10) · MariaDB/MySQL · Tailwind por CDN.

## Cómo se migró (qué NO cambió)

- El HTML de cada página es el original (mismos estilos, scripts, textos y rutas: `Default.aspx`,
  `Index.aspx`, `Pages/CuentaAhorro.aspx`, etc.). Los enlaces siguen funcionando igual.
- El código de cada página (`*.cshtml.cs`) es el original: `Page_Load`, `btnX_Click`, `Session[...]`,
  `Response.Redirect(...)`, `txtNombre.Text`, `pnlError.Visible`...
- `Helpers/ComprobanteServicioHelper.cs` (PDF y correo) y el repositorio en memoria `RepositorioBanco` siguen igual.
- Para que lo anterior funcione en ASP.NET Core, la carpeta `CoopFacil/Compat/` reproduce los controles de
  Web Forms (TextBox, Literal, Panel, DropDownList...), el ciclo de vida de la página (IsPostBack, eventos de
  botones, estado entre envíos) y `Session`. Cada página tiene un archivo `*.controles.cs` (equivale al antiguo
  `.designer.cs`).

## Cambios obligados por la plataforma (lo único que se tocó en el código)

| Qué | Por qué |
|---|---|
| `System.Data.SqlClient` → `MySqlConnector` (`MySqlConnection`, `MySqlCommand`...) | La base ahora es MariaDB, no SQL Server. |
| `Registro`: se quitó `OUTPUT INSERTED.IdUsuario` y el id se lee con `LastInsertedId` | `OUTPUT` solo existe en SQL Server. |
| `(int)cmd.ExecuteScalar()` → `Convert.ToInt32(...)` | MariaDB devuelve `COUNT(*)` como `long`. |
| `iTextSharp` → `iTextSharp.LGPLv2.Core` (mismo código `iTextSharp.text.*`) | iTextSharp 5 solo funciona en .NET Framework. |
| `File.Exists` → `System.IO.File.Exists` (EducacionFinanciera) | En una página de ASP.NET Core `File` es otro método. |
| La cadena de conexión y la clave del correo salieron de `Web.config` | Ver "Configuración" más abajo. |
| Carpetas `Downloads/` y `Pages/Documentos/` movidas a `wwwroot/` | Es donde ASP.NET Core sirve archivos estáticos. |
| `Response.Redirect` ya no detiene la ejecución en ese punto | Se revisaron los 24 usos: ninguno ejecuta nada dañino después. |

Todo lo demás (incluidos los puntos de mejora que ya conocemos: contraseñas en texto plano, datos en memoria
en `RepositorioBanco`, etc.) queda **igual que en el original**, para atacarlo después.

## Requisitos locales

- .NET SDK 10 (`dotnet --version` debe mostrar 10.x)
- VS Code + extensión **C# Dev Kit**
- XAMPP con el módulo **MySQL** iniciado

## Ejecutar en local

1. Inicia **MySQL** en el panel de XAMPP.
2. En phpMyAdmin (`http://localhost/phpmyadmin`): si ya existe una base `coopfacil` de pruebas anteriores,
   elimínala. Luego importa `sql/coopfacil_mariadb.sql` (crea la base y las tablas `Usuarios` y `Movimientos`).
3. Copia `CoopFacil/appsettings.Local.example.json` como `CoopFacil/appsettings.Local.json` y escribe ahí el
   correo emisor y su contraseña de aplicación de Gmail (ese archivo no se sube a GitHub).
4. En la terminal:

   ```
   cd CoopFacil
   dotnet restore
   dotnet run
   ```

5. Abre `http://localhost:5080`.

## Configuración

| Dato | Local | Railway |
|---|---|---|
| Base de datos | `ConnectionStrings:CoopFacilDB` en `appsettings.json` (XAMPP: root sin clave) | Variable `MYSQL_URL` |
| Correo (`SmtpCorreoEmisor`, `SmtpPassword`, `SmtpHost`, `SmtpPort`, `SmtpUser`, `SmtpPass`) | `appsettings.Local.json` | Variables `AppSettings__SmtpCorreoEmisor`, `AppSettings__SmtpPassword`, ... |

**Importante:** la contraseña de Gmail que estaba en el `Web.config` original quedó expuesta en el historial
de GitHub. Revócala en tu cuenta de Google y crea una nueva contraseña de aplicación.

## Desplegar en Railway

1. Sube este repositorio a GitHub.
2. En Railway: **New Project** → agrega un servicio **MariaDB** (o MySQL).
3. Ejecuta `sql/coopfacil_mariadb.sql` en esa base **sin las dos primeras sentencias** (`CREATE DATABASE` y `USE`).
4. Agrega otro servicio **desde el repositorio de GitHub** (Railway detecta ASP.NET Core).
5. En las variables del servicio web agrega:
   - `MYSQL_URL` con la referencia a la variable de la base (`${{ NombreDelServicioDB.MYSQL_URL }}`)
   - las variables `AppSettings__...` del correo
   - opcional: `TZ=America/El_Salvador` para que `DateTime.Now` use la hora de El Salvador (por defecto Railway usa UTC)
6. En **Settings → Networking** genera un dominio público.

Notas de Railway: los archivos del contenedor no persisten entre despliegues y la sesión vive en la memoria del
servidor (como la sesión InProc de IIS), así que las sesiones abiertas se cierran cada vez que se reinicia o se
vuelve a desplegar el servicio.

## Estructura

```
CoopFacil/
├── Program.cs               Configuración (rutas, puerto, cultura, configuración)
├── Compat/                  Capa de compatibilidad con Web Forms (controles, ciclo de vida, Session, Response)
├── Pages/                   Las 14 páginas: X.cshtml (HTML), X.cshtml.cs (código), X.controles.cs (controles)
├── Helpers/                 ComprobanteServicioHelper.cs (PDF y correo, RepositorioBanco, modelos)
└── wwwroot/                 css, Js, Downloads y Pages/Documentos
sql/coopfacil_mariadb.sql    Estructura de la base de datos (mismas tablas y columnas del original)
```

## Cuentas, transferencias y movimientos (simulación)

- Cada socio recibe al registrarse un número de cuenta de 12 dígitos y $100.00 de bienvenida.
- **Transferencias** (último enlace del menú): tarjeta virtual, transferir a otra cuenta por número de cuenta o correo, depósito de simulación (máximo $5,000 por depósito) y lista de movimientos (rojo = enviado, verde = recibido o depositado).
- Los créditos aprobados se guardan en la base de datos y se desembolsan en la cuenta del socio.
- Las contraseñas se guardan con hash PBKDF2-SHA256. Al actualizar desde una versión anterior hay que volver a importar `sql/coopfacil_mariadb.sql` (la base se recrea).
