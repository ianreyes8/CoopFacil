using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using CoopFacil.Helpers;

namespace CoopFacil.Pages
{
    public partial class CuentaAhorro : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ValidarAccesoYCuenta();
            }
        }

        private void ValidarAccesoYCuenta()
        {
            string nombreUsuario = Session["UsuarioNombre"] as string ?? Session["ClienteNombreCompleto"] as string;
            string correoUsuario = Session["UsuarioCorreo"] as string ?? Session["CorreoUsuario"] as string ?? Session["Correo"] as string;
            string duiCliente = Session["ClienteDUI"] as string ?? Session["UsuarioDUI"] as string;

            // 1. Validación de sesión activa en la cooperativa
            if (string.IsNullOrEmpty(nombreUsuario) && string.IsNullOrEmpty(correoUsuario) && string.IsNullOrEmpty(duiCliente))
            {
                Response.Redirect("../Default.aspx");
                return;
            }

            // 2. Vincular identificadores y consultar socio en el Repositorio Persistente
            RepositorioBanco.AsociarIdentificadores(duiCliente, correoUsuario, nombreUsuario);

            string claveBusqueda = !string.IsNullOrEmpty(correoUsuario) ? correoUsuario : duiCliente;
            var socio = RepositorioBanco.ObtenerOcrear(claveBusqueda, nombreUsuario);

            bool tieneCuenta = socio.TieneCuentaAhorro || (Session["TieneCuentaAhorro"] != null && (bool)Session["TieneCuentaAhorro"]);

            // 3. Si no ha aperturado cuenta -> Redirigir a RegistroCredito.aspx
            if (!tieneCuenta)
            {
                Response.Redirect("RegistroCredito.aspx");
                return;
            }

            // 4. Cargar la vista de Cuenta de Ahorro con desembolsos acumulados
            CargarDatosCuentaYCreditos(socio);
        }

        private void CargarDatosCuentaYCreditos(RegistroSocioData socio)
        {
            litNombreCliente.Text = socio.NombreCliente;
            litNumeroCuenta.Text = !string.IsNullOrEmpty(socio.NumeroCuenta) ? socio.NumeroCuenta : "CTA-7788-904128";

            pnlBienvenida.Visible = true;
            litBienvenida.Text = ExtraerPrimerNombreYPrimerApellido(socio.NombreCliente);
            lnkIniciarSesion.Visible = false;
            btnCerrarSesion.Visible = true;

            List<CreditoSolicitado> listaCreditos = socio.Creditos;

            if (listaCreditos != null && listaCreditos.Count > 0)
            {
                decimal totalDesembolsado = listaCreditos.Sum(c => c.Monto);
                litTotalDesembolsado.Text = "$" + totalDesembolsado.ToString("N2") + " USD";
                litCantidadCreditos.Text = listaCreditos.Count + " Crédito(s) Adquirido(s)";

                rptCreditos.DataSource = listaCreditos;
                rptCreditos.DataBind();
                pnlSinCreditos.Visible = false;
            }
            else
            {
                litTotalDesembolsado.Text = "$0.00 USD";
                litCantidadCreditos.Text = "0 Créditos";
                pnlSinCreditos.Visible = true;
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