// Controles de la página (equivale al archivo .designer.cs de Web Forms).
// Los valores iniciales salen del HTML original (Visible, CssClass, Text, opciones de listas...).
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace CoopFacil.Pages
{
    public partial class RegistroCredito
    {
        public Panel pnlError = new Panel() { Visible = false, CssClass = @"mb-4 p-4 rounded-xl bg-red-500/10 border border-red-500/40 text-red-600 dark:text-red-400 text-xs font-bold flex items-center gap-2" };
        public Literal litError = new Literal();
        public TextBox txtNombres = new TextBox() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500", TextMode = TextBoxMode.SingleLine };
        public TextBox txtApellidos = new TextBox() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500", TextMode = TextBoxMode.SingleLine };
        public TextBox txtDUI = new TextBox() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500", TextMode = TextBoxMode.SingleLine };
        public TextBox txtFechaNacimiento = new TextBox() { CssClass = @"bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500", TextMode = TextBoxMode.Date };
        public Button btnCrearCuenta = new Button() { CssClass = @"w-full bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-sm py-3.5 rounded-xl shadow-lg transition cursor-pointer", Text = @"Crear Cuenta y Ver Desembolso", OnClick = @"btnCrearCuenta_Click" };
    }
}
