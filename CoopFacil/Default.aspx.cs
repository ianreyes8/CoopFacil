using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace CoopFacil
{
    public partial class Default : Page
    {
        private string conexionStr = ConfigurationManager.ConnectionStrings["CoopFacilDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlMensaje.Visible = false;
            }
        }

        protected void btnAcceder_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            // 1. Validar campos requeridos
            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                MostrarError("Por favor, ingresa tu correo electrónico y contraseña.");
                return;
            }

            // 2. Validar que el correo contenga '@' y '.'
            if (!email.Contains("@") || !email.Contains("."))
            {
                MostrarError("El correo electrónico debe ser válido y contener el símbolo '@'.");
                return;
            }

            // 3. Validar mínimo 8 caracteres en la contraseña
            if (password.Length < 8)
            {
                MostrarError("La contraseña debe tener un mínimo de 8 caracteres.");
                return;
            }

            // 4. Consulta a la Base de Datos SQL Server
            using (SqlConnection con = new SqlConnection(conexionStr))
            {
                string query = "SELECT IdUsuario, NombreCompleto, Email, Password, NumeroSocio FROM Usuarios WHERE Email = @Email";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);

                try
                {
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        string dbPassword = reader["Password"].ToString();

                        if (dbPassword == password)
                        {
                            // Usuario autenticado exitosamente
                            Session["IdUsuario"] = Convert.ToInt32(reader["IdUsuario"]);
                            Session["NombreCompleto"] = reader["NombreCompleto"].ToString();
                            Session["NumeroSocio"] = reader["NumeroSocio"].ToString();

                            Response.Redirect("Index.aspx");
                        }
                        else
                        {
                            MostrarError("La contraseña ingresada es incorrecta.");
                        }
                    }
                    else
                    {
                        // Bloquea el paso si no está en la base de datos
                        MostrarError("El correo ingresado no está registrado como socio en CoopFacil. Por favor, regístrate primero.");
                    }
                }
                catch (Exception ex)
                {
                    MostrarError("Error de conexión a la base de datos: " + ex.Message);
                }
            }
        }

        private void MostrarError(string mensaje)
        {
            pnlMensaje.Visible = true;
            litError.Text = mensaje;
        }
    }
}