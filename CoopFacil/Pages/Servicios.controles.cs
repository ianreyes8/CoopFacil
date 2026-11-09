// Controles de la página (equivale al archivo .designer.cs de Web Forms).
// Los valores iniciales salen del HTML original (Visible, CssClass, Text, opciones de listas...).
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace CoopFacil.Pages
{
    public partial class Servicios
    {
        public Panel pnlBienvenida = new Panel() { Visible = false, CssClass = @"hidden lg:flex items-center gap-2 bg-slate-100 dark:bg-[#0F233D] border border-emerald-500/40 px-3 py-1.5 rounded-xl shadow-sm" };
        public Literal litBienvenida = new Literal();
        public HyperLink lnkIniciarSesion = new HyperLink() { CssClass = @"bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs sm:text-sm px-5 py-2.5 rounded-xl transition flex items-center gap-2 shadow-lg shadow-blue-500/20", NavigateUrl = @"../Default.aspx" };
        public LinkButton btnCerrarSesion = new LinkButton() { Visible = false, CssClass = @"bg-slate-100 dark:bg-[#0F233D] hover:bg-slate-200 dark:hover:bg-slate-700 border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-white font-bold text-xs sm:text-sm px-4 py-2.5 rounded-xl transition flex items-center gap-2", OnClick = @"btnCerrarSesion_Click" };
        public LinkButton btnVerCuentaAhorro = new LinkButton() { CssClass = @"text-emerald-600 dark:text-emerald-400 font-bold text-xs sm:text-sm hover:underline flex items-center gap-1 w-fit", OnClick = @"btnVerCuentaAhorro_Click" };
    }
}
