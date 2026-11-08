using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using CoopFacil.Helpers;

namespace CoopFacil.Pages
{
    public partial class RegistroCredito : Page
    {
        private string conexionStr = ConfigurationManager.ConnectionStrings["CoopFacilDB"]?.ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                VerificarCuentaExistente();
                CargarDatosPrevios();
            }
        }

        private void VerificarCuentaExistente()
        {
            string correo = Session["UsuarioCorreo"] as string ?? Session["Correo"] as string ?? Session["Email"] as string;
            string dui = Session["ClienteDUI"] as string ?? Session["UsuarioDUI"] as string;

            bool tieneCuentaSesion = Session["TieneCuentaAhorro"] != null && (bool)Session["TieneCuentaAhorro"];

            if (tieneCuentaSesion)
            {
                Response.Redirect("CuentaAhorro.aspx");
                return;
            }

            // Consultar a la base de datos SQL Server por respaldo
            if (!string.IsNullOrEmpty(conexionStr) && !string.IsNullOrEmpty(correo))
            {
                using (SqlConnection con = new SqlConnection(conexionStr))
                {
                    string query = @"SELECT TieneCuentaAhorro, NumeroCuenta, DUI FROM Usuarios WHERE Email = @Email OR (DUI = @DUI AND NULLIF(@DUI, '') IS NOT NULL)";
                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@Email", correo ?? "");
                    cmd.Parameters.AddWithValue("@DUI", dui ?? "");

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
                                    string numCuenta = reader["NumeroCuenta"] != DBNull.Value ? reader["NumeroCuenta"].ToString() : "";
                                    string duiBD = reader["DUI"] != DBNull.Value ? reader["DUI"].ToString() : "";

                                    Session["TieneCuentaAhorro"] = true;
                                    if (!string.IsNullOrEmpty(numCuenta)) Session["NumeroCuentaAhorro"] = numCuenta;
                                    if (!string.IsNullOrEmpty(duiBD)) Session["ClienteDUI"] = duiBD;

                                    Response.Redirect("CuentaAhorro.aspx");
                                }
                            }
                        }
                    }
                    catch { }
                }
            }
        }

        private void CargarDatosPrevios()
        {
            string duiSesion = Session["ClienteDUI"] as string ?? Session["UsuarioDUI"] as string;
            if (!string.IsNullOrEmpty(duiSesion) && string.IsNullOrEmpty(txtDUI.Text))
            {
                txtDUI.Text = duiSesion;
            }

            string nombreSesion = Session["ClienteNombreCompleto"] as string ?? Session["UsuarioNombre"] as string;
            if (!string.IsNullOrEmpty(nombreSesion))
            {
                string[] partes = nombreSesion.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
                if (partes.Length >= 2 && string.IsNullOrEmpty(txtNombres.Text))
                {
                    txtNombres.Text = partes[0];
                    txtApellidos.Text = partes[partes.Length - 1];
                }
                else if (string.IsNullOrEmpty(txtNombres.Text))
                {
                    txtNombres.Text = nombreSesion;
                }
            }
        }

        protected void btnCrearCuenta_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombres.Text) ||
                string.IsNullOrWhiteSpace(txtApellidos.Text) ||
                string.IsNullOrWhiteSpace(txtDUI.Text) ||
                string.IsNullOrWhiteSpace(txtFechaNacimiento.Text))
            {
                pnlError.Visible = true;
                litError.Text = "Por favor, completa todos los campos requeridos.";
                return;
            }

            string nombreCompleto = $"{txtNombres.Text.Trim()} {txtApellidos.Text.Trim()}";
            string dui = txtDUI.Text.Trim();
            string correo = Session["UsuarioCorreo"] as string ?? Session["Correo"] as string ?? Session["Email"] as string;

            // 1. Generar número de cuenta numérico de 12 dígitos
            Random random = new Random();
            string numeroCuenta = "100" + random.Next(100000000, 999999999).ToString();

            // 2. Registrar en RepositorioBanco asociando DUI y correo
            RepositorioBanco.AsociarIdentificadores(dui, correo, nombreCompleto);
            RepositorioBanco.RegistrarCuentaAhorro(dui, numeroCuenta);
            var socio = RepositorioBanco.ObtenerOcrear(dui, nombreCompleto);
            socio.TieneCuentaAhorro = true;
            socio.NumeroCuenta = numeroCuenta;

            // 3. Guardar apertura permanentemente en SQL Server
            if (!string.IsNullOrEmpty(conexionStr))
            {
                using (SqlConnection con = new SqlConnection(conexionStr))
                {
                    string query = @"UPDATE Usuarios 
                                     SET TieneCuentaAhorro = 1, NumeroCuenta = @NumeroCuenta, DUI = CASE WHEN NULLIF(@DUI, '') IS NOT NULL THEN @DUI ELSE DUI END 
                                     WHERE (Email = @Email AND NULLIF(@Email, '') IS NOT NULL) 
                                        OR (DUI = @DUI AND NULLIF(@DUI, '') IS NOT NULL)";

                    SqlCommand cmd = new SqlCommand(query, con);
                    cmd.Parameters.AddWithValue("@NumeroCuenta", numeroCuenta);
                    cmd.Parameters.AddWithValue("@DUI", dui ?? "");
                    cmd.Parameters.AddWithValue("@Email", correo ?? "");

                    try
                    {
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                    catch { }
                }
            }

            // 4. Sincronizar Sesión
            Session["ClienteNombreCompleto"] = nombreCompleto;
            Session["ClienteDUI"] = dui;
            Session["UsuarioNombre"] = nombreCompleto;
            Session["UsuarioDUI"] = dui;
            Session["NumeroCuentaAhorro"] = numeroCuenta;
            Session["TieneCuentaAhorro"] = true;
            Session["ListaCreditos"] = socio.Creditos;

            Response.Redirect("CuentaAhorro.aspx");
        }
    }
}