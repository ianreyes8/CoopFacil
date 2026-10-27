using System;
using System.Web.UI;

namespace CoopFacil.Pages
{
    public partial class EducacionFinanciera : System.Web.UI.Page
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

            if (string.IsNullOrEmpty(txtNombreInscripcion.Text))
            {
                txtNombreInscripcion.Text = nombreUsuario;
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

        protected void btnInscribirseTaller_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombreInscripcion.Text) ||
                string.IsNullOrWhiteSpace(txtCorreoInscripcion.Text) ||
                string.IsNullOrWhiteSpace(txtTelefonoInscripcion.Text) ||
                string.IsNullOrEmpty(ddlTallerSeleccionado.SelectedValue))
            {
                pnlMensajeTaller.Visible = true;
                pnlMensajeTaller.CssClass = "mb-6 p-4 rounded-xl border border-red-500/50 bg-red-950/40 text-red-300 flex items-center gap-3 text-xs font-bold";
                litMensajeTaller.Text = "<i class='fa-solid fa-triangle-exclamation text-base'></i> Por favor, completa todos los campos para registrar tu inscripción al taller o webinar.";
                return;
            }

            pnlMensajeTaller.Visible = true;
            pnlMensajeTaller.CssClass = "mb-6 p-5 rounded-xl border border-amber-500/50 bg-amber-950/40 text-amber-300 flex flex-col gap-2 text-xs font-medium";
            litMensajeTaller.Text = "<div class='flex items-center gap-2 text-sm font-bold text-amber-400'>" +
                                    "<i class='fa-solid fa-circle-check text-lg'></i> ¡Inscripción Confirmada con Éxito!</div>" +
                                    "<p class='mt-1 text-slate-200'>Estimado/a <strong>" + txtNombreInscripcion.Text + "</strong>, tu cupo para el evento <strong>\"" + ddlTallerSeleccionado.SelectedItem.Text + "\"</strong> ha sido reservado correctamente.</p>" +
                                    "<p class='text-xs text-slate-300'>Enviamos el enlace de acceso al seminario y la guía previa a tu correo <strong>" + txtCorreoInscripcion.Text + "</strong> y recordatorio por SMS al <strong>" + txtTelefonoInscripcion.Text + "</strong>.</p>";

            txtTelefonoInscripcion.Text = "";
            txtCorreoInscripcion.Text = "";
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("../Default.aspx");
        }
    }
}