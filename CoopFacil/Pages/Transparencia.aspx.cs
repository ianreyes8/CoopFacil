using System;
using System.Web.UI;

namespace CoopFacil.Pages
{
    public partial class Transparencia : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                EvaluarEstadoSesion();
            }
        }

        private void EvaluarEstadoSesion()
        {
            bool estaAutenticado = (Session["IdUsuario"] != null);

            lnkIniciarSesion.Visible = !estaAutenticado;
            btnCerrarSesion.Visible = estaAutenticado;
            pnlBienvenida.Visible = estaAutenticado;

            if (estaAutenticado)
            {
                string nombreCompleto = Session["NombreCompleto"] != null ? Session["NombreCompleto"].ToString() : "";
                litBienvenida.Text = ExtraerPrimerNombreYPrimerApellido(nombreCompleto);
            }
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Transparencia.aspx");
        }

        public static string ExtraerPrimerNombreYPrimerApellido(string nombreCompleto)
        {
            if (string.IsNullOrWhiteSpace(nombreCompleto)) return "";
            string[] partes = nombreCompleto.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

            if (partes.Length == 1) return partes[0];
            if (partes.Length == 2) return $"{partes[0]} {partes[1]}";
            if (partes.Length == 3) return $"{partes[0]} {partes[1]}";
            return $"{partes[0]} {partes[2]}";
        }
    }
}