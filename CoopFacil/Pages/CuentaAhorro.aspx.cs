using System;
using System.Web.UI;
using CoopFacil.Helpers;

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
            litBienvenida.Text = ExtraerPrimerNombreYPrimerApellido(nombreUsuario);
            lnkIniciarSesion.Visible = false;
            btnCerrarSesion.Visible = true;

            // Precargar datos si existen en la sesión activa
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

        protected void btnEnviarPreApertura_Click(object sender, EventArgs e)
        {
            // 1. VALIDACIÓN DE CAMPOS
            if (string.IsNullOrWhiteSpace(txtNombre.Text) ||
                string.IsNullOrWhiteSpace(txtDUI.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) ||
                string.IsNullOrWhiteSpace(txtCorreo.Text) ||
                string.IsNullOrEmpty(ddlAgencia.SelectedValue))
            {
                MostrarMensaje("Por favor, completa todos los campos para procesar tu solicitud de pre-apertura.", false);
                return;
            }

            // 2. CONSTRUCCIÓN DEL MODELO DE DATOS EN MEMORIA
            DatosComprobante datos = new DatosComprobante
            {
                NumeroTransaccion = "CA-" + DateTime.Now.ToString("yyyyMMddHHmmss"),
                NombreCliente = txtNombre.Text.Trim(),
                DUI = txtDUI.Text.Trim(),
                Telefono = txtTelefono.Text.Trim(),
                CorreoCliente = txtCorreo.Text.Trim(),
                NombreServicio = "Pre-Apertura de Cuenta de Ahorro",
                Monto = 5.00m, // Monto mínimo oficial de apertura
                DetalleAdicional = "Agencia Asignada: " + ddlAgencia.SelectedValue + " | Tasa Preferencial: 10.0% ANUAL",
                FechaMovimiento = DateTime.Now
            };

            // 3. GENERACIÓN DEL COMPROBANTE PDF EN MEMORIA
            byte[] pdfBytes = ComprobanteServicioHelper.GenerarPdfComprobante(datos);

            // 4. ENVÍO AUTOMÁTICO AL CORREO
            bool correoEnviado = ComprobanteServicioHelper.EnviarComprobantePorCorreo(datos, pdfBytes);

            // 5. RESPUESTA VISUAL EN PANTALLA
            if (correoEnviado)
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-emerald-500/50 bg-emerald-100 dark:bg-emerald-950/40 text-emerald-900 dark:text-emerald-300 text-xs font-medium";
                litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-emerald-600 dark:text-emerald-400'>" +
                                  "<i class='fa-solid fa-circle-check text-lg'></i> ¡Solicitud de Pre-Apertura Enviada y Comprobante PDF Emitido!</div>" +
                                  "<p class='mt-2 text-slate-700 dark:text-slate-200'>Estimado/a <strong>" + datos.NombreCliente + "</strong>, tu pre-apertura fue registrada exitosamente con el comprobante N° <strong>" + datos.NumeroTransaccion + "</strong>.</p>" +
                                  "<p class='text-xs text-slate-600 dark:text-slate-300 mt-1'>Puedes presentar este comprobante en la <strong>" + ddlAgencia.SelectedValue + "</strong> al momento de retirar tu tarjeta de débito. Copia adjunta enviada a <strong>" + datos.CorreoCliente + "</strong>.</p>";
            }
            else
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-amber-500/50 bg-amber-100 dark:bg-amber-950/40 text-amber-900 dark:text-amber-300 text-xs font-medium";
                litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-amber-600 dark:text-amber-400'>" +
                                  "<i class='fa-solid fa-circle-check text-lg'></i> ¡Pre-Apertura Registrada con Éxito!</div>" +
                                  "<p class='mt-1 text-slate-700 dark:text-slate-200'>Estimado/a <strong>" + datos.NombreCliente + "</strong>, se registró tu trámite N° <strong>" + datos.NumeroTransaccion + "</strong> para retirar tarjeta en <strong>" + ddlAgencia.SelectedValue + "</strong>.</p>" +
                                  "<p class='text-xs text-slate-600 dark:text-slate-300 mt-1'>Revisa la configuración SMTP en tu Web.config para habilitar la entrega de notificaciones por correo.</p>";
            }

            // Limpieza de campos post-solicitud (únicamente si no hay sesión iniciada)
            if (string.IsNullOrEmpty(ObtenerNombreUsuarioSesion()))
            {
                txtDUI.Text = "";
                txtTelefono.Text = "";
            }
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