using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CoopFacil.Pages
{
    public partial class CuentaAhorro : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                VerificarSesion();
            }
        }

        private void VerificarSesion()
        {
            string nombreUsuario = ObtenerNombreUsuarioSesion();

            if (string.IsNullOrEmpty(nombreUsuario))
            {
                Response.Redirect("../Default.aspx");
                return;
            }

            pnlBienvenida.Visible = true;
            litBienvenida.Text = nombreUsuario;
            lnkIniciarSesion.Visible = false;
            btnPortalSocio.Visible = true;
            btnCerrarSesion.Visible = true;

            // SE OMITE la asignación automática: txtNombre.Text = nombreUsuario;
            // Los campos permanecen vacíos para obligar al llenado manual.
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

            foreach (string key in Session.Keys)
            {
                if (Session[key] != null)
                {
                    string valor = Session[key].ToString().Trim();
                    if (!string.IsNullOrWhiteSpace(valor) && !int.TryParse(valor, out _))
                    {
                        return valor;
                    }
                }
            }

            return null;
        }

        protected void btnEnviarPreApertura_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) || string.IsNullOrWhiteSpace(txtDUI.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) || string.IsNullOrWhiteSpace(txtCorreo.Text) ||
                string.IsNullOrEmpty(ddlAgencia.SelectedValue))
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> Por favor, completa manualmente todos tus datos para procesar la solicitud de pre-apertura.";
                return;
            }

            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-emerald-500/50 bg-emerald-950/40 text-emerald-300 flex flex-col gap-2 text-xs font-medium";
            litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-emerald-400'>" +
                              "<i class='fa-solid fa-circle-check text-lg'></i> ¡Solicitud de Pre-Apertura Enviada con Éxito!</div>" +
                              "<p class='mt-1 text-slate-200'>Estimado/a <strong>" + txtNombre.Text + "</strong>, tu pre-apertura para Cuenta de Ahorro ha sido registrada correctamente.</p>" +
                              "<p class='text-xs text-slate-300'>Puedes pasar a la <strong>" + ddlAgencia.SelectedValue + "</strong> presentando tu DUI para retirar tu tarjeta débito. Enviamos la confirmación a tu correo <strong>" + txtCorreo.Text + "</strong>.</p>";

            // Limpieza de campos
            txtNombre.Text = "";
            txtDUI.Text = "";
            txtTelefono.Text = "";
            txtCorreo.Text = "";
        }

        protected void btnPortalSocio_Click(object sender, EventArgs e)
        {
            Response.Redirect("PortalSocio.aspx");
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("../Default.aspx");
        }
    }
}