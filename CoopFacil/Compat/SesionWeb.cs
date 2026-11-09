using System.Collections.Concurrent;
using System.Security.Cryptography;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Caching.Memory;

namespace CoopFacil.Compat;

/// <summary>
/// Sesión con la misma forma que Session de Web Forms: Session["clave"] = valor (cualquier objeto).
/// Se guarda en memoria del servidor (como la sesión InProc de IIS) y expira a los 20 minutos sin actividad.
/// El navegador solo recibe una cookie con un identificador aleatorio.
/// </summary>
public sealed class SesionWeb
{
    private const string NombreCookie = "coopfacil.sid";
    private static readonly TimeSpan Expiracion = TimeSpan.FromMinutes(20);
    private static readonly MemoryCache Almacen = new(new MemoryCacheOptions());

    private readonly HttpContext _http;
    private string? _id;

    public SesionWeb(HttpContext http)
    {
        _http = http;
        var cookie = http.Request.Cookies[NombreCookie];
        if (!string.IsNullOrEmpty(cookie) && cookie.Length == 32 && cookie.All(Uri.IsHexDigit))
            _id = cookie;
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
                return new ConcurrentDictionary<string, object?>();
            })!;
        }
    }

    /// <summary>Crea la cookie de sesión si el visitante todavía no tiene una (se llama antes de escribir la respuesta).</summary>
    public void Asegurar()
    {
        if (_id is null) _id = NuevoId();
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

    public void Abandon()
    {
        if (_id is not null) Almacen.Remove(_id);
        _http.Response.Cookies.Delete(NombreCookie);
        _id = null;
    }

    private static string NuevoId() => Convert.ToHexString(RandomNumberGenerator.GetBytes(16)).ToLowerInvariant();
}
