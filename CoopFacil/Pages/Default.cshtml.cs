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

            string ip = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "";

            // Demasiados intentos fallidos con este correo o desde esta dirección: se pide esperar.
            var espera = LimiteIntentos.Bloqueo(LimiteIntentos.Login, email, ip, 5, 30, TimeSpan.FromMinutes(15));
            if (espera != null)
            {
                MostrarError("Demasiados intentos fallidos. Por seguridad, vuelve a intentarlo en " + LimiteIntentos.TextoEspera(espera.Value) + ".");
                return;
            }

            try
            {
                int idUsuario = 0;
                string hashGuardado = null;

                using (MySqlConnection con = new MySqlConnection(conexionStr))
                {
                    con.Open();
                    MySqlCommand cmd = new MySqlCommand("SELECT IdUsuario, Password FROM Usuarios WHERE Email = @Email", con);
                    cmd.Parameters.AddWithValue("@Email", email);
                    using (MySqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            idUsuario = Convert.ToInt32(reader["IdUsuario"]);
                            hashGuardado = reader["Password"].ToString();
                        }
                    }
                }

                // Mismo mensaje si el correo no existe o la contraseña es incorrecta: no revela qué correos están registrados.
                if (idUsuario == 0 || !PasswordHasher.Verificar(password, hashGuardado))
                {
                    LimiteIntentos.RegistrarFallo(LimiteIntentos.Login, email, ip);
                    MostrarError("Correo o contraseña incorrectos. Verifica tus datos e inténtalo de nuevo.");
                    return;
                }

                LimiteIntentos.Limpiar(LimiteIntentos.Login, email);

                if (!SesionUsuario.Iniciar(Session, idUsuario))
                {
                    MostrarError("No pudimos iniciar sesión en este momento. Inténtalo de nuevo en unos minutos.");
                    return;
                }

                Response.Redirect("Index.aspx");
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("[Login] " + ex);
                MostrarError("No pudimos iniciar sesión en este momento. Inténtalo de nuevo en unos minutos.");
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