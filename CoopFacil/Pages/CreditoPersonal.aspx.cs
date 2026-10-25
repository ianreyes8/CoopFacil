using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CoopFacil.Pages
{
    public partial class CreditoPersonal : System.Web.UI.Page
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

            // 1. Si no hay sesión activa, redirige a Default.aspx
            if (string.IsNullOrEmpty(nombreUsuario))
            {
                Response.Redirect("../Default.aspx");
                return;
            }

            // 2. Si la sesión es válida, muestra el saludo y los controles de usuario
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
            // Validación de campos requeridos
            if (string.IsNullOrWhiteSpace(txtNombre.Text) || string.IsNullOrWhiteSpace(txtDUI.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) || string.IsNullOrWhiteSpace(txtCorreo.Text) ||
                string.IsNullOrWhiteSpace(txtIngresos.Text) || string.IsNullOrWhiteSpace(txtMontoSolicitado.Text) ||
                string.IsNullOrEmpty(ddlPlazoSolicitado.SelectedValue) || string.IsNullOrEmpty(ddlOcupacion.SelectedValue) ||
                string.IsNullOrEmpty(ddlDestino.SelectedValue) || string.IsNullOrEmpty(ddlEstadoCivil.SelectedValue))
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> Por favor, completa todos los campos requeridos para evaluar tu solicitud de crédito.";
                return;
            }

            decimal ingresos, montoSolicitado;
            int plazoMeses;

            if (!decimal.TryParse(txtIngresos.Text, out ingresos) || ingresos <= 0)
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> Ingrese un monto de ingresos mensuales válido.";
                return;
            }

            if (!decimal.TryParse(txtMontoSolicitado.Text, out montoSolicitado) || montoSolicitado < 500 || montoSolicitado > 15000)
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> El monto solicitado debe estar entre $500.00 y $15,000.00 USD.";
                return;
            }

            int.TryParse(ddlPlazoSolicitado.SelectedValue, out plazoMeses);

            // Cálculo financiero en servidor: Cuota mensual estimada a 10% EA (nominal mensual = 10% / 12)
            double tasaNominalMensual = (0.10 / 12.0);
            double P = (double)montoSolicitado;
            int n = plazoMeses;
            double cuotaMensual = P * (tasaNominalMensual * Math.Pow(1 + tasaNominalMensual, n)) / (Math.Pow(1 + tasaNominalMensual, n) - 1);

            // Cálculo del Nivel de Endeudamiento (Ratio Cuota / Ingresos)
            decimal ratioEndeudamiento = ((decimal)cuotaMensual / ingresos) * 100m;

            pnlMensaje.Visible = true;

            if (ratioEndeudamiento <= 40m)
            {
                pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-emerald-500/50 bg-emerald-950/40 text-emerald-300 flex flex-col gap-2 text-xs font-medium";
                litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-emerald-400'>" +
                                  "<i class='fa-solid fa-circle-check text-lg'></i> Dictamen Preliminar: <strong>Pre-Aprobado Sujeto a Comprobantes</strong></div>" +
                                  "<p class='mt-1 text-slate-200'>Tu capacidad de pago es óptima. La cuota mensual estimada de <strong>$" + cuotaMensual.ToString("N2") + " USD</strong> representa el <strong>" + ratioEndeudamiento.ToString("N1") + "%</strong> de tus ingresos mensuales ($" + ingresos.ToString("N2") + " USD).</p>" +
                                  "<p class='text-xs text-slate-300'>Un ejecutivo revisará los comprobantes adjuntos (DUI, constancia de sueldo y recibo de luz/agua) para la firma final del desembolso para <strong>" + ddlDestino.SelectedValue + "</strong>.</p>";
            }
            else
            {
                pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-amber-500/50 bg-amber-950/40 text-amber-300 flex flex-col gap-2 text-xs font-medium";
                litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-amber-400'>" +
                                  "<i class='fa-solid fa-triangle-exclamation text-lg'></i> Dictamen Preliminar: <strong>Sujeto a Análisis de Riesgo Especial</strong></div>" +
                                  "<p class='mt-1 text-slate-200'>La cuota estimada de <strong>$" + cuotaMensual.ToString("N2") + " USD</strong> representa el <strong>" + ratioEndeudamiento.ToString("N1") + "%</strong> de tus ingresos mensuales, superando el límite estándar del 40%.</p>" +
                                  "<p class='text-xs text-slate-300'>Te sugerimos aumentar el plazo a <strong>" + (plazoMeses < 120 ? (plazoMeses + 12).ToString() + " meses" : "120 meses") + "</strong> o presentar un consolidador de ingresos para facilitar la aprobación.</p>";
            }

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