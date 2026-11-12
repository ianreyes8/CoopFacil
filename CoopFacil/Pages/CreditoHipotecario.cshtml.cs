using System;
using CoopFacil.Compat;
using System.Web.UI;
using CoopFacil.Helpers;

namespace CoopFacil.Pages
{
    public partial class CreditoHipotecario : PaginaWeb
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                VerificarSesion();
                txtFechaCita.Attributes["min"] = DateTime.Now.ToString("yyyy-MM-dd");
                txtFechaCita.Text = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
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

        protected void btnAgendarCita_Click(object sender, EventArgs e)
        {
            // 1. VALIDACIÓN DE DATOS DEL FORMULARIO
            if (string.IsNullOrWhiteSpace(txtNombre.Text) ||
                string.IsNullOrWhiteSpace(txtDUI.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) ||
                string.IsNullOrWhiteSpace(txtCorreo.Text) ||
                string.IsNullOrWhiteSpace(txtFechaCita.Text) ||
                string.IsNullOrEmpty(ddlHoraCita.SelectedValue) ||
                string.IsNullOrEmpty(ddlModalidad.SelectedValue))
            {
                MostrarMensaje("Por favor, completa todos los campos requeridos para agendar tu cita.", false);
                return;
            }

            DateTime fechaSeleccionada;
            if (!DateTime.TryParse(txtFechaCita.Text, out fechaSeleccionada) || fechaSeleccionada.Date < DateTime.Now.Date)
            {
                MostrarMensaje("Por favor, selecciona una fecha válida a partir del día de hoy.", false);
                return;
            }

            string modalidadTexto = ddlModalidad.SelectedValue == "Presencial" ?
                "Presencial en " + ddlAgencia.SelectedValue :
                "Videollamada en línea (Enlace enviado al correo)";

            // 2. CONSTRUCCIÓN DEL MODELO DE DATOS EN MEMORIA
            DatosComprobante datos = new DatosComprobante
            {
                NumeroTransaccion = "CH-" + DateTime.Now.ToString("yyyyMMddHHmmss"),
                NombreCliente = txtNombre.Text.Trim(),
                DUI = txtDUI.Text.Trim(),
                Telefono = txtTelefono.Text.Trim(),
                CorreoCliente = txtCorreo.Text.Trim(),
                NombreServicio = "Agendamiento Cita Crédito Hipotecario",
                Monto = 0.00m,
                DetalleAdicional = "Fecha: " + fechaSeleccionada.ToString("dd/MM/yyyy") + " | Hora: " + ddlHoraCita.SelectedValue + " | Modalidad: " + modalidadTexto,
                FechaMovimiento = DateTime.Now
            };

            // 3. GENERACIÓN DEL COMPROBANTE PDF EN MEMORIA
            byte[] pdfBytes = ComprobanteServicioHelper.GenerarPdfComprobante(datos);

            // 4. ENVÍO AUTOMÁTICO AL CORREO REGISTRADO
            bool correoEnviado = ComprobanteServicioHelper.EnviarComprobantePorCorreo(datos, pdfBytes);

            // 5. RESPUESTA VISUAL EN PANTALLA
            if (correoEnviado)
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-emerald-500/50 bg-emerald-100 dark:bg-emerald-950/40 text-emerald-900 dark:text-emerald-300 text-xs font-medium";
                litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-emerald-600 dark:text-emerald-400'>" +
                                  "<i class='fa-solid fa-circle-check text-lg'></i> ¡Cita Especializada Agendada y Comprobante PDF Enviado!</div>" +
                                  "<p class='mt-2 text-slate-700 dark:text-slate-200'>Estimado/a <strong>" + datos.NombreCliente + "</strong>, tu cita para Crédito Hipotecario fue agendada exitosamente bajo la reserva N° <strong>" + datos.NumeroTransaccion + "</strong>.</p>" +
                                  "<p class='text-xs text-slate-600 dark:text-slate-300 mt-1'><strong>Fecha:</strong> " + fechaSeleccionada.ToString("dd/MM/yyyy") + " a las " + ddlHoraCita.SelectedValue + " (" + modalidadTexto + "). Se ha enviado el comprobante oficial en PDF a <strong>" + datos.CorreoCliente + "</strong>.</p>";
            }
            else
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-amber-500/50 bg-amber-100 dark:bg-amber-950/40 text-amber-900 dark:text-amber-300 text-xs font-medium";
                litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-amber-600 dark:text-amber-400'>" +
                                  "<i class='fa-solid fa-circle-check text-lg'></i> ¡Cita Agendada Exitosamente!</div>" +
                                  "<p class='mt-1 text-slate-700 dark:text-slate-200'>Estimado/a <strong>" + datos.NombreCliente + "</strong>, se registró tu reserva N° <strong>" + datos.NumeroTransaccion + "</strong> para el <strong>" + fechaSeleccionada.ToString("dd/MM/yyyy") + "</strong> a las <strong>" + ddlHoraCita.SelectedValue + "</strong> (" + modalidadTexto + ").</p>" +
                                  "<p class='text-xs text-slate-600 dark:text-slate-300 mt-1'>Tu solicitud quedó registrada correctamente, pero no pudimos enviar el comprobante a tu correo en este momento. Guarda tu número de transacción; si necesitas el comprobante, contáctanos.</p>";
            }

            // Limpieza de campos post-agendamiento
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