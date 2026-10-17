using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CoopFacil.Pages
{
    public partial class Contacto : Page
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
            btnPortalSocio.Visible = estaAutenticado;
            btnCerrarSesion.Visible = estaAutenticado;
            pnlBienvenida.Visible = estaAutenticado;

            if (estaAutenticado)
            {
                string nombreCompleto = Session["NombreCompleto"] != null ? Session["NombreCompleto"].ToString() : "";
                litBienvenida.Text = ExtraerPrimerNombreYPrimerApellido(nombreCompleto);
            }
        }

        protected void btnPortalSocio_Click(object sender, EventArgs e)
        {
            Response.Redirect("../Index.aspx");
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Contacto.aspx");
        }

        protected void btnEnviarMensaje_Click(object sender, EventArgs e)
        {
            // Lógica para procesar el envío del mensaje de contacto
            pnlMensajeExito.Visible = true;

            // Limpiar campos del formulario
            txtNombre.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtTelefono.Text = string.Empty;
            txtMensaje.Text = string.Empty;
            ddlTipoConsulta.SelectedIndex = 0;
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