// Controles de la página (equivale al archivo .designer.cs de Web Forms).
// Los valores iniciales salen del HTML original (Visible, CssClass, Text, opciones de listas...).
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace CoopFacil
{
    public partial class Default
    {
        public Label lblSocios = new Label() { Text = @"0" };
        public Panel pnlMensaje = new Panel() { Visible = false, CssClass = @"mb-4 p-3.5 bg-red-500/10 border border-red-500/40 rounded-xl text-xs font-bold text-red-600 dark:text-red-300 flex items-center gap-2" };
        public Literal litError = new Literal();
        public TextBox txtEmail = new TextBox() { CssClass = @"w-full bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-3 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition", TextMode = TextBoxMode.Email };
        public TextBox txtPassword = new TextBox() { CssClass = @"w-full bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-3 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition", TextMode = TextBoxMode.Password };
        public Button btnAcceder = new Button() { CssClass = @"w-full bg-blue-600 hover:bg-blue-500 text-white font-bold py-3.5 rounded-xl text-sm transition cursor-pointer mt-2 shadow-lg shadow-blue-500/20", Text = @"Iniciar Sesión →", OnClick = @"btnAcceder_Click" };
    }
}
