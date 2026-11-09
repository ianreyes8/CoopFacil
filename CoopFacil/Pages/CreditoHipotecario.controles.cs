// Controles de la página (equivale al archivo .designer.cs de Web Forms).
// Los valores iniciales salen del HTML original (Visible, CssClass, Text, opciones de listas...).
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace CoopFacil.Pages
{
    public partial class CreditoHipotecario
    {
        public Panel pnlBienvenida = new Panel() { Visible = false, CssClass = @"hidden lg:flex items-center gap-2 bg-slate-100 dark:bg-[#0F233D] border border-emerald-500/40 px-3 py-1.5 rounded-xl shadow-sm" };
        public Literal litBienvenida = new Literal();
        public HyperLink lnkIniciarSesion = new HyperLink() { CssClass = @"bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs sm:text-sm px-5 py-2.5 rounded-xl transition flex items-center gap-2 shadow-lg shadow-blue-500/20", NavigateUrl = @"../Default.aspx" };
        public LinkButton btnCerrarSesion = new LinkButton() { Visible = false, CssClass = @"bg-slate-100 dark:bg-[#0F233D] hover:bg-slate-200 dark:hover:bg-slate-700 border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-white font-bold text-xs sm:text-sm px-4 py-2.5 rounded-xl transition flex items-center gap-2", OnClick = @"btnCerrarSesion_Click" };
        public Panel pnlMensaje = new Panel() { Visible = false, CssClass = @"p-4 rounded-xl border flex items-center gap-3 text-sm font-bold" };
        public Literal litMensaje = new Literal();
        public TextBox txtNombre = new TextBox() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition", TextMode = TextBoxMode.SingleLine };
        public TextBox txtDUI = new TextBox() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition", TextMode = TextBoxMode.SingleLine };
        public TextBox txtTelefono = new TextBox() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition", TextMode = TextBoxMode.SingleLine };
        public TextBox txtCorreo = new TextBox() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition", TextMode = TextBoxMode.Email };
        public DropDownList ddlModalidad = new DropDownList() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition", Items = { new ListItem(@"Presencial en Agencia", @"Presencial"), new ListItem(@"Videollamada en Línea", @"Videollamada") } };
        public DropDownList ddlAgencia = new DropDownList() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition", Items = { new ListItem(@"Agencia Central - San Salvador", @"Agencia Central"), new ListItem(@"Agencia Escalón", @"Agencia Escalón"), new ListItem(@"Agencia Soyapango", @"Agencia Soyapango") } };
        public TextBox txtFechaCita = new TextBox() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition", TextMode = TextBoxMode.Date };
        public DropDownList ddlHoraCita = new DropDownList() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition", Items = { new ListItem(@"08:00 AM", @"08:00 AM"), new ListItem(@"09:00 AM", @"09:00 AM"), new ListItem(@"10:00 AM", @"10:00 AM"), new ListItem(@"11:00 AM", @"11:00 AM"), new ListItem(@"02:00 PM", @"02:00 PM"), new ListItem(@"03:00 PM", @"03:00 PM"), new ListItem(@"04:00 PM", @"04:00 PM") } };
        public Button btnAgendarCita = new Button() { CssClass = @"w-full sm:w-auto bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs px-8 py-3.5 rounded-xl shadow-lg shadow-emerald-950 transition cursor-pointer", Text = @"Confirmar y Agendar Cita", OnClick = @"btnAgendarCita_Click" };
    }
}
