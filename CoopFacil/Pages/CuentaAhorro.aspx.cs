using System;
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

            // 1. Sesión ndoikói ramóma, oho Default.aspx-pe
            if (string.IsNullOrEmpty(nombreUsuario))
            {
                Response.Redirect("../Default.aspx");
                return;
            }

            // 2. Sesión oĩ porã ramóma, ohechauka barra personalizada téra ha apellido ndive
            pnlBienvenida.Visible = true;
            litBienvenida.Text = nombreUsuario;
            lnkIniciarSesion.Visible = false;
            btnPortalSocio.Visible = true;
            btnCerrarSesion.Visible = true;

            if (string.IsNullOrEmpty(txtNombre.Text))
            {
                txtNombre.Text = nombreUsuario;
            }
        }

        private string ObtenerNombreUsuarioSesion()
        {
            // Claves téra ha apellido rehegua
            string[] clavesNombre = new string[] { "UsuarioNombre", "NombreUsuario", "NombreCompleto", "Usuario", "Nombre", "nombre", "usuario" };

            foreach (string clave in clavesNombre)
            {
                if (Session[clave] != null)
                {
                    string valor = Session[clave].ToString().Trim();
                    // Ojehecha ndaha'éirõ número (ID)
                    if (!string.IsNullOrWhiteSpace(valor) && !int.TryParse(valor, out _))
                    {
                        return valor;
                    }
                }
            }

            // Ojeheka ambue clave-pe tekotevẽramo, omboyke haguã umi ID numérico
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

        protected void btnSolicitarApertura_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) || string.IsNullOrWhiteSpace(txtDUI.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) || string.IsNullOrWhiteSpace(txtCorreo.Text) ||
                string.IsNullOrEmpty(ddlAgencia.SelectedValue))
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> Por favor, completa todos los campos requeridos para procesar la pre-apertura.";
                return;
            }

            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-emerald-500/50 bg-emerald-950/40 text-emerald-300 flex items-center gap-3 text-xs font-bold";
            litMensaje.Text = "<i class='fa-solid fa-circle-check text-base'></i> ¡Solicitud de Pre-Apertura enviada con éxito! Un ejecutivo se comunicará al " + txtTelefono.Text + " para coordinar la entrega de tu tarjeta en " + ddlAgencia.SelectedValue + ".";

            txtDUI.Text = "";
            txtTelefono.Text = "";
            txtCorreo.Text = "";
            ddlAgencia.SelectedIndex = 0;
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