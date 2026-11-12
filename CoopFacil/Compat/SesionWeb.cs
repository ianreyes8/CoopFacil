using System.Collections.Concurrent;
using System.Security.Cryptography;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Caching.Memory;
using CoopFacil.Helpers;

namespace CoopFacil.Compat;

/// <summary>
/// Sesión con la misma forma que Session de Web Forms: Session["clave"] = valor (cualquier objeto).
/// Se guarda en memoria del servidor (como la sesión InProc de IIS) y expira a los 20 minutos sin actividad.
/// Al iniciar sesión también se registra en la base de datos (tabla Sesiones): si el servidor se reinicia,
/// la sesión se reconstruye desde ahí y el socio no tiene que volver a entrar.
/// El navegador solo recibe una cookie con un identificador aleatorio.
/// </summary>
public sealed class SesionWeb
{
    private const string NombreCookie = "coopfacil.sid";
    private static readonly TimeSpan Expiracion = TimeSpan.FromMinutes(20);
    private static readonly MemoryCache Almacen = new(new MemoryCacheOptions());

    private readonly HttpContext _http;
    private string? _id;
    private bool _vinoDeCookie;

    public SesionWeb(HttpContext http)
    {
        _http = http;
        var cookie = http.Request.Cookies[NombreCookie];
        if (!string.IsNullOrEmpty(cookie) && cookie.Length == 32 && cookie.All(Uri.IsHexDigit))
        {
            _id = cookie;
            _vinoDeCookie = true;
        }
    }

    public string SessionID => _id ?? "";

    private ConcurrentDictionary<string, object?> Datos
    {
        get
        {
            if (_id is null) _id = NuevoId();
            return Almacen.GetOrCreate(_id, entrada =>
            {
                entrada.SlidingExpiration = Expiracion;
                var datos = new ConcurrentDictionary<string, object?>();
                if (_vinoDeCookie)
                {
                    // Sin datos en memoria (reinicio del servidor): se busca la sesión guardada en la base de datos.
                    int idUsuario = SesionesBD.Obtener(_id!);
                    if (idUsuario > 0)
                    {
                        try
                        {
                            var guardados = SesionUsuario.Construir(idUsuario);
                            if (guardados != null) foreach (var par in guardados) datos[par.Key] = par.Value;
                        }
                        catch (Exception ex) { Console.Error.WriteLine("[Sesiones] No se pudo restaurar: " + ex.GetType().Name); }
                    }
                }
                return datos;
            })!;
        }
    }

    /// <summary>Crea la cookie de sesión si el visitante todavía no tiene una (se llama antes de escribir la respuesta).</summary>
    public void Asegurar()
    {
        if (_id is null) _id = NuevoId();
        RenovarSiHaceFalta();
        var opciones = new CookieOptions
        {
            HttpOnly = true,
            SameSite = SameSiteMode.Lax,
            Secure = _http.Request.IsHttps
        };
        if (!_http.Request.Cookies.ContainsKey(NombreCookie) || _http.Request.Cookies[NombreCookie] != _id)
            _http.Response.Cookies.Append(NombreCookie, _id, opciones);
    }

    public object? this[string clave]
    {
        get => Datos.TryGetValue(clave, out var valor) ? valor : null;
        set
        {
            if (value is null) Datos.TryRemove(clave, out _);
            else Datos[clave] = value;
        }
    }

    public void Clear() => Datos.Clear();

    /// <summary>Cambia el identificador de la sesión conservando los datos (se usa al iniciar sesión).</summary>
    public void RegenerarId()
    {
        if (_id is not null) { Almacen.Remove(_id); SesionesBD.Eliminar(_id); }
        _id = NuevoId();
        _vinoDeCookie = false;
        Asegurar();
    }

    // Mientras el socio está activo, la sesión guardada en la base de datos se renueva cada pocos minutos.
    private void RenovarSiHaceFalta()
    {
        if (!_vinoDeCookie || _id is null) return;
        if (this["IdUsuario"] is null) return;
        if (this["_renovada"] is DateTime ultima && DateTime.Now - ultima < SesionesBD.CadaRenovacion) return;
        this["_renovada"] = DateTime.Now;
        SesionesBD.Renovar(_id);
    }

    public void Abandon()
    {
        if (_id is not null) { Almacen.Remove(_id); SesionesBD.Eliminar(_id); }
        _http.Response.Cookies.Delete(NombreCookie);
        _id = null;
    }

    private static string NuevoId() => Convert.ToHexString(RandomNumberGenerator.GetBytes(16)).ToLowerInvariant();
}
