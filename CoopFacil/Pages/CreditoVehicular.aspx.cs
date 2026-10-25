using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CoopFacil.Pages
{
    public partial class CreditoVehicular : System.Web.UI.Page
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

            if (string.IsNullOrEmpty(txtNombre.Text))
            {
                txtNombre.Text = nombreUsuario;
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

        protected void btnSolicitarCredito_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) || string.IsNullOrWhiteSpace(txtDUI.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) || string.IsNullOrWhiteSpace(txtCorreo.Text) ||
                string.IsNullOrWhiteSpace(txtPrecioComercial.Text) || string.IsNullOrWhiteSpace(txtPrimaInicial.Text) ||
                string.IsNullOrWhiteSpace(txtMarcaModelo.Text) || string.IsNullOrWhiteSpace(txtConcesionario.Text) ||
                string.IsNullOrEmpty(ddlEstadoVehiculo.SelectedValue) || string.IsNullOrEmpty(ddlPlazoMeses.SelectedValue))
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> Por favor, completa todos los campos requeridos para enviar tu solicitud de crédito vehicular.";
                return;
            }

            decimal precio, prima;
            if (!decimal.TryParse(txtPrecioComercial.Text, out precio) || precio < 3000)
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> El precio comercial del vehículo debe ser mayor o igual a $3,000.00 USD.";
                return;
            }

            if (!decimal.TryParse(txtPrimaInicial.Text, out prima) || prima < 0)
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> Ingrese un monto de prima inicial válido.";
                return;
            }

            bool esNuevo = ddlEstadoVehiculo.SelectedValue == "Nuevo";
            decimal porcentajeFinanciamientoMax = esNuevo ? 80m : 70m;
            decimal primaMinimaRequerida = precio * ((100m - porcentajeFinanciamientoMax) / 100m);

            if (prima < primaMinimaRequerida)
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-amber-500/50 bg-amber-950/40 text-amber-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> Para un vehículo <strong>" + ddlEstadoVehiculo.SelectedValue + "</strong>, la prima mínima requerida es del <strong>" + (100m - porcentajeFinanciamientoMax).ToString("N0") + "% ($" + primaMinimaRequerida.ToString("N2") + " USD)</strong> para financiar el " + porcentajeFinanciamientoMax.ToString("N0") + "% restante.";
                return;
            }

            decimal montoAFinanciar = precio - prima;
            int plazo = int.Parse(ddlPlazoMeses.SelectedValue);

            string estadoAdjunto = "No se adjuntó archivo digital";
            if (fileProforma.HasFile)
            {
                string extension = Path.GetExtension(fileProforma.FileName).ToLower();
                if (extension == ".pdf" || extension == ".jpg" || extension == ".png" || extension == ".jpeg")
                {
                    estadoAdjunto = "Documento adjunto (" + fileProforma.FileName + ")";
                }
            }

            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-emerald-500/50 bg-emerald-950/40 text-emerald-300 flex flex-col gap-2 text-xs font-medium";
            litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-emerald-400'>" +
                              "<i class='fa-solid fa-circle-check text-lg'></i> Solicitud Enviada al Departamento de Riesgos</div>" +
                              "<p class='mt-1 text-slate-200'>Tu solicitud para un vehículo <strong>" + ddlEstadoVehiculo.SelectedValue + " (" + txtMarcaModelo.Text + ")</strong> en <strong>" + txtConcesionario.Text + "</strong> ha sido registrada con éxito.</p>" +
                              "<p class='text-xs text-slate-300'><strong>Monto a Financiar:</strong> $" + montoAFinanciar.ToString("N2") + " USD a <strong>" + plazo + " meses</strong>. Estado de proforma: <em>" + estadoAdjunto + "</em>. Un analista de riesgos te contactará al <strong>" + txtTelefono.Text + "</strong> o vía correo a <strong>" + txtCorreo.Text + "</strong> en menos de 24 horas.</p>";

            txtDUI.Text = "";
            txtTelefono.Text = "";
            txtCorreo.Text = "";
            txtMarcaModelo.Text = "";
            txtConcesionario.Text = "";
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