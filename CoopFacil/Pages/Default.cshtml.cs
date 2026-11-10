using System;
using CoopFacil.Compat;
using System.Configuration;
using MySqlConnector;
using System.Web.UI;
using CoopFacil.Helpers;

namespace CoopFacil
{
    public partial class Default : PaginaWeb
    {
        private string conexionStr = ConfigurationManager.ConnectionStrings["CoopFacilDB"]?.ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlMensaje.Visible = false;

                if (Session["IdUsuario"] != null || Session["NombreCompleto"] != null)
                {
                    Response.Redirect("Index.aspx");
                    return;
                }

                CargarContadorSocios();
            }
        }

        private void CargarContadorSocios()
        {
            if (string.IsNullOrEmpty(conexionStr))
            {
                lblSocios.Text = "1,250+";
                return;
            }

            using (MySqlConnection con = new MySqlConnection(conexionStr))
            {
                string query = "SELECT COUNT(*) FROM Usuarios";
                MySqlCommand cmd = new MySqlCommand(query, con);

                try
                {
                    con.Open();
                    int totalSocios = Convert.ToInt32(cmd.ExecuteScalar());
                    lblSocios.Text = totalSocios > 0 ? totalSocios.ToString("N0") : "1,250+";
                }
                catch
                {
                    lblSocios.Text = "1,250+";
                }
            }
        }

        protected void btnAcceder_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                MostrarError("Por favor, ingresa tu correo electrónico y contraseña.");
                return;
            }

            if (!email.Contains("@") || !email.Contains("."))
            {
                MostrarError("El correo electrónico debe ser válido y contener el símbolo '@'.");
                return;
            }

            if (password.Length < 8)
            {
                MostrarError("La contraseña debe tener un mínimo de 8 caracteres.");
                return;
            }

            if (string.IsNullOrEmpty(conexionStr))
            {
                MostrarError("No se encontró la cadena de conexión 'CoopFacilDB' en el Web.config.");
                return;
            }

            using (MySqlConnection con = new MySqlConnection(conexionStr))
            {
                string query = @"SELECT * FROM Usuarios WHERE Email = @Email";

                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);

                try
                {
                    con.Open();
                    using (MySqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string dbPassword = reader["Password"].ToString();

                            if (PasswordHasher.Verificar(password, dbPassword))
                            {
                                int idUsuario = Convert.ToInt32(reader["IdUsuario"]);
                                string nombreCompleto = reader["NombreCompleto"].ToString();
                                string correo = reader["Email"].ToString();
                                string numeroSocio = reader["NumeroSocio"] != DBNull.Value ? reader["NumeroSocio"].ToString() : "";
                                decimal saldo = reader["Saldo"] != DBNull.Value ? Convert.ToDecimal(reader["Saldo"]) : 0.00m;
                                decimal cdt = reader["CDT"] != DBNull.Value ? Convert.ToDecimal(reader["CDT"]) : 0.00m;
                                decimal prestamo = reader["Prestamo"] != DBNull.Value ? Convert.ToDecimal(reader["Prestamo"]) : 0.00m;

                                string dui = EsColumnaExistente(reader, "DUI") && reader["DUI"] != DBNull.Value ? reader["DUI"].ToString() : "";
                                string telefono = EsColumnaExistente(reader, "Telefono") && reader["Telefono"] != DBNull.Value ? reader["Telefono"].ToString() : "";
                                bool tieneCuentaBD = EsColumnaExistente(reader, "TieneCuentaAhorro") && reader["TieneCuentaAhorro"] != DBNull.Value && Convert.ToBoolean(reader["TieneCuentaAhorro"]);
                                string numCuentaBD = EsColumnaExistente(reader, "NumeroCuenta") && reader["NumeroCuenta"] != DBNull.Value ? reader["NumeroCuenta"].ToString() : "";

                                string identificadorSocio = !string.IsNullOrWhiteSpace(dui) && !dui.Contains("@") ? dui : correo;

                                // Restaurar socio en el Repositorio de Memoria
                                RepositorioBanco.AsociarIdentificadores(dui, correo, nombreCompleto);
                                var socioData = RepositorioBanco.ObtenerOcrear(identificadorSocio, nombreCompleto);

                                if (tieneCuentaBD)
                                {
                                    socioData.TieneCuentaAhorro = true;
                                    if (!string.IsNullOrEmpty(numCuentaBD))
                                    {
                                        socioData.NumeroCuenta = numCuentaBD;
                                    }
                                }

                                // Cargar variables de Sesión
                                Session["IdUsuario"] = idUsuario;
                                Session["NombreCompleto"] = nombreCompleto;
                                Session["ClienteNombreCompleto"] = nombreCompleto;
                                Session["UsuarioNombre"] = nombreCompleto;
                                Session["NombreUsuario"] = nombreCompleto;
                                Session["UsuarioCorreo"] = correo;
                                Session["CorreoUsuario"] = correo;
                                Session["Email"] = correo;
                                Session["Correo"] = correo;
                                Session["NumeroSocio"] = numeroSocio;

                                if (!identificadorSocio.Contains("@"))
                                {
                                    Session["ClienteDUI"] = identificadorSocio;
                                    Session["UsuarioDUI"] = identificadorSocio;
                                    Session["DUI"] = identificadorSocio;
                                }

                                Session["UsuarioTelefono"] = telefono;
                                Session["Telefono"] = telefono;
                                Session["Saldo"] = saldo;
                                Session["CDT"] = cdt;
                                Session["Prestamo"] = prestamo;

                                // Los créditos viven en la base de datos: se recuperan si el servidor se reinició.
                                if (socioData.Creditos.Count == 0)
                                {
                                    socioData.Creditos.AddRange(BancoDatos.CargarCreditos(idUsuario));
                                }
                                if (!string.IsNullOrEmpty(numCuentaBD)) socioData.NumeroCuenta = numCuentaBD;

                                Session["ListaCreditos"] = socioData.Creditos;
                                Session["TieneCuentaAhorro"] = socioData.TieneCuentaAhorro;
                                if (!string.IsNullOrEmpty(socioData.NumeroCuenta))
                                {
                                    Session["NumeroCuentaAhorro"] = socioData.NumeroCuenta;
                                }

                                Response.Redirect("Index.aspx");
                            }
                            else
                            {
                                MostrarError("La contraseña ingresada es incorrecta.");
                            }
                        }
                        else
                        {
                            MostrarError("El correo ingresado no está registrado como socio en CoopFacil. Por favor, regístrate primero.");
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.Error.WriteLine("[Login] " + ex);
                    MostrarError("No pudimos iniciar sesión en este momento. Inténtalo de nuevo en unos minutos.");
                }
            }
        }

        private bool EsColumnaExistente(MySqlDataReader reader, string nombreColumna)
        {
            try
            {
                return reader.GetOrdinal(nombreColumna) >= 0;
            }
            catch
            {
                return false;
            }
        }

        private void MostrarError(string mensaje)
        {
            pnlMensaje.Visible = true;
            litError.Text = mensaje;
        }
    }
}