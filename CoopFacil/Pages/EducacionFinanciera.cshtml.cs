using System;
using CoopFacil.Compat;
using System.IO;
using System.Web.UI;
using CoopFacil.Helpers;

namespace CoopFacil.Pages
{
    public partial class EducacionFinanciera : PaginaWeb
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
            if (string.IsNullOrEmpty(txtNombreInscripcion.Text))
            {
                txtNombreInscripcion.Text = nombreUsuario;
            }

            string correoSesion = ObtenerCorreoUsuarioSesion();
            if (!string.IsNullOrEmpty(correoSesion) && string.IsNullOrEmpty(txtCorreoInscripcion.Text))
            {
                txtCorreoInscripcion.Text = correoSesion;
            }

            string telefonoSesion = ObtenerTelefonoUsuarioSesion();
            if (!string.IsNullOrEmpty(telefonoSesion) && string.IsNullOrEmpty(txtTelefonoInscripcion.Text))
            {
                txtTelefonoInscripcion.Text = telefonoSesion;
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

        protected void btnInscribirseTaller_Click(object sender, EventArgs e)
        {
            // 1. VALIDACIÓN DE CAMPOS DEL FORMULARIO
            if (string.IsNullOrWhiteSpace(txtNombreInscripcion.Text) ||
                string.IsNullOrWhiteSpace(txtCorreoInscripcion.Text) ||
                string.IsNullOrWhiteSpace(txtTelefonoInscripcion.Text) ||
                string.IsNullOrEmpty(ddlTallerSeleccionado.SelectedValue))
            {
                MostrarMensajeTaller("Por favor, completa todos los campos para registrar tu inscripción al taller o webinar.", false);
                return;
            }

            // DUI si existe en sesión activa o etiqueta informativa de taller gratuito
            string duiSesion = ObtenerDUIUsuarioSesion();
            string duiCliente = !string.IsNullOrEmpty(duiSesion) ? duiSesion : "N/A - Capacitación Gratuita";

            // 2. CONSTRUCCIÓN DEL MODELO DE DATOS EN MEMORIA
            DatosComprobante datos = new DatosComprobante
            {
                NumeroTransaccion = "EF-" + DateTime.Now.ToString("yyyyMMddHHmmss"),
                NombreCliente = txtNombreInscripcion.Text.Trim(),
                DUI = duiCliente,
                Telefono = txtTelefonoInscripcion.Text.Trim(),
                CorreoCliente = txtCorreoInscripcion.Text.Trim(),
                NombreServicio = "Inscripción a Taller / Webinar de Educación Financiera",
                Monto = 0.00m, // Capacitación 100% Gratuita
                DetalleAdicional = "Evento: " + ddlTallerSeleccionado.SelectedItem.Text + " | Acceso: Programa Gratuito CoopFácil",
                FechaMovimiento = DateTime.Now
            };

            // 3. GENERACIÓN DEL COMPROBANTE PDF EN MEMORIA
            byte[] pdfBytes = ComprobanteServicioHelper.GenerarPdfComprobante(datos);

            // 4. ENVÍO AUTOMÁTICO AL CORREO REGISTRADO
            bool correoEnviado = ComprobanteServicioHelper.EnviarComprobantePorCorreo(datos, pdfBytes);

            // 5. RESPUESTA VISUAL EN PANTALLA
            if (correoEnviado)
            {
                pnlMensajeTaller.Visible = true;
                pnlMensajeTaller.CssClass = "mb-6 p-5 rounded-xl border border-amber-500/50 bg-amber-100 dark:bg-amber-950/40 text-amber-900 dark:text-amber-300 text-xs font-medium";
                litMensajeTaller.Text = "<div class='flex items-center gap-2 text-sm font-bold text-amber-600 dark:text-amber-400'>" +
                                        "<i class='fa-solid fa-circle-check text-lg'></i> ¡Inscripción Confirmada y Comprobante PDF Enviado!</div>" +
                                        "<p class='mt-2 text-slate-700 dark:text-slate-200'>Estimado/a <strong>" + datos.NombreCliente + "</strong>, tu reservación para el evento <strong>\"" + ddlTallerSeleccionado.SelectedItem.Text + "\"</strong> fue registrada con la clave N° <strong>" + datos.NumeroTransaccion + "</strong>.</p>" +
                                        "<p class='text-xs text-slate-600 dark:text-slate-300 mt-1'>Hemos enviado tu comprobante de reservación en formato PDF a <strong>" + datos.CorreoCliente + "</strong> con el enlace de acceso.</p>";
            }
            else
            {
                pnlMensajeTaller.Visible = true;
                pnlMensajeTaller.CssClass = "mb-6 p-5 rounded-xl border border-amber-500/50 bg-amber-100 dark:bg-amber-950/40 text-amber-900 dark:text-amber-300 text-xs font-medium";
                litMensajeTaller.Text = "<div class='flex items-center gap-2 text-sm font-bold text-amber-600 dark:text-amber-400'>" +
                                        "<i class='fa-solid fa-circle-check text-lg'></i> ¡Inscripción Confirmada con Éxito!</div>" +
                                        "<p class='mt-1 text-slate-700 dark:text-slate-200'>Estimado/a <strong>" + datos.NombreCliente + "</strong>, tu cupo para el evento <strong>\"" + ddlTallerSeleccionado.SelectedItem.Text + "\"</strong> ha sido reservado (N° <strong>" + datos.NumeroTransaccion + "</strong>).</p>" +
                                        "<p class='text-xs text-slate-600 dark:text-slate-300 mt-1'>Tu inscripción quedó registrada correctamente, pero no pudimos enviar la confirmación a tu correo en este momento. Guarda tu número de transacción para cualquier consulta.</p>";
            }

            // Limpieza parcial de campo post-inscripción (únicamente sin sesión iniciada)
            if (string.IsNullOrEmpty(ObtenerNombreUsuarioSesion()))
            {
                txtTelefonoInscripcion.Text = "";
            }
        }

        private void MostrarMensajeTaller(string texto, bool esExito)
        {
            pnlMensajeTaller.Visible = true;
            pnlMensajeTaller.CssClass = esExito
                ? "mb-6 p-4 rounded-xl border border-amber-500/50 bg-amber-100 dark:bg-amber-950/40 text-amber-900 dark:text-amber-300 text-xs font-bold"
                : "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-100 dark:bg-red-950/40 text-red-800 dark:text-red-300 text-xs font-bold";
            litMensajeTaller.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> " + texto;
        }

        // DESCARGA PLANTILLA EXCEL (DESDE ~/Downloads/)
        protected void btnDescargarExcel_Click(object sender, EventArgs e)
        {
            DescargarArchivoServidor("Plantilla_Presupuesto_CoopFacil.xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        }

        // DESCARGA GUÍA DE AHORRO PDF (DESDE ~/Downloads/)
        protected void btnDescargarGuiaPDF_Click(object sender, EventArgs e)
        {
            DescargarArchivoServidor("Guia_Practica_Ahorro_e_Inversion.pdf", "application/pdf");
        }

        // DESCARGA MANUAL DE DEUDAS PDF (DESDE ~/Downloads/)
        protected void btnDescargarManualPDF_Click(object sender, EventArgs e)
        {
            DescargarArchivoServidor("Manual_Saneamiento_Gestion_Deudas.pdf", "application/pdf");
        }

        private void DescargarArchivoServidor(string nombreArchivo, string contentType)
        {
            string rutaArchivo = Server.MapPath("~/Downloads/" + nombreArchivo);

            if (System.IO.File.Exists(rutaArchivo))
            {
                Response.Clear();
                Response.ContentType = contentType;
                Response.AddHeader("Content-Disposition", "attachment; filename=" + nombreArchivo);
                Response.TransmitFile(rutaArchivo);
                Response.End();
            }
            else
            {
                MostrarMensajeTaller("El archivo (" + nombreArchivo + ") debe ubicarse en la carpeta ~/Downloads/ en la raíz del servidor.", false);
            }
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