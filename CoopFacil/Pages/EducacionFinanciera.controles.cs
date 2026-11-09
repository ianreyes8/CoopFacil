// Controles de la página (equivale al archivo .designer.cs de Web Forms).
// Los valores iniciales salen del HTML original (Visible, CssClass, Text, opciones de listas...).
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace CoopFacil.Pages
{
    public partial class EducacionFinanciera
    {
        public Panel pnlBienvenida = new Panel() { Visible = false, CssClass = @"hidden lg:flex items-center gap-2 bg-slate-100 dark:bg-[#0F233D] border border-emerald-500/40 px-3 py-1.5 rounded-xl shadow-sm" };
        public Literal litBienvenida = new Literal();
        public HyperLink lnkIniciarSesion = new HyperLink() { CssClass = @"bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs sm:text-sm px-5 py-2.5 rounded-xl transition flex items-center gap-2 shadow-lg shadow-blue-500/20", NavigateUrl = @"../Default.aspx" };
        public LinkButton btnCerrarSesion = new LinkButton() { Visible = false, CssClass = @"bg-slate-100 dark:bg-[#0F233D] hover:bg-slate-200 dark:hover:bg-slate-700 border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-white font-bold text-xs sm:text-sm px-4 py-2.5 rounded-xl transition flex items-center gap-2", OnClick = @"btnCerrarSesion_Click" };
        public Panel pnlMensajeTaller = new Panel() { Visible = false, CssClass = @"mb-2 p-4 rounded-xl border flex items-center gap-3 text-sm font-bold" };
        public Literal litMensajeTaller = new Literal();
        public DropDownList ddlTallerSeleccionado = new DropDownList() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-amber-400 transition font-medium", Items = { new ListItem(@"Finanzas para Emprendedores y Microempresas", @"1"), new ListItem(@"Cómo Salir de Deudas y Optimizar tu Presupuesto", @"2"), new ListItem(@"Estrategias de Inversión y Planificación de Retiro", @"3") } };
        public TextBox txtNombreInscripcion = new TextBox() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-amber-400 transition", TextMode = TextBoxMode.SingleLine };
        public TextBox txtCorreoInscripcion = new TextBox() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-amber-400 transition", TextMode = TextBoxMode.Email };
        public TextBox txtTelefonoInscripcion = new TextBox() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-amber-400 transition", TextMode = TextBoxMode.SingleLine };
        public Button btnInscribirseTaller = new Button() { CssClass = @"mt-2 w-full bg-amber-600 hover:bg-amber-500 text-white font-bold text-xs py-3 rounded-xl shadow-lg shadow-amber-950 transition cursor-pointer", Text = @"Confirmar Reservación de Cupo", OnClick = @"btnInscribirseTaller_Click" };
        public LinkButton btnDescargarExcel = new LinkButton() { CssClass = @"w-full bg-white dark:bg-[#0F233D] hover:bg-emerald-600 border border-emerald-500/40 text-emerald-600 dark:text-emerald-400 hover:text-white text-xs font-bold py-2.5 rounded-lg transition flex items-center justify-center gap-2 shadow-sm", OnClick = @"btnDescargarExcel_Click" };
        public LinkButton btnDescargarGuiaPDF = new LinkButton() { CssClass = @"w-full bg-white dark:bg-[#0F233D] hover:bg-amber-600 border border-amber-500/40 text-amber-600 dark:text-amber-400 hover:text-white text-xs font-bold py-2.5 rounded-lg transition flex items-center justify-center gap-2 shadow-sm", OnClick = @"btnDescargarGuiaPDF_Click" };
        public LinkButton btnDescargarManualPDF = new LinkButton() { CssClass = @"w-full bg-white dark:bg-[#0F233D] hover:bg-blue-600 border border-blue-500/40 text-blue-600 dark:text-blue-400 hover:text-white text-xs font-bold py-2.5 rounded-lg transition flex items-center justify-center gap-2 shadow-sm", OnClick = @"btnDescargarManualPDF_Click" };
    }
}
