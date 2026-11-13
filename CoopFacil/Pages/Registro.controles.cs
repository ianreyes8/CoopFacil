// Controles de la página (equivale al archivo .designer.cs de Web Forms).
// Los valores iniciales salen del HTML original (Visible, CssClass, Text, opciones de listas...).
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace CoopFacil.Pages
{
    public partial class Registro
    {
        public Panel pnlMensaje = new Panel() { Visible = false, CssClass = @"mb-4 p-3 bg-red-100 dark:bg-red-900/50 border border-red-300 dark:border-red-500 rounded-lg text-xs text-red-800 dark:text-red-200 font-medium" };
        public Literal litError = new Literal();
        public TextBox txtNombre = new TextBox() { CssClass = @"w-full bg-slate-50 dark:bg-[#071322] border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2.5 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition", TextMode = TextBoxMode.SingleLine };
        public TextBox txtEmail = new TextBox() { CssClass = @"w-full bg-slate-50 dark:bg-[#071322] border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2.5 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition", TextMode = TextBoxMode.Email };
        public TextBox txtDUI = new TextBox() { CssClass = @"w-full bg-slate-50 dark:bg-[#071322] border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2.5 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition", TextMode = TextBoxMode.SingleLine };
        public TextBox txtTelefono = new TextBox() { CssClass = @"w-full bg-slate-50 dark:bg-[#071322] border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2.5 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition", TextMode = TextBoxMode.SingleLine };
        public DropDownList ddlTipoAcceso = new DropDownList() { CssClass = @"w-full bg-slate-50 dark:bg-[#071322] border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2.5 text-sm text-slate-900 dark:text-white focus:outline-none focus:border-blue-500 transition", Items = { new ListItem(@"Socio Individual", @"Socio Individual") } };
        public TextBox txtPassword = new TextBox() { CssClass = @"w-full bg-slate-50 dark:bg-[#071322] border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2.5 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition", TextMode = TextBoxMode.Password };
        public TextBox txtPasswordConfirm = new TextBox() { CssClass = @"w-full bg-slate-50 dark:bg-[#071322] border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2.5 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition", TextMode = TextBoxMode.Password };
        public Button btnRegistrar = new Button() { CssClass = @"w-full bg-emerald-600 hover:bg-emerald-500 text-white font-bold py-3 rounded-lg text-sm transition cursor-pointer mt-2 shadow-lg shadow-emerald-900/20", Text = @"Completar Registro", OnClick = @"btnRegistrar_Click" };
    }
}
