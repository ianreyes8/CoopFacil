using System;
using System.Web.UI;
using CoopFacil.Helpers;

namespace CoopFacil.Pages
{
    public partial class RegistroCredito : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarDatosPrevios();
            }
        }

        private void CargarDatosPrevios()
        {
            string duiSesion = Session["ClienteDUI"] as string ?? Session["UsuarioDUI"] as string;
            if (!string.IsNullOrEmpty(duiSesion) && string.IsNullOrEmpty(txtDUI.Text))
            {
                txtDUI.Text = duiSesion;
            }

            string nombreSesion = Session["ClienteNombreCompleto"] as string ?? Session["UsuarioNombre"] as string;
            if (!string.IsNullOrEmpty(nombreSesion))
            {
                string[] partes = nombreSesion.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                if (partes.Length >= 2 && string.IsNullOrEmpty(txtNombres.Text))
                {
                    txtNombres.Text = partes[0];
                    txtApellidos.Text = partes[partes.Length - 1];
                }
                else if (string.IsNullOrEmpty(txtNombres.Text))
                {
                    txtNombres.Text = nombreSesion;
                }
            }
        }

        protected void btnCrearCuenta_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombres.Text) ||
                string.IsNullOrWhiteSpace(txtApellidos.Text) ||
                string.IsNullOrWhiteSpace(txtDUI.Text) ||
                string.IsNullOrWhiteSpace(txtFechaNacimiento.Text))
            {
                pnlError.Visible = true;
                litError.Text = "Por favor, completa todos los campos requeridos.";
                return;
            }

            string nombreCompleto = $"{txtNombres.Text.Trim()} {txtApellidos.Text.Trim()}";
            string dui = txtDUI.Text.Trim();

            // 1. Generar número de cuenta único
            Random random = new Random();
            string numeroCuenta = "CTA-7788-" + random.Next(100000, 999999).ToString();

            // 2. Registrar apertura en el Repositorio Persistente
            RepositorioBanco.RegistrarCuentaAhorro(dui, numeroCuenta);
            var socio = RepositorioBanco.ObtenerOcrear(dui, nombreCompleto);

            // 3. Sincronizar Variables de Sesión con estado activo de cuenta
            Session["ClienteNombreCompleto"] = nombreCompleto;
            Session["ClienteDUI"] = dui;
            Session["UsuarioNombre"] = nombreCompleto;
            Session["UsuarioDUI"] = dui;
            Session["NumeroCuentaAhorro"] = numeroCuenta;
            Session["TieneCuentaAhorro"] = true;
            Session["ListaCreditos"] = socio.Creditos;

            // 4. Redirigir a la vista de Cuenta de Ahorro
            Response.Redirect("CuentaAhorro.aspx");
        }
    }
}