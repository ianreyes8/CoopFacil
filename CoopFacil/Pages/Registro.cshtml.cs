using System;
using CoopFacil.Compat;
using System.Configuration;
using MySqlConnector;
using System.Web.UI;
using CoopFacil.Helpers;
using System.Text.RegularExpressions;

namespace CoopFacil.Pages
{
    public partial class Registro : PaginaWeb
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
            string dui = SoloDigitos(txtDUI.Text);
            string telefono = SoloDigitos(txtTelefono.Text);

            // 1. VALIDACIONES INICIALES DE REGISTRO
            if (string.IsNullOrEmpty(nombre) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password) || dui.Length == 0 || telefono.Length == 0)
            {
                MostrarError("Por favor completa todos los campos requeridos.");
                return;
            }

            if (!email.Contains("@") || !email.Contains("."))
            {
                MostrarError("Ingresa un correo electrónico válido que contenga '@' y un dominio.");
                return;
            }

            if (dui.Length != 9)
            {
                MostrarError("El DUI debe tener 9 dígitos (formato 00000000-0).");
                return;
            }

            if (telefono.Length != 8 || (telefono[0] != '6' && telefono[0] != '7'))
            {
                MostrarError("Ingresa un celular válido de 8 dígitos que empiece con 6 o 7 (formato 7000-0000).");
                return;
            }
            dui = dui.Substring(0, 8) + "-" + dui.Substring(8);
            telefono = telefono.Substring(0, 4) + "-" + telefono.Substring(4);

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
                string numeroSocio;
                int idUsuarioCreado = 0;

                // 2. INSERCIÓN EN BASE DE DATOS (usuario + cuenta + saldo de bienvenida, todo en una transacción)
                if (string.IsNullOrEmpty(conexionStr))
                {
                    MostrarError("No hay conexión configurada con la base de datos.");
                    return;
                }

                string numeroCuenta;
                using (MySqlConnection con = new MySqlConnection(conexionStr))
                {
                    con.Open();

                    string checkQuery = "SELECT COUNT(*) FROM Usuarios WHERE Email = @Email";
                    using (MySqlCommand checkCmd = new MySqlCommand(checkQuery, con))
                    {
                        checkCmd.Parameters.AddWithValue("@Email", email);
                        int existe = Convert.ToInt32(checkCmd.ExecuteScalar());

                        if (existe > 0)
                        {
                            MostrarError("Este correo electrónico ya se encuentra registrado en CoopFacil.");
                            return;
                        }
                    }

                    using (MySqlCommand checkDui = new MySqlCommand("SELECT COUNT(*) FROM Usuarios WHERE DUI = @Dui", con))
                    {
                        checkDui.Parameters.AddWithValue("@Dui", dui);
                        if (Convert.ToInt32(checkDui.ExecuteScalar()) > 0)
                        {
                            MostrarError("Este DUI ya se encuentra registrado en CoopFacil.");
                            return;
                        }
                    }

                    using (MySqlTransaction tx = con.BeginTransaction())
                    {
                        numeroCuenta = BancoDatos.GenerarNumeroCuentaUnico(con, tx);
                        numeroSocio = BancoDatos.GenerarNumeroSocioUnico(con, tx);

                        string insertUserQuery = @"
                            INSERT INTO Usuarios (NombreCompleto, Email, Password, TipoAcceso, NumeroSocio, Saldo, CDT, Prestamo, NumeroCuenta, DUI, Telefono, FechaRegistro)
                            VALUES (@Nombre, @Email, @Password, @TipoAcceso, @NumeroSocio, @Saldo, 0.00, 0.00, @NumeroCuenta, @Dui, @Telefono, @FechaRegistro)";

                        using (MySqlCommand insertCmd = new MySqlCommand(insertUserQuery, con, tx))
                        {
                            insertCmd.Parameters.AddWithValue("@Nombre", nombre);
                            insertCmd.Parameters.AddWithValue("@Email", email);
                            insertCmd.Parameters.AddWithValue("@Password", PasswordHasher.Hashear(password));
                            insertCmd.Parameters.AddWithValue("@TipoAcceso", tipoAcceso);
                            insertCmd.Parameters.AddWithValue("@NumeroSocio", numeroSocio);
                            insertCmd.Parameters.AddWithValue("@Saldo", BancoDatos.SaldoBienvenida);
                            insertCmd.Parameters.AddWithValue("@NumeroCuenta", numeroCuenta);
                            insertCmd.Parameters.AddWithValue("@Dui", dui);
                            insertCmd.Parameters.AddWithValue("@Telefono", telefono);
                            insertCmd.Parameters.AddWithValue("@FechaRegistro", DateTime.Now);

                            insertCmd.ExecuteNonQuery();
                            idUsuarioCreado = Convert.ToInt32(insertCmd.LastInsertedId);
                        }

                        using (MySqlCommand movCmd = new MySqlCommand(@"
                            INSERT INTO Movimientos (IdUsuario, Fecha, Descripcion, Monto, SaldoResultante, Estado, EsPositivo, Tipo)
                            VALUES (@Id, @Fecha, 'Bono de bienvenida CoopFacil', @Monto, @Monto, 'Completado', 1, 'Bono')", con, tx))
                        {
                            movCmd.Parameters.AddWithValue("@Fecha", DateTime.Now);
                            movCmd.Parameters.AddWithValue("@Id", idUsuarioCreado);
                            movCmd.Parameters.AddWithValue("@Monto", BancoDatos.SaldoBienvenida);
                            movCmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                    }
                }

                // 3. INICIAR SESIÓN: identificador nuevo, datos del socio (incluye DUI y celular) y registro en la base de datos
                if (!SesionUsuario.Iniciar(Session, idUsuarioCreado))
                {
                    Response.Redirect("../Default.aspx");
                    return;
                }

                // 4. GENERACIÓN DE COMPROBANTE PDF Y ENVÍO DE BIENVENIDA POR CORREO
                try
                {
                    DatosComprobante datos = new DatosComprobante
                    {
                        NumeroTransaccion = "REG-" + DateTime.Now.ToString("yyyyMMddHHmmss"),
                        NombreCliente = nombre,
                        DUI = dui,
                        Telefono = telefono,
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
            catch (MySqlException ex) when (ex.Number == 1062 && ex.Message.Contains("UQ_Usuarios_DUI"))
            {
                MostrarError("Este DUI ya se encuentra registrado en CoopFacil.");
            }
            catch (MySqlException ex) when (ex.Number == 1062)
            {
                // Dos registros con el mismo correo al mismo tiempo: gana el primero.
                MostrarError("Este correo electrónico ya se encuentra registrado en CoopFacil.");
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("[Registro] " + ex);
                MostrarError("No pudimos completar tu registro en este momento. Inténtalo de nuevo en unos minutos.");
            }
        }

        private static string SoloDigitos(string texto)
        {
            return Regex.Replace(texto ?? "", @"\D", "");
        }

        private void MostrarError(string mensaje)
        {
            pnlMensaje.Visible = true;
            litError.Text = mensaje;
        }
    }
}