using System.Reflection;
using System.Text.Json;
using System.Web.UI;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Html;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace CoopFacil.Compat;

/// <summary>
/// Reemplazo de System.Web.UI.Page. Reproduce el ciclo de vida de Web Forms para que el código de cada
/// página (Page_Load, btnX_Click, IsPostBack, Session, Response.Redirect...) funcione sin cambios:
///   1. restaura el estado de los controles (ViewState) y los datos enviados por el formulario,
///   2. ejecuta Page_Load,
///   3. ejecuta el evento del botón pulsado (OnClick="btnX_Click"),
///   4. dibuja la página.
/// </summary>
public abstract class PaginaWeb : PageModel
{
    private SesionWeb? _sesion;
    private RespuestaWeb? _respuesta;
    private ServidorWeb? _servidor;
    private List<Control>? _controles;

    public bool IsPostBack { get; private set; }

    public SesionWeb Session => _sesion ??= new SesionWeb(HttpContext);

    /// <summary>Oculta HttpResponse para que Response.Redirect(...) se comporte como en Web Forms.</summary>
    public new RespuestaWeb Response => _respuesta ??= new RespuestaWeb();

    public ServidorWeb Server => _servidor ??= new ServidorWeb(HttpContext);

    public async Task<IActionResult> OnGetAsync() => await EjecutarAsync(false);

    public async Task<IActionResult> OnPostAsync() => await EjecutarAsync(true);

    private async Task<IActionResult> EjecutarAsync(bool esPostBack)
    {
        IsPostBack = esPostBack;
        Session.Asegurar();
        RegistrarControles();

        if (esPostBack)
        {
            await RestaurarEstadoAsync();
            var form = await Request.ReadFormAsync();
            foreach (var control in _controles!) control.CargarDatosPost(form);
        }

        Invocar("Page_Load", this, EventArgs.Empty);
        if (Response.Resultado is not null) return Response.Resultado;

        if (esPostBack)
        {
            var disparador = BuscarDisparador(await Request.ReadFormAsync());
            if (disparador?.OnClick is { Length: > 0 } nombre)
            {
                Invocar(nombre, disparador, EventArgs.Empty);
                if (Response.Resultado is not null) return Response.Resultado;
            }
        }

        return Page();
    }

    // ------------------------------------------------------------------ controles

    private void RegistrarControles()
    {
        _controles = new List<Control>();
        foreach (var campo in GetType().GetFields(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic))
        {
            if (!typeof(Control).IsAssignableFrom(campo.FieldType)) continue;
            if (campo.GetValue(this) is not Control control) continue;
            control.ID = campo.Name;
            _controles.Add(control);
        }
    }

    private System.Web.UI.WebControls.Button? BuscarDisparador(Microsoft.AspNetCore.Http.IFormCollection form)
    {
        // LinkButton: el script __doPostBack deja el id en __EVENTTARGET.
        var objetivo = form["__EVENTTARGET"].ToString();
        if (!string.IsNullOrEmpty(objetivo))
        {
            var porId = _controles!.OfType<System.Web.UI.WebControls.Button>().FirstOrDefault(c => c.ID == objetivo);
            if (porId is not null) return porId;
        }

        // Button: el navegador envía el nombre del botón pulsado.
        return _controles!.OfType<System.Web.UI.WebControls.Button>()
            .FirstOrDefault(c => c is not System.Web.UI.WebControls.LinkButton && form.ContainsKey(c.ID));
    }

    private void Invocar(string metodo, object? remitente, EventArgs args)
    {
        var m = GetType().GetMethod(metodo, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
        m?.Invoke(this, new[] { remitente, args });
    }

    // ------------------------------------------------------------------ ViewState

    private IDataProtector Protector =>
        HttpContext.RequestServices.GetRequiredService<IDataProtectionProvider>()
            .CreateProtector("CoopFacil.ViewState." + GetType().FullName);

    private async Task RestaurarEstadoAsync()
    {
        var form = await Request.ReadFormAsync();
        var token = form["__VIEWSTATE"].ToString();
        if (string.IsNullOrEmpty(token)) return;

        try
        {
            using var doc = JsonDocument.Parse(Protector.Unprotect(token));
            foreach (var control in _controles!)
                if (doc.RootElement.TryGetProperty(control.ID, out var estado))
                    control.CargarEstado(estado);
        }
        catch (Exception)
        {
            // Estado vencido o alterado (por ejemplo tras reiniciar el servidor): se ignora, igual que un ViewState inválido.
        }
    }

    /// <summary>Dibuja un Literal (HTML sin codificar, como en Web Forms); no dibuja nada si Visible es false.</summary>
    public IHtmlContent Lit(System.Web.UI.WebControls.Literal literal) =>
        literal.Visible ? new HtmlString(literal.Text) : HtmlString.Empty;

    /// <summary>Campos ocultos que Web Forms agregaba a cada formulario. Se escribe dentro de &lt;form&gt;.</summary>
    public IHtmlContent CamposOcultos()
    {
        var estado = new Dictionary<string, Dictionary<string, object?>>();
        foreach (var control in _controles ?? new List<Control>())
        {
            var d = new Dictionary<string, object?>();
            control.GuardarEstado(d);
            estado[control.ID] = d;
        }
        var token = Protector.Protect(JsonSerializer.Serialize(estado));
        return new HtmlString(
            "<input type=\"hidden\" name=\"__EVENTTARGET\" id=\"__EVENTTARGET\" value=\"\" />" +
            "<input type=\"hidden\" name=\"__EVENTARGUMENT\" id=\"__EVENTARGUMENT\" value=\"\" />" +
            "<input type=\"hidden\" name=\"__VIEWSTATE\" id=\"__VIEWSTATE\" value=\"" +
            System.Net.WebUtility.HtmlEncode(token) + "\" />");
    }
}
