# CoopFacil

Sitio web de una cooperativa de ahorro y crédito. Los socios abren su cuenta, solicitan créditos, reciben una
tarjeta virtual de débito y envían dinero a otros socios, todo desde el navegador.

**Tecnologías:** ASP.NET Core Razor Pages (.NET 10) · MariaDB / MySQL · Tailwind CSS · iTextSharp (PDF) · Resend (correo)

> Proyecto académico: los saldos, la tarjeta y las transferencias son datos de demostración y no representan
> dinero real.

---

## Contenido

1. [Qué incluye](#qué-incluye)
2. [Cómo está organizado](#cómo-está-organizado)
3. [Instalación en local](#instalación-en-local)
4. [Configuración](#configuración)
5. [Base de datos](#base-de-datos)
6. [Seguridad](#seguridad)
7. [Trabajar con los estilos](#trabajar-con-los-estilos)
8. [Despliegue en Railway](#despliegue-en-railway)
9. [Problemas frecuentes](#problemas-frecuentes)

---

## Qué incluye

| Área | Qué hace |
|---|---|
| **Sitio público** | Inicio, Quiénes somos, Servicios, Educación financiera, Transparencia y Contacto, con tema claro y oscuro, animaciones suaves y diseño adaptable a celular, tableta y escritorio. |
| **Cuentas de socio** | Registro e inicio de sesión. Cada socio recibe número de socio, número de cuenta de 12 dígitos y $100.00 de bienvenida. |
| **Recuperar contraseña** | Enlace de un solo uso enviado por correo, válido por 30 minutos. |
| **Créditos y ahorro** | Solicitud de crédito personal, vehicular e hipotecario, cuenta de ahorro, ahorro programado y calculadoras de cuotas. Cada solicitud genera un comprobante en PDF que se envía por correo. |
| **Transferencias** | Tarjeta virtual de débito, transferencias por número de cuenta o correo, depósitos y movimientos (rojo: enviado, verde: recibido o depositado). |
| **Perfil** | Panel con los datos del socio y accesos rápidos. |
| **Páginas de error** | 404, acceso denegado y 500 con el mismo estilo del sitio. |

---

## Cómo está organizado

```
CoopFacil/                          Raíz del repositorio
├── CoopFacil.slnx                  Solución
├── sql/
│   └── coopfacil_mariadb.sql       Estructura de la base de datos (se puede importar varias veces)
└── CoopFacil/                      Proyecto web
    ├── Program.cs                  Arranque: rutas, puerto, cultura, páginas de error, configuración
    ├── appsettings.json            Configuración base (cadena de conexión local)
    ├── appsettings.Local.example.json   Plantilla para tus claves personales
    ├── Pages/                      Una carpeta lógica por página:
    │   ├── X.cshtml                  HTML de la página (Razor)
    │   ├── X.cshtml.cs               Lógica de la página
    │   ├── X.controles.cs            Controles que usa la página
    │   └── Shared/                   Piezas compartidas (menú de perfil, envío de formularios)
    ├── Helpers/
    │   ├── BancoDatos.cs             Cuentas, transferencias, depósitos, movimientos y créditos
    │   ├── Seguridad.cs              Sesiones guardadas, límite de intentos y recuperación de contraseña
    │   ├── SesionUsuario.cs          Datos del socio que se cargan al iniciar sesión
    │   ├── PasswordHasher.cs         Hash de contraseñas (PBKDF2-SHA256)
    │   ├── ComprobanteServicioHelper.cs   Comprobante PDF y correo con adjunto
    │   └── CorreoSimple.cs           Correos sin adjunto (recuperar contraseña)
    ├── Compat/                     Controles, sesión y ciclo de vida que usan las páginas
    ├── Styles/tailwind.input.css   Entrada de Tailwind
    ├── tailwind.config.js          Configuración de Tailwind
    └── wwwroot/
        ├── css/                    tailwind.css (compilado), estilos.css, paginas.css, tarjeta.css, ui.css
        ├── Js/                     Menú móvil, formularios, efectos de scroll, tema
        └── Downloads/              Guías y plantillas descargables
```

### Cómo funciona una página

Cada página es un trío de archivos con el mismo nombre. Por ejemplo, `Transferencias.cshtml` dibuja la pantalla,
`Transferencias.cshtml.cs` responde a los botones y consulta la base de datos mediante `BancoDatos`, y
`Transferencias.controles.cs` declara los campos y botones. Las direcciones conservan la forma
`/Pages/Transferencias.aspx`, y la raíz `/` abre la página de inicio.

---

## Instalación en local

### Requisitos

| Herramienta | Para qué | Cómo comprobarla |
|---|---|---|
| [.NET SDK 10](https://dotnet.microsoft.com/download) | Compilar y ejecutar el sitio | `dotnet --version` muestra `10.x` |
| [XAMPP](https://www.apachefriends.org/) (módulo MySQL) o cualquier MariaDB/MySQL | Base de datos | El módulo MySQL aparece en verde |
| [Git](https://git-scm.com/) | Descargar el proyecto | `git --version` |
| Node.js 18 o superior | **Solo** si vas a cambiar clases de Tailwind | `node --version` |

### Paso a paso

1. **Descarga el proyecto**

   ```
   git clone https://github.com/ianreyes8/CoopFacil.git
   cd CoopFacil
   ```

2. **Inicia MySQL** desde el panel de XAMPP.

3. **Crea la base de datos.** Abre phpMyAdmin (`http://localhost/phpmyadmin`), entra a la pestaña **Importar**,
   elige `sql/coopfacil_mariadb.sql` y pulsa **Importar**. El script crea la base `coopfacil` y sus siete tablas.
   Se puede volver a importar sin borrar nada: solo agrega lo que falte.

4. **Opcional: correo.** Para que se envíen los comprobantes y los enlaces de recuperación, copia
   `CoopFacil/appsettings.Local.example.json` como `CoopFacil/appsettings.Local.json` y completa tus datos
   (ver [Configuración](#configuración)). Ese archivo no se sube a Git. Sin él, el sitio funciona igual pero no
   envía correos.

5. **Ejecuta el sitio**

   ```
   cd CoopFacil
   dotnet run
   ```

   Si Windows bloquea el archivo `.exe` (Smart App Control), usa:

   ```
   dotnet run -p:UseAppHost=false
   ```

6. **Abre** `http://localhost:5080`, crea una cuenta desde **Registro** y entra con ella.

> **Recuperar contraseña sin correo configurado:** en local, el enlace de recuperación aparece en la consola donde
> corre `dotnet run`. Cópialo en el navegador.

Para detener el sitio pulsa `Ctrl + C` en la terminal.

### Actualizar a la última versión

```
git checkout master
git pull
```

Si la actualización cambió `sql/coopfacil_mariadb.sql`, vuelve a importarlo en phpMyAdmin.

---

## Configuración

| Dato | Local | Railway |
|---|---|---|
| Base de datos | `ConnectionStrings:CoopFacilDB` en `appsettings.json` (XAMPP: usuario `root`, sin clave) | Variable `MYSQL_URL` |
| Correo con Resend | `ResendApiKey` y `ResendRemitente` en `appsettings.Local.json` | `AppSettings__ResendApiKey`, `AppSettings__ResendRemitente` |
| Correo con SMTP (respaldo en local) | `SmtpCorreoEmisor`, `SmtpPassword`, `SmtpHost`, `SmtpPort` | `AppSettings__Smtp...` |
| Dirección pública del sitio | opcional | `AppSettings__UrlPublica`, por ejemplo `https://tudominio.com` |
| Zona horaria | la del equipo | `TZ=America/El_Salvador` |

- Si `ResendApiKey` está vacía se usa SMTP. Si tampoco hay datos de SMTP, no se envían correos.
- `UrlPublica` sirve para que el enlace del correo de recuperación apunte siempre a tu dominio.
- **Nunca subas claves al repositorio.** Van en `appsettings.Local.json` (ignorado por Git) o en las variables de Railway.

---

## Base de datos

| Tabla | Contenido |
|---|---|
| `Usuarios` | Socios: datos personales, hash de contraseña, número de socio, número de cuenta y saldo. |
| `Movimientos` | Historial de cada cuenta (bono, depósitos, transferencias, desembolsos) con el saldo resultante. |
| `Transferencias` | Una fila por transferencia entre dos socios, con su referencia única. |
| `Creditos` | Créditos solicitados por cada socio. |
| `Sesiones` | Sesiones iniciadas (se guarda solo un hash del identificador). Sobreviven a los reinicios del servidor. |
| `IntentosAcceso` | Intentos fallidos de inicio de sesión y de recuperación, para limitar abusos. |
| `RecuperacionClave` | Enlaces de un solo uso para restablecer la contraseña (se guarda solo un hash del token). |

El saldo no puede quedar negativo (restricción `CHECK`) y cada transferencia se ejecuta en una sola transacción:
o se descuenta y se acredita, o no ocurre nada.

---

## Seguridad

- Contraseñas con hash **PBKDF2-SHA256** y sal propia; nunca se guardan en texto plano.
- **Límite de intentos:** 5 fallos por correo o 30 por dirección IP bloquean el inicio de sesión durante 15 minutos.
- Mensaje único para correo inexistente o contraseña incorrecta, así no se revela qué correos están registrados.
- **Recuperar contraseña:** token aleatorio de un solo uso, guardado como hash, con vigencia de 30 minutos. Al
  cambiar la contraseña se cierran las sesiones guardadas del socio.
- **Sesiones** con identificador nuevo en cada inicio de sesión y guardadas en la base de datos.
- Transferencias atómicas, con bloqueo de filas para evitar saldos incorrectos si dos operaciones coinciden.
- Los errores no muestran detalles técnicos al visitante.

---

## Trabajar con los estilos

Las clases de Tailwind se compilan a `CoopFacil/wwwroot/css/tailwind.css`, que **ya está incluido en el
repositorio**: para ejecutar el sitio no necesitas Node.js, y Railway tampoco.

Solo si agregas o cambias clases de Tailwind en un `.cshtml` o `.cs`, recompila:

```
cd CoopFacil
npm install        # solo la primera vez
npm run css        # compila una vez
npm run css:watch  # opcional: recompila mientras editas
```

Los estilos propios (animaciones, tarjeta virtual, barra de navegación) están en `estilos.css`, `paginas.css` y
`tarjeta.css`, y **no** necesitan recompilar.

---

## Despliegue en Railway

1. En Railway crea un proyecto con un servicio **MySQL**.
2. Importa `sql/coopfacil_mariadb.sql` en esa base, sin las dos primeras sentencias (`CREATE DATABASE` y `USE`).
3. Agrega un servicio **desde este repositorio de GitHub** (rama `master`); Railway detecta ASP.NET Core.
4. En las variables del servicio web agrega `MYSQL_URL` (con la referencia `${{ NombreDelServicioDB.MYSQL_URL }}`),
   las variables `AppSettings__...` del correo, `AppSettings__UrlPublica` y `TZ=America/El_Salvador`.
5. En **Settings → Networking** genera un dominio público o conecta el tuyo.

Notas sobre el correo:

- En los planes Free, Trial y Hobby de Railway el SMTP saliente está bloqueado: en línea el correo se envía con la
  API de Resend.
- Para enviar a cualquier usuario hay que verificar un dominio en Resend (registros DNS) y usar un remitente de ese
  dominio, por ejemplo `CoopFácil <comprobantes@tudominio.com>`.
- Sin dominio verificado, Resend solo permite enviar desde `onboarding@resend.dev` al correo de la propia cuenta de
  Resend (sirve para pruebas).

---

## Problemas frecuentes

| Síntoma | Solución |
|---|---|
| `dotnet --version` no muestra 10.x | Instala el SDK de .NET 10 y abre una terminal nueva. |
| Windows bloquea `CoopFacil.exe` | Ejecuta `dotnet run -p:UseAppHost=false`. |
| `Unable to connect to any of the specified MySQL hosts` | MySQL no está iniciado en XAMPP, o el puerto/usuario de `appsettings.json` no coincide. |
| phpMyAdmin dice que la tabla ya existe | Usa el `sql/coopfacil_mariadb.sql` más reciente (`git pull`); ya no falla al importarlo de nuevo. |
| El sitio se ve sin estilos o con estilos viejos | Actualiza con `Ctrl + F5`. Si cambiaste clases de Tailwind, corre `npm run css`. |
| No llegan los correos | Revisa `appsettings.Local.json` y la carpeta de spam. En local, el enlace de recuperación sale en la consola. |
| La sesión se cierra al reiniciar | Importa de nuevo el SQL: la tabla `Sesiones` es la que conserva las sesiones. |
