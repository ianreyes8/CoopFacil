using System;
using System.Web.UI;
using CoopFacil.Helpers;

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

                string correoSesion = ObtenerCorreoUsuarioSesion();
                if (!string.IsNullOrEmpty(correoSesion) && string.IsNullOrEmpty(txtEmail.Text))
                {
                    txtEmail.Text = correoSesion;
                }

                string telefonoSesion = ObtenerTelefonoUsuarioSesion();
                if (!string.IsNullOrEmpty(telefonoSesion) && string.IsNullOrEmpty(txtTelefono.Text))
                {
                    txtTelefono.Text = telefonoSesion;
                }
            }
        }

        private string ObtenerNombreUsuarioSesion()
        {
            string[] clavesNombre = new string[] { "NombreCompleto", "UsuarioNombre", "NombreUsuario", "Usuario", "Nombre", "nombre", "usuario" };

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

        protected void btnEnviarMensaje_Click(object sender, EventArgs e)
        {
            // 1. VALIDACIÓN DE CAMPOS DEL FORMULARIO
            if (string.IsNullOrWhiteSpace(txtNombre.Text) ||
                string.IsNullOrWhiteSpace(txtEmail.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) ||
                string.IsNullOrWhiteSpace(txtMensaje.Text) ||
                ddlTipoConsulta.SelectedItem == null)
            {
                MostrarMensaje("Por favor, completa todos los campos del formulario para enviar tu mensaje.", false);
                return;
            }

            string duiCliente = ObtenerDUIUsuarioSesion() ?? "N/A - Consulta General";
            string tipoConsulta = ddlTipoConsulta.SelectedItem.Text;
            string mensajeTexto = txtMensaje.Text.Trim();

            // Recorte del mensaje para el desglose del PDF si supera la longitud estética
            if (mensajeTexto.Length > 120)
            {
                mensajeTexto = mensajeTexto.Substring(0, 117) + "...";
            }

            // 2. CONSTRUCCIÓN DEL MODELO DE DATOS EN MEMORIA
            DatosComprobante datos = new DatosComprobante
            {
                NumeroTransaccion = "CT-" + DateTime.Now.ToString("yyyyMMddHHmmss"),
                NombreCliente = txtNombre.Text.Trim(),
                DUI = duiCliente,
                Telefono = txtTelefono.Text.Trim(),
                CorreoCliente = txtEmail.Text.Trim(),
                NombreServicio = "Registro de Consulta / Ticket (" + tipoConsulta + ")",
                Monto = 0.00m,
                DetalleAdicional = "Tipo: " + tipoConsulta + " | Resumen: " + mensajeTexto,
                FechaMovimiento = DateTime.Now
            };

            // 3. GENERACIÓN DEL COMPROBANTE PDF EN MEMORIA
            byte[] pdfBytes = ComprobanteServicioHelper.GenerarPdfComprobante(datos);

            // 4. ENVÍO AUTOMÁTICO AL CORREO ELECTRÓNICO REGISTRADO
            bool correoEnviado = ComprobanteServicioHelper.EnviarComprobantePorCorreo(datos, pdfBytes);

            // 5. RESPUESTA VISUAL EN PANTALLA
            pnlMensajeExito.Visible = true;
            if (correoEnviado)
            {
                pnlMensajeExito.CssClass = "mb-5 p-4 bg-emerald-500/10 border border-emerald-500/40 rounded-xl flex items-center gap-3 text-emerald-700 dark:text-emerald-300 text-xs sm:text-sm font-medium";
                litMensaje.Text = "<i class='fa-solid fa-circle-check text-lg text-emerald-600 dark:text-emerald-400 flex-shrink-0'></i>" +
                                  "<div><strong>¡Mensaje Enviado y Ticket PDF Generado!</strong> Se ha enviado el comprobante oficial N° <strong>" + datos.NumeroTransaccion + "</strong> a <strong>" + datos.CorreoCliente + "</strong>. Un asesor te contactará en menos de 4 horas hábiles.</div>";
            }
            else
            {
                pnlMensajeExito.CssClass = "mb-5 p-4 bg-amber-500/10 border border-amber-500/40 rounded-xl flex items-center gap-3 text-amber-700 dark:text-amber-300 text-xs sm:text-sm font-medium";
                litMensaje.Text = "<i class='fa-solid fa-circle-info text-lg text-amber-600 dark:text-amber-400 flex-shrink-0'></i>" +
                                  "<div><strong>¡Gracias por contactarnos!</strong> Tu mensaje ha sido registrado bajo el ticket N° <strong>" + datos.NumeroTransaccion + "</strong>. (Revisa la configuración SMTP en Web.config para la notificación automática por correo).</div>";
            }

            // Limpieza de campos post-envío
            txtMensaje.Text = string.Empty;
            txtTelefono.Text = string.Empty;
            ddlTipoConsulta.SelectedIndex = 0;

            // Mantenemos los datos personales si está en sesión
            if (string.IsNullOrEmpty(ObtenerNombreUsuarioSesion()))
            {
                txtNombre.Text = string.Empty;
                txtEmail.Text = string.Empty;
            }
        }

        private void MostrarMensaje(string texto, bool esExito)
        {
            pnlMensajeExito.Visible = true;
            pnlMensajeExito.CssClass = esExito
                ? "mb-5 p-4 bg-emerald-500/10 border border-emerald-500/40 rounded-xl flex items-center gap-3 text-emerald-700 dark:text-emerald-300 text-xs sm:text-sm font-bold"
                : "mb-5 p-4 bg-red-500/10 border border-red-500/40 rounded-xl flex items-center gap-3 text-red-700 dark:text-red-300 text-xs sm:text-sm font-bold";
            litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base flex-shrink-0'></i> " + texto;
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