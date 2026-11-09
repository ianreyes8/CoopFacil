// Controles de la página (equivale al archivo .designer.cs de Web Forms).
// Los valores iniciales salen del HTML original (Visible, CssClass, Text, opciones de listas...).
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace CoopFacil.Pages
{
    public partial class Contacto
    {
        public Panel pnlBienvenida = new Panel() { Visible = false, CssClass = @"hidden lg:flex items-center gap-2 bg-slate-100 dark:bg-[#0F233D] border border-emerald-500/40 px-3 py-1.5 rounded-xl shadow-sm" };
        public Literal litBienvenida = new Literal();
        public HyperLink lnkIniciarSesion = new HyperLink() { CssClass = @"bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs sm:text-sm px-5 py-2.5 rounded-xl transition flex items-center gap-2 shadow-lg shadow-blue-500/20", NavigateUrl = @"../Default.aspx" };
        public LinkButton btnCerrarSesion = new LinkButton() { Visible = false, CssClass = @"bg-slate-100 dark:bg-[#0F233D] hover:bg-slate-200 dark:hover:bg-slate-700 border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-white font-bold text-xs sm:text-sm px-4 py-2.5 rounded-xl transition flex items-center gap-2", OnClick = @"btnCerrarSesion_Click" };
        public Panel pnlMensajeExito = new Panel() { Visible = false, CssClass = @"mb-5 p-4 rounded-xl flex items-center gap-3 text-xs sm:text-sm font-medium" };
        public Literal litMensaje = new Literal();
        public TextBox txtNombre = new TextBox() { CssClass = @"w-full bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700/90 rounded-lg px-4 py-3 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition", TextMode = TextBoxMode.SingleLine };
        public TextBox txtEmail = new TextBox() { CssClass = @"w-full bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700/90 rounded-lg px-4 py-3 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition", TextMode = TextBoxMode.Email };
        public TextBox txtTelefono = new TextBox() { CssClass = @"w-full bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700/90 rounded-lg px-4 py-3 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition", TextMode = TextBoxMode.SingleLine };
        public DropDownList ddlTipoConsulta = new DropDownList() { CssClass = @"w-full bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700/90 rounded-lg px-4 py-3 text-sm text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition appearance-none cursor-pointer pr-10", Items = { new ListItem(@"Consulta sobre servicios", @"servicios"), new ListItem(@"Solicitud de créditos o préstamos", @"creditos"), new ListItem(@"Cuentas de ahorro e inversión", @"ahorros"), new ListItem(@"Otros asuntos", @"otros") } };
        public TextBox txtMensaje = new TextBox() { CssClass = @"w-full bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700/90 rounded-lg p-4 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition resize-y", TextMode = TextBoxMode.MultiLine };
        public Button btnEnviarMensaje = new Button() { CssClass = @"w-full bg-emerald-600 hover:bg-emerald-500 text-white font-bold py-3.5 px-6 rounded-xl transition shadow-lg shadow-emerald-600/20 cursor-pointer text-sm tracking-wide", Text = @"Enviar Mensaje →", OnClick = @"btnEnviarMensaje_Click" };
    }
}
