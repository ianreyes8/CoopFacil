using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace CoopFacil.Pages
{
    public partial class Registro : Page
    {
        private string conexionStr = ConfigurationManager.ConnectionStrings["CoopFacilDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlMensaje.Visible = false;
            }
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            string nombre = txtNombre.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;
            string passwordConfirm = txtPasswordConfirm.Text;
            string tipoAcceso = ddlTipoAcceso.SelectedValue;

            if (string.IsNullOrEmpty(nombre) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                MostrarError("Por favor completa todos los campos requeridos.");
                return;
            }

            if (!email.Contains("@") || !email.Contains("."))
            {
                MostrarError("Ingresa un correo electrónico válido que contenga '@'.");
                return;
            }

            if (password.Length < 8)
            {
                MostrarError("La contraseña debe tener al menos 8 caracteres.");
                return;
            }

            if (password != passwordConfirm)
            {
                MostrarError("Las contraseñas no coinciden.");
                return;
            }

            using (SqlConnection con = new SqlConnection(conexionStr))
            {
                try
                {
                    con.Open();

                    // 1. Validar correo duplicado
                    string checkQuery = "SELECT COUNT(*) FROM Usuarios WHERE Email = @Email";
                    SqlCommand checkCmd = new SqlCommand(checkQuery, con);
                    checkCmd.Parameters.AddWithValue("@Email", email);
                    int existe = (int)checkCmd.ExecuteScalar();

                    if (existe > 0)
                    {
                        MostrarError("Este correo electrónico ya se encuentra registrado en CoopFacil.");
                        return;
                    }

                    // 2. Generar número de socio único
                    Random rnd = new Random();
                    string numeroSocio = $"Socio #{rnd.Next(100000, 999999)}";

                    // 3. Registrar nuevo cliente desde cero (Saldo, CDT y Préstamo en $0.00)
                    string insertUserQuery = @"
                        INSERT INTO Usuarios (NombreCompleto, Email, Password, TipoAcceso, NumeroSocio, Saldo, CDT, Prestamo)
                        OUTPUT INSERTED.IdUsuario
                        VALUES (@Nombre, @Email, @Password, @TipoAcceso, @NumeroSocio, 0.00, 0.00, 0.00)";

                    SqlCommand insertCmd = new SqlCommand(insertUserQuery, con);
                    insertCmd.Parameters.AddWithValue("@Nombre", nombre);
                    insertCmd.Parameters.AddWithValue("@Email", email);
                    insertCmd.Parameters.AddWithValue("@Password", password);
                    insertCmd.Parameters.AddWithValue("@TipoAcceso", tipoAcceso);
                    insertCmd.Parameters.AddWithValue("@NumeroSocio", numeroSocio);

                    int idUsuarioCreado = (int)insertCmd.ExecuteScalar();

                    // 4. Iniciar sesión automática con el nuevo socio
                    Session["IdUsuario"] = idUsuarioCreado;
                    Session["NombreCompleto"] = nombre;
                    Session["NumeroSocio"] = numeroSocio;

                    Response.Redirect("../Index.aspx");
                }
                catch (Exception ex)
                {
                    MostrarError("Error al registrar en la base de datos: " + ex.Message);
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