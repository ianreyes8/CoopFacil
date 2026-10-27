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
            // Validar campos personales/financieros y de la unidad
            if (string.IsNullOrWhiteSpace(txtNombre.Text) || string.IsNullOrWhiteSpace(txtDUI.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) || string.IsNullOrWhiteSpace(txtCorreo.Text) ||
                string.IsNullOrWhiteSpace(txtIngresos.Text) || string.IsNullOrWhiteSpace(txtMontoSolicitado.Text) ||
                string.IsNullOrWhiteSpace(txtMarcaModelo.Text) || string.IsNullOrWhiteSpace(txtConcesionario.Text) ||
                string.IsNullOrEmpty(ddlEstadoVehiculo.SelectedValue) || string.IsNullOrEmpty(ddlPlazoSolicitado.SelectedValue))
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> Por favor, completa todos los campos personales, financieros y del vehículo requeridos.";
                return;
            }

            // Validar las 4 referencias obligatorias
            if (string.IsNullOrWhiteSpace(txtRefPers1Nombre.Text) || string.IsNullOrWhiteSpace(txtRefPers1Tel.Text) ||
                string.IsNullOrWhiteSpace(txtRefPers2Nombre.Text) || string.IsNullOrWhiteSpace(txtRefPers2Tel.Text) ||
                string.IsNullOrWhiteSpace(txtRefFam1Nombre.Text) || string.IsNullOrWhiteSpace(txtRefFam1Tel.Text) ||
                string.IsNullOrWhiteSpace(txtRefFam2Nombre.Text) || string.IsNullOrWhiteSpace(txtRefFam2Tel.Text))
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> Debes completar las 4 referencias de recomendación (2 personales y 2 familiares) con nombre y teléfono.";
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

            if (!decimal.TryParse(txtMontoSolicitado.Text, out montoSolicitado) || montoSolicitado < 3000)
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> El monto solicitado debe ser mayor o igual a $3,000.00 USD.";
                return;
            }

            int.TryParse(ddlPlazoSolicitado.SelectedValue, out plazoMeses);

            // Estado de los archivos adjuntos
            string estadoAdjuntos = "Sin comprobantes digitales (presentación física requerida)";
            if (fileReciboDUI.HasFile || fileConstancia.HasFile || fileProforma.HasFile)
            {
                List<string> nombresAdjuntos = new List<string>();
                if (fileReciboDUI.HasFile) nombresAdjuntos.Add(fileReciboDUI.FileName);
                if (fileConstancia.HasFile) nombresAdjuntos.Add(fileConstancia.FileName);
                if (fileProforma.HasFile) nombresAdjuntos.Add(fileProforma.FileName);
                estadoAdjuntos = "Archivos cargados: " + string.Join(", ", nombresAdjuntos);
            }

            // Cálculo financiero de cuota mensual a 10% ANUAL (nominal mensual = 10% / 12)
            double tasaNominalMensual = (0.10 / 12.0);
            double P = (double)montoSolicitado;
            int n = plazoMeses;
            double cuotaMensualBase = P * (tasaNominalMensual * Math.Pow(1 + tasaNominalMensual, n)) / (Math.Pow(1 + tasaNominalMensual, n) - 1);

            // Estimación de seguros incluidos en cuota (0.03% vida + 0.05% daños auto)
            double segurosMensuales = (P * 0.0003) + (P * 0.0005);
            double cuotaTotal = cuotaMensualBase + segurosMensuales;

            // Ratio de Endeudamiento
            decimal ratioEndeudamiento = ((decimal)cuotaTotal / ingresos) * 100m;

            pnlMensaje.Visible = true;

            if (ratioEndeudamiento <= 40m)
            {
                pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-emerald-500/50 bg-emerald-950/40 text-emerald-300 flex flex-col gap-2 text-xs font-medium";
                litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-emerald-400'>" +
                                  "<i class='fa-solid fa-circle-check text-lg'></i> Dictamen Preliminar: <strong>Pre-Aprobado Sujeto a Inspección Vehicular</strong></div>" +
                                  "<p class='mt-1 text-slate-200'>Tu capacidad de pago es óptima. La cuota mensual estimada de <strong>$" + cuotaTotal.ToString("N2") + " USD</strong> representa el <strong>" + ratioEndeudamiento.ToString("N1") + "%</strong> de tus ingresos mensuales ($" + ingresos.ToString("N2") + " USD).</p>" +
                                  "<p class='text-xs text-slate-300'>Se han registrado tus <strong>4 recomendaciones de localización</strong>, datos de la unidad (<em>" + txtMarcaModelo.Text + " - " + txtConcesionario.Text + "</em>) y el estado de adjuntos: <em>\"" + estadoAdjuntos + "\"</em>.</p>";
            }
            else
            {
                pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-amber-500/50 bg-amber-950/40 text-amber-300 flex flex-col gap-2 text-xs font-medium";
                litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-amber-400'>" +
                                  "<i class='fa-solid fa-triangle-exclamation text-lg'></i> Dictamen Preliminar: <strong>Sujeto a Análisis de Riesgo Especial</strong></div>" +
                                  "<p class='mt-1 text-slate-200'>La cuota estimada de <strong>$" + cuotaTotal.ToString("N2") + " USD</strong> representa el <strong>" + ratioEndeudamiento.ToString("N1") + "%</strong> de tus ingresos mensuales, superando el límite recomendado del 40%.</p>" +
                                  "<p class='text-xs text-slate-300'>Guardamos tus 4 contactos de respaldo y adjuntos. Te sugerimos ampliar el plazo de financiamiento para reducir la cuota mensual.</p>";
            }

            // Limpieza de campos tras procesar
            txtDUI.Text = "";
            txtTelefono.Text = "";
            txtCorreo.Text = "";
            txtMarcaModelo.Text = "";
            txtConcesionario.Text = "";
            txtRefPers1Nombre.Text = "";
            txtRefPers1Tel.Text = "";
            txtRefPers2Nombre.Text = "";
            txtRefPers2Tel.Text = "";
            txtRefFam1Nombre.Text = "";
            txtRefFam1Tel.Text = "";
            txtRefFam2Nombre.Text = "";
            txtRefFam2Tel.Text = "";
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("../Default.aspx");
        }
    }
}