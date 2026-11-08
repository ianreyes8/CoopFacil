using System;
using System.Web.UI;
using CoopFacil.Helpers;

namespace CoopFacil.Pages
{
    public partial class Servicios : Page
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

            if (!string.IsNullOrEmpty(nombreUsuario))
            {
                pnlBienvenida.Visible = true;
                litBienvenida.Text = ExtraerPrimerNombreYPrimerApellido(nombreUsuario);
                lnkIniciarSesion.Visible = false;
                btnCerrarSesion.Visible = true;
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

        protected void btnVerCuentaAhorro_Click(object sender, EventArgs e)
        {
            string duiCliente = Session["ClienteDUI"] as string ?? Session["UsuarioDUI"] as string;
            string nombreUsuario = ObtenerNombreUsuarioSesion();

            // 1. Si NO tiene sesión iniciada con la cooperativa -> Redirigir a Default.aspx (Login)
            if (string.IsNullOrEmpty(duiCliente) && string.IsNullOrEmpty(nombreUsuario))
            {
                Response.Redirect("../Default.aspx");
                return;
            }

            // 2. Si TIENE sesión iniciada -> Consultar si ya aperturó cuenta de ahorro en Repositorio Persistente
            var socio = RepositorioBanco.ObtenerOcrear(duiCliente, nombreUsuario);
            bool tieneCuenta = socio.TieneCuentaAhorro || (Session["TieneCuentaAhorro"] != null && (bool)Session["TieneCuentaAhorro"]);

            if (tieneCuenta)
            {
                // Ya aperturó cuenta -> Pasa directo a CuentaAhorro.aspx
                Response.Redirect("CuentaAhorro.aspx");
            }
            else
            {
                // No ha aperturado cuenta -> Redirige por primera y única vez a RegistroCredito.aspx
                Response.Redirect("RegistroCredito.aspx");
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
            return $"{partes[0]} {partes[partes.Length - 1]}";
        }
    }
}