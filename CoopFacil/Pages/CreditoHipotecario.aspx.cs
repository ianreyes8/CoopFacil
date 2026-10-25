using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CoopFacil.Pages
{
    public partial class CreditoHipotecario : System.Web.UI.Page
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

            // 1. Redirigir si no hay sesión activa
            if (string.IsNullOrEmpty(nombreUsuario))
            {
                Response.Redirect("../Default.aspx");
                return;
            }

            // 2. Mostrar la barra de navegación personalizada si la sesión es válida
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

        protected void btnAgendarCita_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombre.Text) || string.IsNullOrWhiteSpace(txtDUI.Text) ||
                string.IsNullOrWhiteSpace(txtTelefono.Text) || string.IsNullOrWhiteSpace(txtCorreo.Text) ||
                string.IsNullOrWhiteSpace(txtFechaCita.Text) || string.IsNullOrEmpty(ddlHoraCita.SelectedValue) ||
                string.IsNullOrEmpty(ddlModalidad.SelectedValue))
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> Por favor, completa todos los campos para agendar tu cita con el asesor especializado.";
                return;
            }

            DateTime fechaSeleccionada;
            if (!DateTime.TryParse(txtFechaCita.Text, out fechaSeleccionada) || fechaSeleccionada.Date < DateTime.Now.Date)
            {
                pnlMensaje.Visible = true;
                pnlMensaje.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensaje.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> Por favor, selecciona una fecha válida a partir del día de hoy.";
                return;
            }

            string modalidadTexto = ddlModalidad.SelectedValue == "Presencial" ?
                "Presencial en " + ddlAgencia.SelectedValue :
                "Videollamada en línea (Enlace enviado a su correo)";

            pnlMensaje.Visible = true;
            pnlMensaje.CssClass = "mb-6 p-5 rounded-xl border border-emerald-500/50 bg-emerald-950/40 text-emerald-300 flex flex-col gap-2 text-xs font-medium";
            litMensaje.Text = "<div class='flex items-center gap-2 text-sm font-bold text-emerald-400'>" +
                              "<i class='fa-solid fa-circle-check text-lg'></i> ¡Cita Especializada Agendada con Éxito!</div>" +
                              "<p class='mt-1 text-slate-200'>Estimado/a <strong>" + txtNombre.Text + "</strong>, tu cita para Crédito Hipotecario ha sido programada para el <strong>" + fechaSeleccionada.ToString("dd/MM/yyyy") + "</strong> a las <strong>" + ddlHoraCita.SelectedValue + "</strong> en modalidad <strong>" + modalidadTexto + "</strong>.</p>" +
                              "<p class='text-xs text-slate-300'>Hemos enviado la confirmación y el recordatorio a tu correo <strong>" + txtCorreo.Text + "</strong> o vía SMS al <strong>" + txtTelefono.Text + "</strong>.</p>";

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