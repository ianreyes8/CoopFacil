using System;
using CoopFacil.Compat;
using System.Web.UI;
using CoopFacil.Helpers;

namespace CoopFacil.Pages
{
    public partial class AhorroProgramado : PaginaWeb
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

            // Precargar datos del socio si ya existen en la sesión activa
            if (string.IsNullOrEmpty(txtNombre.Text))
            {
                txtNombre.Text = nombreUsuario;
            }

            string correoSesion = ObtenerCorreoUsuarioSesion();
            if (!string.IsNullOrEmpty(correoSesion) && string.IsNullOrEmpty(txtCorreo.Text))
            {
                txtCorreo.Text = correoSesion;
            }

            string duiSesion = ObtenerDUIUsuarioSesion();
            if (!string.IsNullOrEmpty(duiSesion) && string.IsNullOrEmpty(txtDUI.Text))
            {
                txtDUI.Text = duiSesion;
            }

            string telefonoSesion = ObtenerTelefonoUsuarioSesion();
            if (!string.IsNullOrEmpty(telefonoSesion) && string.IsNullOrEmpty(txtTelefono.Text))
            {
                txtTelefono.Text = telefonoSesion;
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
            return null;
        }

        private string ObtenerCorreoUsuarioSesion()
        {
            string[] clavesCorreo = new string[] { "UsuarioCorreo", "CorreoUsuario", "Correo", "Email", "email", "correo" };

            foreach (string clave in clavesCorreo)
            {
                if (Session[clave] != null)
                {
                    string valor = Session[clave].ToString().Trim();
                    if (!string.IsNullOrWhiteSpace(valor) && valor.Contains("@"))
                    {
                        return valor;
                    }
                }
            }
            return null;
        }

        private string ObtenerDUIUsuarioSesion()
        {
            string[] clavesDUI = new string[] { "UsuarioDUI", "DUI", "Dui", "dui" };

            foreach (string clave in clavesDUI)
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

        private string ObtenerTelefonoUsuarioSesion()
        {
            string[] clavesTelefono = new string[] { "UsuarioTelefono", "Telefono", "telefono", "Tel" };

            foreach (string clave in clavesTelefono)
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

        protected void btnContratarPlan_Click(object sender, EventArgs e)
        {
            // 1. VALIDACIÓN DE CAMPOS DEL FORMULARIO
            if (string.IsNullOrWhiteSpace(txtNombre.Text) ||
                string.IsNullOrWhiteSpace(txtDUI.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) ||
                string.IsNullOrWhiteSpace(txtCorreo.Text) ||
                string.IsNullOrWhiteSpace(txtCuotaMensualForm.Text) ||
                string.IsNullOrEmpty(ddlMetaForm.SelectedValue) ||
                string.IsNullOrEmpty(ddlPlazoForm.SelectedValue) ||
                string.IsNullOrEmpty(ddlDiaDebito.SelectedValue))
            {
                MostrarMensaje("Por favor, completa todos los campos requeridos para procesar la contratación de tu plan.", false);
                return;
            }

            string cuotaLimpia = txtCuotaMensualForm.Text.Replace(",", "").Trim();
            if (!decimal.TryParse(cuotaLimpia, out decimal cuota) || cuota < 10 || cuota > 500)
            {
                MostrarMensaje("La cuota mensual programada debe ser un valor válido entre $10.00 y $500.00 USD.", false);
                return;
            }

            // 2. CREACIÓN DEL MODELO DE DATOS EN MEMORIA
            DatosComprobante datos = new DatosComprobante
            {
                NumeroTransaccion = "AP-" + DateTime.Now.ToString("yyyyMMddHHmmss"),
                NombreCliente = txtNombre.Text.Trim(),
                DUI = txtDUI.Text.Trim(),
                Telefono = txtTelefono.Text.Trim(),
                CorreoCliente = txtCorreo.Text.Trim(),
                NombreServicio = "Plan de Ahorro Programado (" + ddlMetaForm.SelectedItem.Text + ")",
                Monto = cuota,
                DetalleAdicional = "Plazo: " + ddlPlazoForm.SelectedItem.Text + " | Débito Automático: Día " + ddlDiaDebito.SelectedValue + " de cada mes",
                FechaMovimiento = DateTime.Now
            };

            // 3. GENERACIÓN DEL COMPROBANTE PDF EN MEMORIA
            byte[] pdfBytes = ComprobanteServicioHelper.GenerarPdfComprobante(datos);

            // 4. ENVÍO DEL COMPROBANTE AL CORREO REGISTRADO
            bool correoEnviado = ComprobanteServicioHelper.EnviarComprobantePorCorreo(datos, pdfBytes);

            // 5. RESPUESTA VISUAL AL CLIENTE EN PANTALLA
            if (correoEnviado)
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-emerald-500/50 bg-emerald-100 dark:bg-emerald-950/40 text-emerald-900 dark:text-emerald-300 text-xs font-medium";
                litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-emerald-600 dark:text-emerald-400'>" +
                                  "<i class='fa-solid fa-circle-check text-lg'></i> ¡Plan Contratado y Comprobante PDF Enviado al Correo!</div>" +
                                  "<p class='mt-2 text-slate-700 dark:text-slate-200'>Estimado/a <strong>" + datos.NombreCliente + "</strong>, tu plan de ahorro con meta <strong>\"" + ddlMetaForm.SelectedItem.Text + "\"</strong> fue contratado exitosamente bajo el comprobante N° <strong>" + datos.NumeroTransaccion + "</strong>.</p>" +
                                  "<p class='text-xs text-slate-600 dark:text-slate-300 mt-1'>Se ha enviado una copia oficial en formato PDF a <strong>" + datos.CorreoCliente + "</strong> con el desglose de cuotas y fechas de débito.</p>";
            }
            else
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-amber-500/50 bg-amber-100 dark:bg-amber-950/40 text-amber-900 dark:text-amber-300 text-xs font-medium";
                litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-amber-600 dark:text-amber-400'>" +
                                  "<i class='fa-solid fa-circle-check text-lg'></i> ¡Plan Contratado Exitosamente!</div>" +
                                  "<p class='mt-1 text-slate-700 dark:text-slate-200'>Estimado/a <strong>" + datos.NombreCliente + "</strong>, se registró la transacción N° <strong>" + datos.NumeroTransaccion + "</strong> por una cuota mensual de <strong>$" + datos.Monto.ToString("N2") + " USD</strong>.</p>" +
                                  "<p class='text-xs text-slate-600 dark:text-slate-300 mt-1'>Tu solicitud quedó registrada correctamente, pero no pudimos enviar el comprobante a tu correo en este momento. Guarda tu número de transacción; si necesitas el comprobante, contáctanos.</p>";
            }

            // Limpieza de campos post-contratación
            txtCuotaMensualForm.Text = "";
            txtDUI.Text = "";
            txtTelefono.Text = "";
        }

        private void MostrarMensaje(string texto, bool esExito)
        {
            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = esExito
                ? "mb-6 p-4 rounded-xl border border-emerald-500/50 bg-emerald-100 dark:bg-emerald-950/40 text-emerald-800 dark:text-emerald-300 text-xs font-bold"
                : "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-100 dark:bg-red-950/40 text-red-800 dark:text-red-300 text-xs font-bold";
            litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> " + texto;
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("../Default.aspx");
        }
    }
}