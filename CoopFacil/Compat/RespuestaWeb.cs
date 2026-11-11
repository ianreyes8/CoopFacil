using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace CoopFacil.Compat;

/// <summary>
/// Reemplazo de Response de Web Forms. En Web Forms, Response.Redirect cortaba la página en ese punto;
/// aquí se anota el destino y la página responde con la redirección al terminar el método actual.
/// </summary>
public sealed class RespuestaWeb
{
    private string? _contentType;
    private readonly Dictionary<string, string> _cabeceras = new();

    /// <summary>Resultado final que debe devolver la página (redirección o descarga); null si se dibuja normalmente.</summary>
    internal IActionResult? Resultado { get; private set; }

    public void Redirect(string url) => Resultado = new RedirectResult(url);

    public void Redirect(string url, bool terminarRespuesta) => Redirect(url);

    // ----- Descarga de archivos (Clear / ContentType / AddHeader / TransmitFile / End) -----
    public void Clear() { _contentType = null; _cabeceras.Clear(); }

    public string ContentType
    {
        get => _contentType ?? "application/octet-stream";
        set => _contentType = value;
    }

    public void AddHeader(string nombre, string valor) => _cabeceras[nombre] = valor;

    public void TransmitFile(string ruta)
    {
        var nombreDescarga = Path.GetFileName(ruta);
        if (_cabeceras.TryGetValue("Content-Disposition", out var disposicion))
        {
            const string marca = "filename=";
            var i = disposicion.IndexOf(marca, StringComparison.OrdinalIgnoreCase);
            if (i >= 0) nombreDescarga = disposicion[(i + marca.Length)..].Trim('"', ' ');
        }
        Resultado = new PhysicalFileResult(ruta, ContentType) { FileDownloadName = nombreDescarga };
    }

    public void End() { /* el resultado ya quedó definido en TransmitFile */ }
}

/// <summary>Reemplazo de Server: solo Server.MapPath("~/carpeta/archivo").</summary>
public sealed class ServidorWeb
{
    private readonly HttpContext _http;
    public ServidorWeb(HttpContext http) { _http = http; }

    public string MapPath(string ruta)
    {
        var entorno = _http.RequestServices.GetRequiredService<IWebHostEnvironment>();
        var relativa = ruta.TrimStart('~').TrimStart('/', '\\');
        return Path.Combine(entorno.WebRootPath, relativa.Replace('/', Path.DirectorySeparatorChar));
    }

    public string HtmlEncode(string texto) => System.Net.WebUtility.HtmlEncode(texto);
}
