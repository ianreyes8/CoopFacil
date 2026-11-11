using System.Globalization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.AspNetCore.Localization;

var builder = WebApplication.CreateBuilder(args);

// Archivo local opcional (ignorado por Git) para guardar la clave del correo sin subirla al repositorio.
builder.Configuration.AddJsonFile("appsettings.Local.json", optional: true, reloadOnChange: true);

// Railway indica el puerto en la variable PORT. En local se usa launchSettings.json.
var puerto = Environment.GetEnvironmentVariable("PORT");
if (!string.IsNullOrWhiteSpace(puerto))
{
    builder.WebHost.UseUrls($"http://0.0.0.0:{puerto}");
}

builder.Services.AddRazorPages(opciones =>
{
    // La raíz del sitio muestra la página principal pública (Index). El inicio de sesión sigue en Default.aspx.
    opciones.Conventions.AddPageRoute("/Index", "");
});

// Railway termina el HTTPS delante de la aplicación: confiar en sus cabeceras X-Forwarded-*.
builder.Services.Configure<ForwardedHeadersOptions>(opciones =>
{
    opciones.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto;
    opciones.KnownIPNetworks.Clear();
    opciones.KnownProxies.Clear();
});

// Cadena de conexión y configuración de correo (antes vivían en Web.config).
System.Configuration.ConfigurationManager.Inicializar(builder.Configuration);

var app = builder.Build();

app.UseForwardedHeaders();

// Cultura fija para que montos y fechas se interpreten siempre igual,
// sin importar la configuración regional del equipo o del servidor.
app.UseRequestLocalization(new RequestLocalizationOptions
{
    DefaultRequestCulture = new RequestCulture("en-US"),
    SupportedCultures = [new CultureInfo("en-US")],
    SupportedUICultures = [new CultureInfo("en-US")]
});

app.UseStaticFiles();
app.UseRouting();
app.MapRazorPages();

app.Run();
