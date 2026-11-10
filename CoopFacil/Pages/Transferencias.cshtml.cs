using System;
using System.Collections.Generic;
using System.Globalization;
using CoopFacil.Compat;
using CoopFacil.Helpers;

namespace CoopFacil.Pages
{
    public partial class Transferencias : PaginaWeb
    {
        public BancoDatos.PerfilCuenta Perfil { get; private set; }
        public List<BancoDatos.MovimientoCuenta> Movimientos { get; private set; } = new List<BancoDatos.MovimientoCuenta>();
        public string MensajeTexto { get; private set; } = "";
        public bool MensajeExito { get; private set; }
        public string SeccionMensaje { get; private set; } = "";

        private int IdSesion => Session["IdUsuario"] != null ? Convert.ToInt32(Session["IdUsuario"]) : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IdSesion == 0)
            {
                // Esta sección requiere una sesión iniciada.
                Response.Redirect("../Default.aspx");
                return;
            }

            if (!IsPostBack) CargarVista();
        }

        private void CargarVista()
        {
            try
            {
                Perfil = BancoDatos.ObtenerPerfil(IdSesion);
                Movimientos = BancoDatos.ObtenerMovimientos(IdSesion);
            }
            catch (Exception)
            {
                Perfil = null;
                MensajeTexto = "No se pudo consultar tu cuenta en este momento. Intenta de nuevo.";
                MensajeExito = false;
            }

            if (Perfil == null)
            {
                // La cuenta ya no existe (por ejemplo, se reinició la base de datos): se cierra la sesión.
                Session.Clear();
                Response.Redirect("../Default.aspx");
                return;
            }

            pnlBienvenida.Visible = true;
            litBienvenida.Text = Perfil.Nombre;
            lnkIniciarSesion.Visible = false;
            btnCerrarSesion.Visible = true;
            Session["Saldo"] = Perfil.Saldo;
            Session["NumeroCuentaAhorro"] = Perfil.NumeroCuenta;
        }

        private static bool TryParseMonto(string texto, out decimal monto)
        {
            return decimal.TryParse((texto ?? "").Trim().Replace("$", ""), NumberStyles.Number, CultureInfo.InvariantCulture, out monto);
        }

        protected void btnTransferir_Click(object sender, EventArgs e)
        {
            SeccionMensaje = "transferir";
            if (!TryParseMonto(txtMonto.Text, out decimal monto))
            {
                MensajeTexto = "Ingresa un monto válido, por ejemplo 25.50.";
            }
            else
            {
                try
                {
                    var r = BancoDatos.Transferir(IdSesion, txtDestino.Text, monto, txtConcepto.Text);
                    MensajeTexto = r.Exito ? r.Mensaje + " Referencia: " + r.Referencia : r.Mensaje;
                    MensajeExito = r.Exito;
                    if (r.Exito)
                    {
                        txtDestino.Text = "";
                        txtMonto.Text = "";
                        txtConcepto.Text = "";
                    }
                }
                catch (Exception)
                {
                    MensajeTexto = "No se pudo completar la transferencia. No se movió dinero; intenta de nuevo.";
                }
            }
            CargarVista();
        }

        protected void btnDepositar_Click(object sender, EventArgs e)
        {
            SeccionMensaje = "depositar";
            if (!TryParseMonto(txtMontoDeposito.Text, out decimal monto))
            {
                MensajeTexto = "Ingresa un monto válido, por ejemplo 100.";
            }
            else
            {
                try
                {
                    var r = BancoDatos.Depositar(IdSesion, monto);
                    MensajeTexto = r.Mensaje;
                    MensajeExito = r.Exito;
                    if (r.Exito) txtMontoDeposito.Text = "";
                }
                catch (Exception)
                {
                    MensajeTexto = "No se pudo completar el depósito. Intenta de nuevo.";
                }
            }
            CargarVista();
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("../Default.aspx");
        }
    }
}
