# CoopFacil

Sitio web para una cooperativa financiera, desarrollado con ASP.NET Web Forms. Permite a los usuarios conocer los servicios de la cooperativa, registrarse y gestionar productos de ahorro y crédito.

## Características

- Página de inicio y presentación de la cooperativa (Quiénes somos)
- Registro de usuarios y sesión con saludo personalizado
- Cuenta de ahorro y ahorro programado
- Créditos: personal, vehicular e hipotecario
- Sección de educación financiera
- Página de contacto
- Diseño moderno y responsivo con Tailwind CSS

## Tecnologías

- **Lenguaje:** C#
- **Framework:** ASP.NET Web Forms (.NET Framework)
- **Base de datos:** SQL Server (`CoopFacilDB`)
- **Frontend:** HTML, Tailwind CSS (CDN), Font Awesome
- **IDE:** Visual Studio Community

## Requisitos

- Visual Studio 2022 o superior con la carga de trabajo **Desarrollo de ASP.NET y web**
- .NET Framework (versión indicada en el proyecto)
- SQL Server o SQL Server Express
- IIS Express (incluido con Visual Studio)

## Instalación

1. Clona el repositorio:
```bash
   git clone https://github.com/ianreyes8/CoopFacil.git
```
2. Abre el archivo `CoopFacil.slnx` con Visual Studio.
3. Restaura los paquetes NuGet (clic derecho en la solución > **Restaurar paquetes NuGet**).
4. Configura la cadena de conexión en `Web.config`:
```xml
   <connectionStrings>
     <add name="CoopFacilDB"
          connectionString="Data Source=TU_SERVIDOR;Initial Catalog=CoopFacilDB;Integrated Security=True"
          providerName="System.Data.SqlClient" />
   </connectionStrings>
```
5. Crea la base de datos `CoopFacilDB` en tu servidor SQL.
6. Presiona **F5** para ejecutar con IIS Express.

## Estructura del proyecto

```
CoopFacil/
├── App_Data/
├── css/
├── Js/
├── Pages/
│   ├── AhorroProgramado.aspx
│   ├── Contacto.aspx
│   ├── CreditoHipotecario.aspx
│   ├── CreditoPersonal.aspx
│   ├── CreditoVehicular.aspx
│   ├── CuentaAhorro.aspx
│   ├── EducacionFinanciera.aspx
│   ├── QuienesSomos.aspx
│   ├── Registro.aspx
│   └── Servicios.aspx
├── Index.aspx
├── Default.aspx
└── Web.config
```

## Seguridad

No subas contraseñas ni cadenas de conexión reales al repositorio. Usa valores de ejemplo en `Web.config` o mantén el repositorio privado.

## Autor

Desarrollado por [ianreyes8](https://github.com/ianreyes8).
