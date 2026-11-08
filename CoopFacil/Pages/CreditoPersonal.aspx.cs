using System;
using System.Collections.Generic;
using System.Web.UI;
using CoopFacil.Helpers;

namespace CoopFacil.Pages
{
    public partial class CreditoPersonal : Page
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
            string duiSesion = ObtenerDUIUsuarioSesion();

            if (!string.IsNullOrEmpty(nombreUsuario))
            {
                pnlBienvenida.Visible = true;
                litBienvenida.Text = ExtraerPrimerNombreYPrimerApellido(nombreUsuario);
                lnkIniciarSesion.Visible = false;
                btnCerrarSesion.Visible = true;

                if (string.IsNullOrEmpty(txtNombre.Text)) txtNombre.Text = nombreUsuario;
            }

            string correoSesion = ObtenerCorreoUsuarioSesion();
            if (!string.IsNullOrEmpty(correoSesion) && string.IsNullOrEmpty(txtCorreo.Text)) txtCorreo.Text = correoSesion;
            if (!string.IsNullOrEmpty(duiSesion) && string.IsNullOrEmpty(txtDUI.Text)) txtDUI.Text = duiSesion;

            string telefonoSesion = ObtenerTelefonoUsuarioSesion();
            if (!string.IsNullOrEmpty(telefonoSesion) && string.IsNullOrEmpty(txtTelefono.Text)) txtTelefono.Text = telefonoSesion;

            // Sincronizar estado desde el Repositorio Persistente
            if (!string.IsNullOrEmpty(duiSesion))
            {
                var socio = RepositorioBanco.ObtenerOcrear(duiSesion, nombreUsuario);
                Session["ListaCreditos"] = socio.Creditos;
                Session["TieneCuentaAhorro"] = socio.TieneCuentaAhorro;
                if (socio.TieneCuentaAhorro) Session["NumeroCuentaAhorro"] = socio.NumeroCuenta;
            }
        }

        private string ObtenerNombreUsuarioSesion()
        {
            string[] clavesNombre = new string[] { "ClienteNombreCompleto", "UsuarioNombre", "NombreUsuario", "NombreCompleto", "Usuario" };
            foreach (string clave in clavesNombre)
            {
                if (Session[clave] != null && !string.IsNullOrWhiteSpace(Session[clave].ToString()))
                    return Session[clave].ToString().Trim();
            }
            return null;
        }

        private string ObtenerCorreoUsuarioSesion()
        {
            string[] clavesCorreo = new string[] { "UsuarioCorreo", "CorreoUsuario", "Correo", "Email" };
            foreach (string clave in clavesCorreo)
            {
                if (Session[clave] != null && Session[clave].ToString().Contains("@"))
                    return Session[clave].ToString().Trim();
            }
            return null;
        }

        private string ObtenerDUIUsuarioSesion()
        {
            string[] clavesDUI = new string[] { "ClienteDUI", "UsuarioDUI", "DUI" };
            foreach (string clave in clavesDUI)
            {
                if (Session[clave] != null) return Session[clave].ToString().Trim();
            }
            return null;
        }

        private string ObtenerTelefonoUsuarioSesion()
        {
            string[] clavesTelefono = new string[] { "UsuarioTelefono", "Telefono" };
            foreach (string clave in clavesTelefono)
            {
                if (Session[clave] != null) return Session[clave].ToString().Trim();
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
                string.IsNullOrWhiteSpace(txtMontoSolicitado.Text) ||
                string.IsNullOrEmpty(ddlPlazo.SelectedValue))
            {
                MostrarMensajeSolicitud("Por favor, completa todos los campos personales y financieros obligatorios (*).", false);
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

            if (!fulRecibo.HasFile || !fulConstancia.HasFile)
            {
                MostrarMensajeSolicitud("Por favor, adjunta ambos comprobantes requeridos (Recibo de Agua/Luz/DUI y Constancia de Sueldo).", false);
                return;
            }

            decimal monto = 0;
            decimal.TryParse(txtMontoSolicitado.Text.Trim(), out monto);

            int plazo = 36;
            int.TryParse(ddlPlazo.SelectedValue, out plazo);

            double tasaMensual = 0.10 / 12.0;
            double cuotaEstimada = ((double)monto * tasaMensual) / (1 - Math.Pow(1 + tasaMensual, -plazo));

            string detalle = $"Monto Solicitado: ${monto:N2} | Plazo: {plazo} meses | Cuota Estimada: ${cuotaEstimada:N2} | Ingresos Netos: ${txtIngresos.Text.Trim()}";

            DatosComprobante datos = new DatosComprobante
            {
                NumeroTransaccion = "CP-" + DateTime.Now.ToString("yyyyMMddHHmmss"),
                NombreCliente = txtNombre.Text.Trim(),
                DUI = txtDUI.Text.Trim(),
                Telefono = txtTelefono.Text.Trim(),
                CorreoCliente = txtCorreo.Text.Trim(),
                NombreServicio = "Solicitud de Pre-Aprobación de Crédito Personal",
                Monto = monto,
                DetalleAdicional = detalle,
                FechaMovimiento = DateTime.Now
            };

            CreditoSolicitado nuevoCredito = new CreditoSolicitado
            {
                TipoCredito = "Crédito Personal",
                Monto = monto,
                PlazoMeses = plazo,
                CuotaMensual = (decimal)cuotaEstimada,
                NumeroTransaccion = datos.NumeroTransaccion,
                FechaMovimiento = DateTime.Now
            };

            // 1. Registrar crédito en el Repositorio Persistente del Socio
            RepositorioBanco.AgregarCredito(datos.DUI, nuevoCredito);
            var socio = RepositorioBanco.ObtenerOcrear(datos.DUI, datos.NombreCliente);

            Session["ListaCreditos"] = socio.Creditos;
            Session["ClienteNombreCompleto"] = datos.NombreCliente;
            Session["ClienteDUI"] = datos.DUI;

            // 2. Generar y Enviar PDF Comprobante por Correo
            byte[] pdfBytes = ComprobanteServicioHelper.GenerarPdfComprobante(datos);
            bool correoEnviado = ComprobanteServicioHelper.EnviarComprobantePorCorreo(datos, pdfBytes);

            // 3. Evaluar si YA aperturó cuenta de ahorro previamente
            bool tieneCuenta = socio.TieneCuentaAhorro || (Session["TieneCuentaAhorro"] != null && (bool)Session["TieneCuentaAhorro"]);
            string htmlBotonAccion = "";

            if (tieneCuenta)
            {
                // YA TIENE CUENTA -> Botón direct a CuentaAhorro.aspx
                htmlBotonAccion =
                    "<div class='mt-4 pt-4 border-t border-blue-200 dark:border-blue-800/60 flex flex-col sm:flex-row items-center justify-between gap-4'>" +
                    "  <div class='flex items-center gap-2 text-xs font-bold text-slate-800 dark:text-slate-100'>" +
                    "    <i class='fa-solid fa-circle-check text-emerald-600 dark:text-emerald-400 text-base'></i>" +
                    "    <span>Su crédito ha sido procesado. El monto fue acumulado en su cuenta de ahorro.</span>" +
                    "  </div>" +
                    "  <a href='CuentaAhorro.aspx' class='bg-blue-600 hover:bg-blue-500 text-white font-extrabold text-xs px-5 py-3 rounded-xl transition flex items-center gap-2 shadow-lg shadow-blue-600/20 whitespace-nowrap'>" +
                    "    <i class='fa-solid fa-wallet'></i> Ver mi Cuenta de Ahorro" +
                    "  </a>" +
                    "</div>";
            }
            else
            {
                // NO TIENE CUENTA -> Botón a RegistroCredito.aspx
                htmlBotonAccion =
                    "<div class='mt-4 pt-4 border-t border-blue-200 dark:border-blue-800/60 flex flex-col sm:flex-row items-center justify-between gap-4'>" +
                    "  <div class='flex items-center gap-2 text-xs font-bold text-slate-800 dark:text-slate-100'>" +
                    "    <i class='fa-solid fa-circle-info text-blue-600 dark:text-blue-400 text-base'></i>" +
                    "    <span>Para el desembolso del dinero de su crédito aperture su cuenta de ahorro.</span>" +
                    "  </div>" +
                    "  <a href='RegistroCredito.aspx' class='bg-emerald-600 hover:bg-emerald-500 text-white font-extrabold text-xs px-5 py-3 rounded-xl transition flex items-center gap-2 shadow-lg shadow-emerald-600/20 whitespace-nowrap'>" +
                    "    <i class='fa-solid fa-wallet'></i> Aperturar mi Cuenta de Ahorro" +
                    "  </a>" +
                    "</div>";
            }

            pnlMensajeSolicitud.Visible = true;
            pnlMensajeSolicitud.CssClass = "mb-6 p-5 rounded-2xl border border-blue-500/50 bg-blue-100 dark:bg-[#0F233D] text-blue-900 dark:text-blue-300 text-xs font-medium shadow-md";

            if (correoEnviado)
            {
                litMensajeSolicitud.Text = "<div class='flex items-center gap-2 text-sm font-bold text-blue-600 dark:text-blue-400'>" +
                                           "<i class='fa-solid fa-circle-check text-lg'></i> ¡Solicitud de Crédito Personal Recibida y Comprobante PDF Enviado!</div>" +
                                           "<p class='mt-2 text-slate-700 dark:text-slate-200'>Estimado/a <strong>" + datos.NombreCliente + "</strong>, tu solicitud por <strong>$" + datos.Monto.ToString("N2") + "</strong> a <strong>" + plazo + " meses</strong> fue ingresada con la clave N° <strong>" + datos.NumeroTransaccion + "</strong>.</p>" +
                                           "<p class='text-xs text-slate-600 dark:text-slate-300 mt-1'>Enviamos la confirmación con tu comprobante PDF adjunto a <strong>" + datos.CorreoCliente + "</strong>.</p>" +
                                           htmlBotonAccion;
            }
            else
            {
                litMensajeSolicitud.Text = "<div class='flex items-center gap-2 text-sm font-bold text-blue-600 dark:text-blue-400'>" +
                                           "<i class='fa-solid fa-circle-check text-lg'></i> ¡Solicitud de Crédito Personal Pre-Aprobada!</div>" +
                                           "<p class='mt-1 text-slate-700 dark:text-slate-200'>Estimado/a <strong>" + datos.NombreCliente + "</strong>, tu pre-solicitud por <strong>$" + datos.Monto.ToString("N2") + "</strong> (Clave N° <strong>" + datos.NumeroTransaccion + "</strong>) ha sido registrada exitosamente.</p>" +
                                           htmlBotonAccion;
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
                ? "mb-6 p-4 rounded-xl border border-blue-500/50 bg-blue-100 dark:bg-blue-950/40 text-blue-900 dark:text-blue-300 text-xs font-bold"
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
            return $"{partes[0]} {partes[partes.Length - 1]}";
        }
    }
}