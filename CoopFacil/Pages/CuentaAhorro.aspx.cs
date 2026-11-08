using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using CoopFacil.Helpers;

namespace CoopFacil.Pages
{
    public partial class CuentaAhorro : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                VerificarSesionYCargarDatos();
            }
        }

        private void VerificarSesionYCargarDatos()
        {
            string nombreUsuario = ObtenerNombreUsuarioSesion();
            string correoUsuario = ObtenerCorreoUsuarioSesion();
            string duiSesion = ObtenerDUIUsuarioSesion();

            if (!string.IsNullOrEmpty(nombreUsuario))
            {
                pnlBienvenida.Visible = true;
                litBienvenida.Text = ExtraerPrimerNombreYPrimerApellido(nombreUsuario);
                litTitularCuenta.Text = nombreUsuario;
                lnkIniciarSesion.Visible = false;
                btnCerrarSesion.Visible = true;
            }

            string identificador = !string.IsNullOrEmpty(duiSesion) ? duiSesion : correoUsuario;
            var socio = RepositorioBanco.ObtenerOcrear(identificador, nombreUsuario);

            socio.TieneCuentaAhorro = true;
            Session["TieneCuentaAhorro"] = true;

            string numeroCuenta = CleanTo12Digits(socio.NumeroCuenta);

            if (string.IsNullOrEmpty(numeroCuenta) && Session["NumeroCuentaAhorro"] != null)
            {
                numeroCuenta = CleanTo12Digits(Session["NumeroCuentaAhorro"].ToString());
            }

            if (string.IsNullOrEmpty(numeroCuenta) || numeroCuenta.Length != 12)
            {
                numeroCuenta = GenerarNumeroCuenta12Digitos(duiSesion);
                socio.NumeroCuenta = numeroCuenta;
                Session["NumeroCuentaAhorro"] = numeroCuenta;
            }

            litNumeroCuenta.Text = numeroCuenta;

            decimal saldoTotal = 0m;
            List<CreditoSolicitado> listaCreditos = socio.Creditos;

            if (listaCreditos != null && listaCreditos.Count > 0)
            {
                litCantidadCreditos.Text = $"{listaCreditos.Count} Crédito(s)";
                tblCreditos.Controls.Clear();

                foreach (var cred in listaCreditos)
                {
                    saldoTotal += cred.Monto;

                    HtmlTableRow row = new HtmlTableRow();

                    HtmlTableCell cellTx = new HtmlTableCell { InnerText = cred.NumeroTransaccion };
                    cellTx.Attributes["class"] = "p-4 font-bold text-blue-600 dark:text-blue-400";

                    HtmlTableCell cellTipo = new HtmlTableCell { InnerText = cred.TipoCredito };
                    cellTipo.Attributes["class"] = "p-4 font-semibold";

                    HtmlTableCell cellMonto = new HtmlTableCell { InnerText = $"${cred.Monto:N2}" };
                    cellMonto.Attributes["class"] = "p-4 font-extrabold text-emerald-600 dark:text-emerald-400";

                    HtmlTableCell cellPlazo = new HtmlTableCell { InnerText = $"{cred.PlazoMeses} meses" };
                    cellPlazo.Attributes["class"] = "p-4";

                    HtmlTableCell cellCuota = new HtmlTableCell { InnerText = $"${cred.CuotaMensual:N2}" };
                    cellCuota.Attributes["class"] = "p-4 font-bold";

                    HtmlTableCell cellFecha = new HtmlTableCell { InnerText = cred.FechaMovimiento.ToString("dd/MM/yyyy HH:mm") };
                    cellFecha.Attributes["class"] = "p-4 text-slate-500 dark:text-slate-400";

                    row.Controls.Add(cellTx);
                    row.Controls.Add(cellTipo);
                    row.Controls.Add(cellMonto);
                    row.Controls.Add(cellPlazo);
                    row.Controls.Add(cellCuota);
                    row.Controls.Add(cellFecha);

                    tblCreditos.Controls.Add(row);
                }
            }
            else
            {
                litCantidadCreditos.Text = "0 Créditos";
                tblCreditos.InnerHtml = "<tr><td colspan='6' class='p-6 text-center text-slate-400 italic'>No posee créditos registrados ni desembolsos acumulados aún.</td></tr>";
            }

            litSaldoDisponible.Text = saldoTotal.ToString("N2");
        }

        private string CleanTo12Digits(string raw)
        {
            if (string.IsNullOrWhiteSpace(raw)) return "";
            string soloNumeros = Regex.Replace(raw, @"\D", "");
            if (soloNumeros.Length >= 12)
            {
                return soloNumeros.Substring(soloNumeros.Length - 12);
            }
            return soloNumeros.PadLeft(12, '0');
        }

        private string GenerarNumeroCuenta12Digitos(string dui)
        {
            if (!string.IsNullOrEmpty(dui))
            {
                string duiLimpio = Regex.Replace(dui, @"\D", "");
                if (duiLimpio.Length > 0)
                {
                    return ("100" + duiLimpio).PadRight(12, '0').Substring(0, 12);
                }
            }
            Random rnd = new Random();
            return "100" + rnd.Next(100000000, 999999999).ToString();
        }

        private string ObtenerNombreUsuarioSesion()
        {
            string[] claves = new string[] { "ClienteNombreCompleto", "UsuarioNombre", "NombreUsuario", "NombreCompleto", "Usuario" };
            foreach (string clave in claves)
            {
                if (Session[clave] != null && !string.IsNullOrWhiteSpace(Session[clave].ToString()))
                    return Session[clave].ToString().Trim();
            }
            return null;
        }

        private string ObtenerCorreoUsuarioSesion()
        {
            string[] clavesCorreo = new string[] { "UsuarioCorreo", "CorreoUsuario", "Correo", "Email" };
            foreach (string clave in clavesCorreo)
            {
                if (Session[clave] != null && Session[clave].ToString().Contains("@"))
                    return Session[clave].ToString().Trim();
            }
            return null;
        }

        private string ObtenerDUIUsuarioSesion()
        {
            string[] claves = new string[] { "ClienteDUI", "UsuarioDUI", "DUI" };
            foreach (string clave in claves)
            {
                if (Session[clave] != null && !Session[clave].ToString().Contains("@"))
                    return Session[clave].ToString().Trim();
            }
            return null;
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