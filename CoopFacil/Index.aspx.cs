using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace CoopFacil
{
    public partial class Index : Page
    {
        private string conexionStr = ConfigurationManager.ConnectionStrings["CoopFacilDB"]?.ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                EvaluarEstadoSesion();
            }
        }

        private void EvaluarEstadoSesion()
        {
            string nombreCompleto = ObtenerNombreUsuarioSesion();
            bool estaAutenticado = !string.IsNullOrEmpty(nombreCompleto);

            lnkIniciarSesion.Visible = !estaAutenticado;
            btnCerrarSesion.Visible = estaAutenticado;
            pnlBienvenida.Visible = estaAutenticado;
            pnlResumenSocio.Visible = estaAutenticado;

            if (estaAutenticado)
            {
                litBienvenida.Text = ExtraerPrimerNombreYPrimerApellido(nombreCompleto);
                litNombreSocio.Text = nombreCompleto;

                CargarDatosFinancierosSocio();
            }
        }

        private string ObtenerNombreUsuarioSesion()
        {
            string[] clavesNombre = new string[] { "NombreCompleto", "UsuarioNombre", "NombreUsuario", "Usuario", "Nombre", "nombre", "usuario" };

            foreach (string clave in clavesNombre)
            {
                if (Session[clave] != null)
                {
                    string valor = Session[clave].ToString().Trim();
                    if (!string.IsNullOrWhiteSpace(valor) && !int.TryParse(valor, out _))
                    {
                        return valor;
                    }
                }
            }
            return null;
        }

        private int ObtenerIdUsuarioSesion()
        {
            if (Session["IdUsuario"] != null && int.TryParse(Session["IdUsuario"].ToString(), out int id))
            {
                return id;
            }
            return 0;
        }

        private void CargarDatosFinancierosSocio()
        {
            int idUsuario = ObtenerIdUsuarioSesion();
            string numeroSocio = Session["NumeroSocio"] != null ? Session["NumeroSocio"].ToString() : "Socio #000000";
            decimal saldo = Session["Saldo"] != DBNull.Value && Session["Saldo"] != null ? Convert.ToDecimal(Session["Saldo"]) : 0.00m;
            decimal cdt = Session["CDT"] != DBNull.Value && Session["CDT"] != null ? Convert.ToDecimal(Session["CDT"]) : 0.00m;
            decimal prestamo = Session["Prestamo"] != DBNull.Value && Session["Prestamo"] != null ? Convert.ToDecimal(Session["Prestamo"]) : 0.00m;

            // Consultar datos actualizados de SQL Server si la conexión está disponible
            if (idUsuario > 0 && !string.IsNullOrEmpty(conexionStr))
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(conexionStr))
                    {
                        con.Open();
                        string query = "SELECT NumeroSocio, Saldo, CDT, Prestamo FROM Usuarios WHERE IdUsuario = @IdUsuario";
                        using (SqlCommand cmd = new SqlCommand(query, con))
                        {
                            cmd.Parameters.AddWithValue("@IdUsuario", idUsuario);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    numeroSocio = reader["NumeroSocio"] != DBNull.Value ? reader["NumeroSocio"].ToString() : numeroSocio;
                                    saldo = reader["Saldo"] != DBNull.Value ? Convert.ToDecimal(reader["Saldo"]) : 0.00m;
                                    cdt = reader["CDT"] != DBNull.Value ? Convert.ToDecimal(reader["CDT"]) : 0.00m;
                                    prestamo = reader["Prestamo"] != DBNull.Value ? Convert.ToDecimal(reader["Prestamo"]) : 0.00m;

                                    Session["NumeroSocio"] = numeroSocio;
                                    Session["Saldo"] = saldo;
                                    Session["CDT"] = cdt;
                                    Session["Prestamo"] = prestamo;
                                }
                            }
                        }
                    }
                }
                catch
                {
                    // Ante cualquier inconveniente en la BD se utilizan los valores asignados en la sesión activa
                }
            }

            litNumeroSocio.Text = string.IsNullOrEmpty(numeroSocio) ? "Socio #000000" : numeroSocio;
            litSaldo.Text = "$" + saldo.ToString("N2");
            litCDT.Text = "$" + cdt.ToString("N2");
            litPrestamo.Text = "$" + prestamo.ToString("N2");
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Index.aspx");
        }

        public static string ExtraerPrimerNombreYPrimerApellido(string nombreCompleto)
        {
            if (string.IsNullOrWhiteSpace(nombreCompleto)) return "";
            string[] partes = nombreCompleto.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

            if (partes.Length == 1) return partes[0];
            if (partes.Length == 2) return $"{partes[0]} {partes[1]}";
            if (partes.Length == 3) return $"{partes[0]} {partes[1]}";
            return $"{partes[0]} {partes[2]}";
        }
    }
}