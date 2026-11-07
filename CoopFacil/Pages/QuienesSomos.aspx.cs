using System;
using System.Web.UI;

namespace CoopFacil.Pages
{
    public partial class QuienesSomos : Page
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
            string nombreUsuario = ObtenerNombreUsuarioSesion();

            if (!string.IsNullOrEmpty(nombreUsuario))
            {
                pnlBienvenida.Visible = true;
                litBienvenida.Text = ExtraerPrimerNombreYPrimerApellido(nombreUsuario);
                lnkIniciarSesion.Visible = false;
                btnCerrarSesion.Visible = true;
            }
            else
            {
                pnlBienvenida.Visible = false;
                lnkIniciarSesion.Visible = true;
                btnCerrarSesion.Visible = false;
            }
        }

        private string ObtenerNombreUsuarioSesion()
        {
            string[] clavesNombre = new string[] { "UsuarioNombre", "NombreUsuario", "NombreCompleto", "Usuario", "Nombre", "nombre", "usuario" };

            foreach (string clave in clavesNombre)
            {
                if (Session[clave] != null)
                {
                    string valor = Session[clave].ToString().Trim();
                    if (!string.IsNullOrWhiteSpace(valor) && !int.TryParse(valor, out _))
                    {
                        return valor;
                    }
                }
            }

            if (Session["IdUsuario"] != null || Session["ID_Usuario"] != null)
            {
                return "Socio CoopFacil";
            }

            return null;
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("QuienesSomos.aspx");
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