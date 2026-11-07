using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using CoopFacil.Helpers;

namespace CoopFacil.Pages
{
    public partial class Registro : Page
    {
        private string conexionStr = ConfigurationManager.ConnectionStrings["CoopFacilDB"]?.ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlMensaje.Visible = false;

                // Redirigir si el usuario ya posee una sesión activa
                if (Session["IdUsuario"] != null || Session["UsuarioNombre"] != null)
                {
                    Response.Redirect("../Index.aspx");
                }
            }
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            string nombre = txtNombre.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;
            string passwordConfirm = txtPasswordConfirm.Text;
            string tipoAcceso = ddlTipoAcceso.SelectedValue;

            // 1. VALIDACIONES INICIALES DE REGISTRO
            if (string.IsNullOrEmpty(nombre) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                MostrarError("Por favor completa todos los campos requeridos.");
                return;
            }

            if (!email.Contains("@") || !email.Contains("."))
            {
                MostrarError("Ingresa un correo electrónico válido que contenga '@' y un dominio.");
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

            try
            {
                Random rnd = new Random();
                string numeroSocio = $"Socio #{rnd.Next(100000, 999999)}";
                int idUsuarioCreado = 0;

                // 2. INSERCIÓN EN BASE DE DATOS SQL SERVER
                if (!string.IsNullOrEmpty(conexionStr))
                {
                    using (SqlConnection con = new SqlConnection(conexionStr))
                    {
                        con.Open();

                        string checkQuery = "SELECT COUNT(*) FROM Usuarios WHERE Email = @Email";
                        using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                        {
                            checkCmd.Parameters.AddWithValue("@Email", email);
                            int existe = (int)checkCmd.ExecuteScalar();

                            if (existe > 0)
                            {
                                MostrarError("Este correo electrónico ya se encuentra registrado en CoopFacil.");
                                return;
                            }
                        }

                        string insertUserQuery = @"
                            INSERT INTO Usuarios (NombreCompleto, Email, Password, TipoAcceso, NumeroSocio, Saldo, CDT, Prestamo)
                            OUTPUT INSERTED.IdUsuario
                            VALUES (@Nombre, @Email, @Password, @TipoAcceso, @NumeroSocio, 0.00, 0.00, 0.00)";

                        using (SqlCommand insertCmd = new SqlCommand(insertUserQuery, con))
                        {
                            insertCmd.Parameters.AddWithValue("@Nombre", nombre);
                            insertCmd.Parameters.AddWithValue("@Email", email);
                            insertCmd.Parameters.AddWithValue("@Password", password);
                            insertCmd.Parameters.AddWithValue("@TipoAcceso", tipoAcceso);
                            insertCmd.Parameters.AddWithValue("@NumeroSocio", numeroSocio);

                            idUsuarioCreado = Convert.ToInt32(insertCmd.ExecuteScalar());
                        }
                    }
                }

                // 3. ESTABLECER VARIABLES DE SESIÓN ACTIVA ESTANDARIZADAS
                Session["IdUsuario"] = idUsuarioCreado > 0 ? idUsuarioCreado : 1;
                Session["NombreCompleto"] = nombre;
                Session["UsuarioNombre"] = nombre;
                Session["NombreUsuario"] = nombre;
                Session["UsuarioCorreo"] = email;
                Session["CorreoUsuario"] = email;
                Session["NumeroSocio"] = numeroSocio;

                // 4. GENERACIÓN DE COMPROBANTE PDF Y ENVÍO DE BIENVENIDA POR CORREO
                try
                {
                    DatosComprobante datos = new DatosComprobante
                    {
                        NumeroTransaccion = "REG-" + DateTime.Now.ToString("yyyyMMddHHmmss"),
                        NombreCliente = nombre,
                        DUI = "N/A - Registro Nuevo Socio",
                        Telefono = "N/A",
                        CorreoCliente = email,
                        NombreServicio = "Registro de Nuevo Socio Cooperativo",
                        Monto = 0.00m,
                        DetalleAdicional = "Número de Socio Asignado: " + numeroSocio + " | Tipo: " + tipoAcceso,
                        FechaMovimiento = DateTime.Now
                    };

                    byte[] pdfBytes = ComprobanteServicioHelper.GenerarPdfComprobante(datos);
                    ComprobanteServicioHelper.EnviarComprobantePorCorreo(datos, pdfBytes);
                }
                catch
                {
                    // No interrumpe la navegación en caso de omisión o fallo de configuración SMTP
                }

                // 5. REDIRECCIÓN AL INICIO
                Response.Redirect("../Index.aspx");
            }
            catch (Exception ex)
            {
                MostrarError("Error durante el registro en base de datos: " + ex.Message);
            }
        }

        private void MostrarError(string mensaje)
        {
            pnlMensaje.Visible = true;
            litError.Text = mensaje;
        }
    }
}