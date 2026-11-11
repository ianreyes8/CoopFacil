using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace CoopFacil.Pages
{
    public partial class Transferencias
    {
        public Panel pnlBienvenida = new Panel() { Visible = false };
        public Literal litBienvenida = new Literal();
        public HyperLink lnkIniciarSesion = new HyperLink() { CssClass = @"bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs sm:text-sm px-5 py-2.5 rounded-xl transition flex items-center gap-2 shadow-lg shadow-blue-500/20", NavigateUrl = @"../Default.aspx" };
        public LinkButton btnCerrarSesion = new LinkButton() { Visible = false, CssClass = @"bg-slate-100 dark:bg-[#0F233D] hover:bg-slate-200 dark:hover:bg-slate-700 border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-white font-bold text-xs sm:text-sm px-4 py-2.5 rounded-xl transition flex items-center gap-2", OnClick = @"btnCerrarSesion_Click" };

        public TextBox txtDestino = new TextBox();
        public TextBox txtMonto = new TextBox();
        public TextBox txtConcepto = new TextBox();
        public TextBox txtMontoDeposito = new TextBox();
        public Button btnTransferir = new Button() { Text = @"Transferir ahora", OnClick = @"btnTransferir_Click" };
        public Button btnDepositar = new Button() { Text = @"Depositar", OnClick = @"btnDepositar_Click" };
    }
}
