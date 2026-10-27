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
            string nombreUsuario = ObtenerNombreUsuarioSesion();
            bool estaAutenticado = !string.IsNullOrEmpty(nombreUsuario);

            lnkIniciarSesion.Visible = !estaAutenticado;
            btnCerrarSesion.Visible = estaAutenticado;
            pnlBienvenida.Visible = estaAutenticado;

            if (estaAutenticado)
            {
                litBienvenida.Text = ExtraerPrimerNombreYPrimerApellido(nombreUsuario);

                if (string.IsNullOrEmpty(txtNombre.Text))
                {
                    txtNombre.Text = nombreUsuario;
                }
            }
        }

        private string ObtenerNombreUsuarioSesion()
        {
            string[] clavesNombre = new string[] { "NombreCompleto", "UsuarioNombre", "NombreUsuario", "Usuario", "Nombre", "nombre", "usuario", "IdUsuario" };

            foreach (string clave in clavesNombre)
            {
                if (Session[clave] != null)
                {
                    string valor = Session[clave].ToString().Trim();
                    if (!string.IsNullOrWhiteSpace(valor))
                    {
                        return valor;
                    }
                }
            }

            return null;
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Contacto.aspx");
        }

        protected void btnEnviarMensaje_Click(object sender, EventArgs e)
        {
            // Procesamiento de mensaje de contacto
            pnlMensajeExito.Visible = true;

            // Limpieza de campos del formulario
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