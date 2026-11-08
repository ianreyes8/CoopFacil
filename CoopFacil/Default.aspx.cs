using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using CoopFacil.Helpers;

namespace CoopFacil
{
    public partial class Default : Page
    {
        private string conexionStr = ConfigurationManager.ConnectionStrings["CoopFacilDB"]?.ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlMensaje.Visible = false;

                // 1. Redireccionar si ya existe sesión activa
                if (Session["IdUsuario"] != null || Session["NombreCompleto"] != null)
                {
                    Response.Redirect("Index.aspx");
                    return;
                }

                // 2. Cargar el total de socios registrados en el control lblSocios
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

            using (SqlConnection con = new SqlConnection(conexionStr))
            {
                string query = "SELECT COUNT(*) FROM Usuarios";
                SqlCommand cmd = new SqlCommand(query, con);

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

            // 1. Validaciones de formulario
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

            // 2. Validación de credenciales en SQL Server
            using (SqlConnection con = new SqlConnection(conexionStr))
            {
                string query = @"SELECT * FROM Usuarios WHERE Email = @Email";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);

                try
                {
                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string dbPassword = reader["Password"].ToString();

                            if (dbPassword == password)
                            {
                                int idUsuario = Convert.ToInt32(reader["IdUsuario"]);
                                string nombreCompleto = reader["NombreCompleto"].ToString();
                                string correo = reader["Email"].ToString();
                                string numeroSocio = reader["NumeroSocio"] != DBNull.Value ? reader["NumeroSocio"].ToString() : "";
                                decimal saldo = reader["Saldo"] != DBNull.Value ? Convert.ToDecimal(reader["Saldo"]) : 0.00m;
                                decimal cdt = reader["CDT"] != DBNull.Value ? Convert.ToDecimal(reader["CDT"]) : 0.00m;
                                decimal prestamo = reader["Prestamo"] != DBNull.Value ? Convert.ToDecimal(reader["Prestamo"]) : 0.00m;

                                // Obtener DUI y Teléfono de forma segura si existen en el esquema de BD
                                string dui = EsColumnaExistente(reader, "DUI") && reader["DUI"] != DBNull.Value ? reader["DUI"].ToString() : "";
                                string telefono = EsColumnaExistente(reader, "Telefono") && reader["Telefono"] != DBNull.Value ? reader["Telefono"].ToString() : "";

                                // Identificador principal (se usa DUI si existe y es válido, sino el correo)
                                string identificadorSocio = !string.IsNullOrWhiteSpace(dui) && !dui.Contains("@") ? dui : correo;

                                // 3. RESTAURAR CRÉDITOS PERSISTENTES Y ESTADO DE CUENTA DE AHORRO
                                var socioData = RepositorioBanco.ObtenerOcrear(identificadorSocio, nombreCompleto);

                                // 4. Cargar variables de sesión completas para todo el sistema
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

                                // Cargar Créditos y Cuenta de Ahorro a la Sesión activa
                                Session["ListaCreditos"] = socioData.Creditos;
                                Session["TieneCuentaAhorro"] = socioData.TieneCuentaAhorro;

                                if (socioData.TieneCuentaAhorro && !string.IsNullOrEmpty(socioData.NumeroCuenta))
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
                    MostrarError("Error de conexión a la base de datos: " + ex.Message);
                }
            }
        }

        private bool EsColumnaExistente(SqlDataReader reader, string nombreColumna)
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