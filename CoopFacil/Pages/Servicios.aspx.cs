using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using CoopFacil.Helpers;

namespace CoopFacil.Pages
{
    public partial class Servicios : Page
    {
        private string conexionStr = ConfigurationManager.ConnectionStrings["CoopFacilDB"]?.ConnectionString;

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

        protected void btnVerCuentaAhorro_Click(object sender, EventArgs e)
        {
            string duiCliente = Session["ClienteDUI"] as string ?? Session["UsuarioDUI"] as string;
            string correoCliente = ObtenerCorreoUsuarioSesion();
            string nombreUsuario = ObtenerNombreUsuarioSesion();

            // 1. Si NO tiene sesión iniciada con la cooperativa -> Redirigir a Default.aspx (Login)
            if (string.IsNullOrEmpty(duiCliente) && string.IsNullOrEmpty(correoCliente) && string.IsNullOrEmpty(nombreUsuario))
            {
                Response.Redirect("../Default.aspx");
                return;
            }

            // 2. Verificar estado en Sesión o Repositorio en memoria
            bool tieneCuenta = Session["TieneCuentaAhorro"] != null && (bool)Session["TieneCuentaAhorro"];

            string identificador = !string.IsNullOrEmpty(duiCliente) && !duiCliente.Contains("@") ? duiCliente : correoCliente;
            var socio = RepositorioBanco.ObtenerOcrear(identificador, nombreUsuario);

            if (socio != null && socio.TieneCuentaAhorro)
            {
                tieneCuenta = true;
            }

            // 3. Consultar a la base de datos SQL Server si el estado aún no está cargado en memoria RAM
            if (!tieneCuenta && !string.IsNullOrEmpty(conexionStr) && !string.IsNullOrEmpty(correoCliente))
            {
                using (SqlConnection con = new SqlConnection(conexionStr))
                {
                    string query = @"SELECT TieneCuentaAhorro, NumeroCuenta, DUI FROM Usuarios WHERE Email = @Email OR (DUI = @DUI AND NULLIF(@DUI, '') IS NOT NULL)";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Email", correoCliente ?? "");
                    cmd.Parameters.AddWithValue("@DUI", duiCliente ?? "");

                    try
                    {
                        con.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                bool tieneCuentaBD = reader["TieneCuentaAhorro"] != DBNull.Value && Convert.ToBoolean(reader["TieneCuentaAhorro"]);
                                if (tieneCuentaBD)
                                {
                                    tieneCuenta = true;
                                    socio.TieneCuentaAhorro = true;
                                    string numCuentaBD = reader["NumeroCuenta"] != DBNull.Value ? reader["NumeroCuenta"].ToString() : "";
                                    if (!string.IsNullOrEmpty(numCuentaBD))
                                    {
                                        socio.NumeroCuenta = numCuentaBD;
                                        Session["NumeroCuentaAhorro"] = numCuentaBD;
                                    }
                                    Session["TieneCuentaAhorro"] = true;
                                }
                            }
                        }
                    }
                    catch { }
                }
            }

            if (tieneCuenta)
            {
                // Ya aperturó cuenta -> Pasa directo a CuentaAhorro.aspx
                Response.Redirect("CuentaAhorro.aspx");
            }
            else
            {
                // No ha aperturado cuenta -> Redirige por primera vez a RegistroCredito.aspx
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