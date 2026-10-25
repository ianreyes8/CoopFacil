using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CoopFacil.Pages
{
    public partial class AhorroProgramado : System.Web.UI.Page
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

            // IMPORTANTE: Se elimina la autocompletación automática de txtNombre.Text
            // para requerir obligatoriamente el llenado manual por parte del usuario.
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

        protected void btnContratarPlan_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) || string.IsNullOrWhiteSpace(txtDUI.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) || string.IsNullOrWhiteSpace(txtCorreo.Text) ||
                string.IsNullOrWhiteSpace(txtCuotaMensualForm.Text) || string.IsNullOrEmpty(ddlMetaForm.SelectedValue) ||
                string.IsNullOrEmpty(ddlPlazoForm.SelectedValue) || string.IsNullOrEmpty(ddlDiaDebito.SelectedValue))
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> Por favor, completa manualmente todos los campos requeridos para contratar tu plan de ahorro programado.";
                return;
            }

            // Limpiar comas del monto cuota
            string cuotaLimpia = txtCuotaMensualForm.Text.Replace(",", "").Trim();
            decimal cuota;

            if (!decimal.TryParse(cuotaLimpia, out cuota) || cuota < 10 || cuota > 500)
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> La cuota mensual programada debe ser entre $10.00 y $500.00 USD.";
                return;
            }

            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-emerald-500/50 bg-emerald-950/40 text-emerald-300 flex flex-col gap-2 text-xs font-medium";
            litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-emerald-400'>" +
                              "<i class='fa-solid fa-circle-check text-lg'></i> ¡Plan de Ahorro Programado Contratado con Éxito!</div>" +
                              "<p class='mt-1 text-slate-200'>Estimado/a <strong>" + txtNombre.Text + "</strong>, se ha activado tu plan con meta <strong>\"" + ddlMetaForm.SelectedValue + "\"</strong>.</p>" +
                              "<p class='text-xs text-slate-300'>Se realizará un débito automático mensual de <strong>$" + cuota.ToString("N2") + " USD</strong> los días <strong>" + ddlDiaDebito.SelectedValue + " de cada mes</strong> a un plazo de <strong>" + ddlPlazoForm.SelectedValue + " meses</strong>. Confirmación enviada a <strong>" + txtCorreo.Text + "</strong>.</p>";

            // Limpiar formulario tras el envío exitoso
            txtNombre.Text = "";
            txtDUI.Text = "";
            txtTelefono.Text = "";
            txtCorreo.Text = "";
            txtCuotaMensualForm.Text = "";
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