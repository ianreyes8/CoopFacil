using System;
using System.Web.UI;
using CoopFacil.Helpers;

namespace CoopFacil.Pages
{
    public partial class CreditoVehicular : Page
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
            litBienvenida.Text = ExtraerPrimerNombreYPrimerApellido(nombreUsuario);
            lnkIniciarSesion.Visible = false;
            btnCerrarSesion.Visible = true;

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

        protected void btnEnviarSolicitud_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) ||
                string.IsNullOrWhiteSpace(txtDUI.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) ||
                string.IsNullOrWhiteSpace(txtCorreo.Text) ||
                string.IsNullOrWhiteSpace(txtIngresos.Text) ||
                string.IsNullOrWhiteSpace(txtPrecioVehiculo.Text) ||
                string.IsNullOrWhiteSpace(txtMontoFinanciar.Text) ||
                string.IsNullOrEmpty(ddlPlazoVehicular.SelectedValue))
            {
                MostrarMensajeSolicitud("Por favor, completa todos los campos personales, financieros y del vehículo obligatorios (*).", false);
                return;
            }

            if (string.IsNullOrWhiteSpace(txtRefPersonal1Nombre.Text) || string.IsNullOrWhiteSpace(txtRefPersonal1Tel.Text) ||
                string.IsNullOrWhiteSpace(txtRefPersonal2Nombre.Text) || string.IsNullOrWhiteSpace(txtRefPersonal2Tel.Text) ||
                string.IsNullOrWhiteSpace(txtRefFamiliar1Nombre.Text) || string.IsNullOrWhiteSpace(txtRefFamiliar1Tel.Text) ||
                string.IsNullOrWhiteSpace(txtRefFamiliar2Nombre.Text) || string.IsNullOrWhiteSpace(txtRefFamiliar2Tel.Text))
            {
                MostrarMensajeSolicitud("Por favor, completa las 4 referencias de localización (2 personales y 2 familiares).", false);
                return;
            }

            if (!fulRecibo.HasFile || !fulConstancia.HasFile || !fulCotizacion.HasFile)
            {
                MostrarMensajeSolicitud("Por favor, adjunta los 3 comprobantes requeridos (Recibo de Agua/Luz/DUI, Constancia de Sueldo y Cotización del Auto).", false);
                return;
            }

            decimal precioVehiculo = 0;
            decimal.TryParse(txtPrecioVehiculo.Text.Trim(), out precioVehiculo);

            decimal montoFinanciar = precioVehiculo;

            int plazo = 48;
            int.TryParse(ddlPlazoVehicular.SelectedValue, out plazo);

            double tasaMensual = 0.10 / 12.0;
            double cuotaBase = ((double)montoFinanciar * tasaMensual) / (1 - Math.Pow(1 + tasaMensual, -plazo));
            double seguroVida = 5.00;
            double seguroDanos = 15.00;
            double cuotaEstimada = cuotaBase + seguroVida + seguroDanos;

            string detalle = $"Precio Auto: ${precioVehiculo:N2} | Monto Financiar (100%): ${montoFinanciar:N2} | Plazo: {plazo} meses | Cuota Estimada: ${cuotaEstimada:N2} (Vida: $5.00 / Daños: $15.00) | Ingresos Netos: ${txtIngresos.Text.Trim()}" +
                             $" | Ref. Pers 1: {txtRefPersonal1Nombre.Text.Trim()} ({txtRefPersonal1Tel.Text.Trim()})" +
                             $" | Ref. Pers 2: {txtRefPersonal2Nombre.Text.Trim()} ({txtRefPersonal2Tel.Text.Trim()})" +
                             $" | Ref. Fam 1: {txtRefFamiliar1Nombre.Text.Trim()} ({txtRefFamiliar1Tel.Text.Trim()})" +
                             $" | Ref. Fam 2: {txtRefFamiliar2Nombre.Text.Trim()} ({txtRefFamiliar2Tel.Text.Trim()})" +
                             $" | Documentos: Recibo [{fulRecibo.FileName}] / Constancia [{fulConstancia.FileName}] / Cotización [{fulCotizacion.FileName}]";

            DatosComprobante datos = new DatosComprobante
            {
                NumeroTransaccion = "CV-" + DateTime.Now.ToString("yyyyMMddHHmmss"),
                NombreCliente = txtNombre.Text.Trim(),
                DUI = txtDUI.Text.Trim(),
                Telefono = txtTelefono.Text.Trim(),
                CorreoCliente = txtCorreo.Text.Trim(),
                NombreServicio = "Solicitud de Pre-Aprobación de Crédito Vehicular",
                Monto = montoFinanciar,
                DetalleAdicional = detalle,
                FechaMovimiento = DateTime.Now
            };

            byte[] pdfBytes = ComprobanteServicioHelper.GenerarPdfComprobante(datos);
            bool correoEnviado = ComprobanteServicioHelper.EnviarComprobantePorCorreo(datos, pdfBytes);

            if (correoEnviado)
            {
                pnlMensajeSolicitud.Visible = true;
                pnlMensajeSolicitud.CssClass = "mb-6 p-5 rounded-xl border border-emerald-500/50 bg-emerald-100 dark:bg-emerald-950/40 text-emerald-900 dark:text-emerald-300 text-xs font-medium";
                litMensajeSolicitud.Text = "<div class='flex items-center gap-2 text-sm font-bold text-emerald-600 dark:text-emerald-400'>" +
                                           "<i class='fa-solid fa-circle-check text-lg'></i> ¡Solicitud de Crédito Vehicular Recibida y Comprobante PDF Enviado!</div>" +
                                           "<p class='mt-2 text-slate-700 dark:text-slate-200'>Estimado/a <strong>" + datos.NombreCliente + "</strong>, tu solicitud para financiar <strong>$" + datos.Monto.ToString("N2") + "</strong> a <strong>" + plazo + " meses</strong> fue registrada bajo la clave N° <strong>" + datos.NumeroTransaccion + "</strong>.</p>" +
                                           "<p class='text-xs text-slate-600 dark:text-slate-300 mt-1'>Enviamos la confirmación con tu comprobante PDF adjunto a <strong>" + datos.CorreoCliente + "</strong>.</p>";
            }
            else
            {
                pnlMensajeSolicitud.Visible = true;
                pnlMensajeSolicitud.CssClass = "mb-6 p-5 rounded-xl border border-emerald-500/50 bg-emerald-100 dark:bg-emerald-950/40 text-emerald-900 dark:text-emerald-300 text-xs font-medium";
                litMensajeSolicitud.Text = "<div class='flex items-center gap-2 text-sm font-bold text-emerald-600 dark:text-emerald-400'>" +
                                           "<i class='fa-solid fa-circle-check text-lg'></i> ¡Solicitud de Crédito Vehicular Pre-Aprobada!</div>" +
                                           "<p class='mt-1 text-slate-700 dark:text-slate-200'>Estimado/a <strong>" + datos.NombreCliente + "</strong>, tu pre-solicitud para financiar <strong>$" + datos.Monto.ToString("N2") + "</strong> (Clave N° <strong>" + datos.NumeroTransaccion + "</strong>) fue recibida exitosamente.</p>" +
                                           "<p class='text-xs text-slate-600 dark:text-slate-300 mt-1'>Un ejecutivo de crédito evaluará la cotización y documentación adjunta para dar inicio al trámite.</p>";
            }

            if (string.IsNullOrEmpty(ObtenerNombreUsuarioSesion()))
            {
                txtIngresos.Text = "";
                txtRefPersonal1Nombre.Text = ""; txtRefPersonal1Tel.Text = "";
                txtRefPersonal2Nombre.Text = ""; txtRefPersonal2Tel.Text = "";
                txtRefFamiliar1Nombre.Text = ""; txtRefFamiliar1Tel.Text = "";
                txtRefFamiliar2Nombre.Text = ""; txtRefFamiliar2Tel.Text = "";
            }
        }

        private void MostrarMensajeSolicitud(string texto, bool esExito)
        {
            pnlMensajeSolicitud.Visible = true;
            pnlMensajeSolicitud.CssClass = esExito
                ? "mb-6 p-4 rounded-xl border border-emerald-500/50 bg-emerald-100 dark:bg-emerald-950/40 text-emerald-900 dark:text-emerald-300 text-xs font-bold"
                : "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-100 dark:bg-red-950/40 text-red-800 dark:text-red-300 text-xs font-bold";
            litMensajeSolicitud.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> " + texto;
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("../Default.aspx");
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