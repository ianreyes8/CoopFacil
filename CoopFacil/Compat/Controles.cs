// =====================================================================================
// Capa de compatibilidad con Web Forms.
//
// Reproduce, de forma mínima, los controles de servidor que usa CoopFacil
// (TextBox, Literal, Panel, DropDownList, ...) para que el código C# de cada página
// (code-behind) funcione igual que en ASP.NET Web Forms: txtNombre.Text, pnlError.Visible,
// ddlPlazo.SelectedValue, etc.
//
// Los namespaces se llaman igual que en Web Forms a propósito: así los `using` de las
// páginas no cambian.
// =====================================================================================

using System.Collections;
using System.Net;
using System.Text;
using System.Text.Json;
using Microsoft.AspNetCore.Http;

namespace System.Web.UI
{
    /// <summary>Base de todos los controles de servidor.</summary>
    public abstract class Control
    {
        /// <summary>Se asigna automáticamente con el nombre del campo declarado en la página.</summary>
        public string ID { get; set; } = "";

        public bool Visible { get; set; } = true;

        // ----- Estado entre peticiones (equivale al ViewState de Web Forms) -----
        internal virtual void GuardarEstado(Dictionary<string, object?> estado)
        {
            estado["V"] = Visible;
        }

        internal virtual void CargarEstado(JsonElement estado)
        {
            if (estado.TryGetProperty("V", out var v) && (v.ValueKind == JsonValueKind.True || v.ValueKind == JsonValueKind.False))
                Visible = v.GetBoolean();
        }

        /// <summary>Lee los datos enviados en el formulario (equivale a LoadPostData).</summary>
        internal virtual void CargarDatosPost(IFormCollection form) { }

        internal static string? Texto(JsonElement e, string clave) =>
            e.TryGetProperty(clave, out var v) && v.ValueKind == JsonValueKind.String ? v.GetString() : null;

        internal static bool? Booleano(JsonElement e, string clave) =>
            e.TryGetProperty(clave, out var v) && (v.ValueKind == JsonValueKind.True || v.ValueKind == JsonValueKind.False)
                ? v.GetBoolean() : null;
    }

    /// <summary>Colección de controles hijos (se usa con HtmlTableRow / HtmlTableCell).</summary>
    public class ControlCollection : IEnumerable<Control>
    {
        private readonly List<Control> _items = new();
        public void Add(Control control) => _items.Add(control);
        public void Clear() => _items.Clear();
        public int Count => _items.Count;
        public IEnumerator<Control> GetEnumerator() => _items.GetEnumerator();
        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
    }

    /// <summary>Atributos HTML adicionales de un control: control.Attributes["min"] = "2026-01-01".</summary>
    public class AttributeCollection
    {
        private readonly Dictionary<string, string> _valores = new(StringComparer.OrdinalIgnoreCase);

        public string? this[string clave]
        {
            get => _valores.TryGetValue(clave, out var v) ? v : null;
            set { if (value is null) _valores.Remove(clave); else _valores[clave] = value; }
        }

        public bool Vacio => _valores.Count == 0;

        internal Dictionary<string, string> Copia() => new(_valores, StringComparer.OrdinalIgnoreCase);
        internal void Restaurar(Dictionary<string, string> valores)
        {
            _valores.Clear();
            foreach (var par in valores) _valores[par.Key] = par.Value;
        }

        /// <summary>Atributos listos para escribir dentro de una etiqueta (con prefijo de espacio).</summary>
        public string Renderizar(params string[] excluir)
        {
            var sb = new StringBuilder();
            foreach (var par in _valores)
            {
                if (excluir.Contains(par.Key, StringComparer.OrdinalIgnoreCase)) continue;
                sb.Append(' ').Append(WebUtility.HtmlEncode(par.Key)).Append("=\"").Append(WebUtility.HtmlEncode(par.Value)).Append('"');
            }
            return sb.ToString();
        }
    }
}

namespace System.Web.UI.WebControls
{
    using System.Web.UI;

    public abstract class WebControl : Control
    {
        public string? CssClass { get; set; }
        public bool Enabled { get; set; } = true;
        public AttributeCollection Attributes { get; } = new();

        /// <summary>Atributos extra (los asignados desde C#) para escribir en la etiqueta HTML.</summary>
        public string AtributosExtra() => Attributes.Renderizar();

        internal override void GuardarEstado(Dictionary<string, object?> estado)
        {
            base.GuardarEstado(estado);
            estado["C"] = CssClass;
            estado["E"] = Enabled;
            if (!Attributes.Vacio) estado["A"] = Attributes.Copia();
        }

        internal override void CargarEstado(JsonElement estado)
        {
            base.CargarEstado(estado);
            CssClass = estado.TryGetProperty("C", out var c) && c.ValueKind == JsonValueKind.String ? c.GetString() : CssClass;
            Enabled = Booleano(estado, "E") ?? Enabled;
            if (estado.TryGetProperty("A", out var a) && a.ValueKind == JsonValueKind.Object)
            {
                var dic = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                foreach (var p in a.EnumerateObject())
                    if (p.Value.ValueKind == JsonValueKind.String) dic[p.Name] = p.Value.GetString() ?? "";
                Attributes.Restaurar(dic);
            }
        }
    }

    public enum TextBoxMode { SingleLine, MultiLine, Password, Email, Number, Date, Phone, Url }

    public class TextBox : WebControl
    {
        public string Text { get; set; } = "";
        public TextBoxMode TextMode { get; set; } = TextBoxMode.SingleLine;

        internal override void GuardarEstado(Dictionary<string, object?> estado)
        {
            base.GuardarEstado(estado);
            if (TextMode != TextBoxMode.Password) estado["T"] = Text; // las contraseñas nunca se guardan
        }

        internal override void CargarEstado(JsonElement estado)
        {
            base.CargarEstado(estado);
            Text = Texto(estado, "T") ?? Text;
        }

        internal override void CargarDatosPost(IFormCollection form)
        {
            if (form.TryGetValue(ID, out var valor)) Text = valor.ToString();
        }
    }

    public class Literal : Control
    {
        public string Text { get; set; } = "";

        internal override void GuardarEstado(Dictionary<string, object?> estado)
        {
            base.GuardarEstado(estado);
            estado["T"] = Text;
        }

        internal override void CargarEstado(JsonElement estado)
        {
            base.CargarEstado(estado);
            Text = Texto(estado, "T") ?? Text;
        }
    }

    public class Label : WebControl
    {
        public string Text { get; set; } = "";

        internal override void GuardarEstado(Dictionary<string, object?> estado)
        {
            base.GuardarEstado(estado);
            estado["T"] = Text;
        }

        internal override void CargarEstado(JsonElement estado)
        {
            base.CargarEstado(estado);
            Text = Texto(estado, "T") ?? Text;
        }
    }

    public class Panel : WebControl { }

    public class Button : WebControl
    {
        public string Text { get; set; } = "";
        /// <summary>Nombre del método de la página que atiende el clic (OnClick="btnX_Click").</summary>
        public string? OnClick { get; set; }

        internal override void GuardarEstado(Dictionary<string, object?> estado)
        {
            base.GuardarEstado(estado);
            estado["T"] = Text;
        }

        internal override void CargarEstado(JsonElement estado)
        {
            base.CargarEstado(estado);
            Text = Texto(estado, "T") ?? Text;
        }
    }

    public class LinkButton : Button { }

    public class HyperLink : WebControl
    {
        public string Text { get; set; } = "";
        public string NavigateUrl { get; set; } = "";

        internal override void GuardarEstado(Dictionary<string, object?> estado)
        {
            base.GuardarEstado(estado);
            estado["T"] = Text;
            estado["U"] = NavigateUrl;
        }

        internal override void CargarEstado(JsonElement estado)
        {
            base.CargarEstado(estado);
            Text = Texto(estado, "T") ?? Text;
            NavigateUrl = Texto(estado, "U") ?? NavigateUrl;
        }
    }

    public class ListItem
    {
        public ListItem() { }
        public ListItem(string text, string value) { Text = text; Value = value; }
        public ListItem(string text) { Text = text; Value = text; }

        public string Text { get; set; } = "";
        public string Value { get; set; } = "";
        public bool Selected { get; set; }
        public bool Enabled { get; set; } = true;
    }

    public class ListItemCollection : IEnumerable<ListItem>
    {
        private readonly List<ListItem> _items = new();
        public void Add(ListItem item) => _items.Add(item);
        public void Add(string text) => _items.Add(new ListItem(text));
        public void Clear() => _items.Clear();
        public int Count => _items.Count;
        public ListItem this[int indice] => _items[indice];
        public ListItem? FindByValue(string valor) => _items.FirstOrDefault(i => i.Value == valor);
        public IEnumerator<ListItem> GetEnumerator() => _items.GetEnumerator();
        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
    }

    public class DropDownList : WebControl
    {
        public ListItemCollection Items { get; } = new();

        private int? _indice;

        public int SelectedIndex
        {
            get
            {
                if (Items.Count == 0) return -1;
                if (_indice is int i && i >= 0 && i < Items.Count) return i;
                for (var k = 0; k < Items.Count; k++) if (Items[k].Selected) return k; // Selected="True" del HTML
                return 0; // sin selección explícita, Web Forms toma el primer elemento
            }
            set => _indice = value;
        }

        public string SelectedValue
        {
            get => SelectedItem?.Value ?? "";
            set
            {
                for (var k = 0; k < Items.Count; k++)
                    if (Items[k].Value == value) { _indice = k; return; }
            }
        }

        public ListItem? SelectedItem => SelectedIndex >= 0 ? Items[SelectedIndex] : null;

        internal override void GuardarEstado(Dictionary<string, object?> estado)
        {
            base.GuardarEstado(estado);
            estado["S"] = SelectedIndex;
        }

        internal override void CargarEstado(JsonElement estado)
        {
            base.CargarEstado(estado);
            if (estado.TryGetProperty("S", out var s) && s.ValueKind == JsonValueKind.Number) _indice = s.GetInt32();
        }

        internal override void CargarDatosPost(IFormCollection form)
        {
            if (form.TryGetValue(ID, out var valor)) SelectedValue = valor.ToString();
        }
    }

    public class HttpPostedFile
    {
        private readonly IFormFile _archivo;
        internal HttpPostedFile(IFormFile archivo) { _archivo = archivo; }
        public string FileName => _archivo.FileName;
        public int ContentLength => (int)_archivo.Length;
        public string ContentType => _archivo.ContentType;
        public Stream InputStream => _archivo.OpenReadStream();
    }

    public class FileUpload : WebControl
    {
        private IFormFile? _archivo;

        public bool HasFile => _archivo is { Length: > 0 };
        public string FileName => _archivo is null ? "" : Path.GetFileName(_archivo.FileName);
        public HttpPostedFile? PostedFile => _archivo is null ? null : new HttpPostedFile(_archivo);

        public byte[] FileBytes
        {
            get
            {
                if (_archivo is null) return Array.Empty<byte>();
                using var ms = new MemoryStream();
                using var s = _archivo.OpenReadStream();
                s.CopyTo(ms);
                return ms.ToArray();
            }
        }

        internal override void CargarDatosPost(IFormCollection form)
        {
            _archivo = form.Files.GetFile(ID);
        }
    }
}

namespace System.Web.UI.HtmlControls
{
    using System.Web.UI;

    public class HtmlForm : Control { }

    /// <summary>Elemento HTML con runat="server" (por ejemplo el tbody de la tabla de créditos).</summary>
    public class HtmlGenericControl : Control
    {
        public AttributeCollection Attributes { get; } = new();
        public ControlCollection Controls { get; } = new();
        private string? _innerHtml;

        public string InnerHtml
        {
            get => _innerHtml ?? RenderizarHijos();
            set { _innerHtml = value; Controls.Clear(); }
        }

        /// <summary>HTML interior que se escribe entre la etiqueta de apertura y cierre.</summary>
        public string InterioHtml() => _innerHtml ?? RenderizarHijos();

        private string RenderizarHijos()
        {
            var sb = new StringBuilder();
            foreach (var hijo in Controls)
                if (hijo is HtmlControl h) sb.Append(h.Renderizar());
            return sb.ToString();
        }

        internal override void GuardarEstado(Dictionary<string, object?> estado)
        {
            base.GuardarEstado(estado);
            estado["H"] = InterioHtml();
        }

        internal override void CargarEstado(JsonElement estado)
        {
            base.CargarEstado(estado);
            var html = Texto(estado, "H");
            if (html is not null && Controls.Count == 0 && _innerHtml is null) _innerHtml = html;
        }
    }

    /// <summary>Base de los elementos HTML dinámicos (filas y celdas de tabla).</summary>
    public abstract class HtmlControl : Control
    {
        public AttributeCollection Attributes { get; } = new();
        public abstract string Renderizar();
    }

    public class HtmlTableCell : HtmlControl
    {
        public string InnerText { get; set; } = "";
        public string InnerHtml { get; set; } = "";

        public override string Renderizar()
        {
            var contenido = string.IsNullOrEmpty(InnerHtml) ? WebUtility.HtmlEncode(InnerText) : InnerHtml;
            return $"<td{Attributes.Renderizar()}>{contenido}</td>";
        }
    }

    public class HtmlTableRow : HtmlControl
    {
        public ControlCollection Controls { get; } = new();

        public override string Renderizar()
        {
            var sb = new StringBuilder();
            sb.Append("<tr").Append(Attributes.Renderizar()).Append('>');
            foreach (var hijo in Controls)
                if (hijo is HtmlControl h) sb.Append(h.Renderizar());
            sb.Append("</tr>");
            return sb.ToString();
        }
    }
}
