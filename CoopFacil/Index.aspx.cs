using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace CoopFacil
{
    public partial class Index : Page
    {
        private string conexionStr = ConfigurationManager.ConnectionStrings["CoopFacilDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                EvaluarEstadoSesion();
            }
        }

        private void EvaluarEstadoSesion()
        {
            bool estaAutenticado = (Session["IdUsuario"] != null);

            lnkIniciarSesion.Visible = !estaAutenticado;
            btnPortalSocio.Visible = estaAutenticado;
            btnCerrarSesion.Visible = estaAutenticado;
            pnlBienvenida.Visible = estaAutenticado;

            if (estaAutenticado)
            {
                string nombreCompleto = Session["NombreCompleto"] != null ? Session["NombreCompleto"].ToString() : "";

                // Saludo esquina superior izquierda: "Bienvenido (Primer Nombre) (Primer Apellido)"
                litBienvenida.Text = ExtraerPrimerNombreYPrimerApellido(nombreCompleto);
            }
        }

        protected void btnPortalSocio_Click(object sender, EventArgs e)
        {
            if (Session["IdUsuario"] == null) return;

            int idUsuario = Convert.ToInt32(Session["IdUsuario"]);

            using (SqlConnection con = new SqlConnection(conexionStr))
            {
                con.Open();

                // 1. Obtener la información del cliente registrado desde SQL Server
                string userQuery = "SELECT NombreCompleto, NumeroSocio, Saldo, CDT, Prestamo FROM Usuarios WHERE IdUsuario = @IdUsuario";
                SqlCommand userCmd = new SqlCommand(userQuery, con);
                userCmd.Parameters.AddWithValue("@IdUsuario", idUsuario);

                SqlDataReader reader = userCmd.ExecuteReader();
                if (reader.Read())
                {
                    string nombreCompleto = reader["NombreCompleto"].ToString();
                    litNombreSocio.Text = nombreCompleto; // Nombre completo en el Portal Socio
                    litNumeroSocio.Text = reader["NumeroSocio"].ToString();
                    litIniciales.Text = GenerarIniciales(nombreCompleto);

                    decimal saldo = Convert.ToDecimal(reader["Saldo"]);
                    decimal cdt = Convert.ToDecimal(reader["CDT"]);
                    decimal prestamo = Convert.ToDecimal(reader["Prestamo"]);

                    litSaldo.Text = string.Format("${0:N2}", saldo);
                    litCDT.Text = string.Format("${0:N2}", cdt);
                    litPrestamo.Text = string.Format("${0:N2}", prestamo);
                }
                reader.Close();

                // 2. Cargar movimientos desde SQL Server pertenecientes a este cliente
                string movQuery = @"
                    SELECT 
                        FORMAT(Fecha, 'dd MMM yyyy') AS Fecha, 
                        Descripcion, 
                        CASE WHEN EsPositivo = 1 THEN '+$' + CONVERT(VARCHAR, Monto) ELSE '-$' + CONVERT(VARCHAR, ABS(Monto)) END AS MontoFormatted, 
                        '$' + CONVERT(VARCHAR, SaldoResultante) AS SaldoFormatted, 
                        Estado, 
                        EsPositivo 
                    FROM Movimientos 
                    WHERE IdUsuario = @IdUsuario 
                    ORDER BY IdMovimiento DESC";

                SqlCommand movCmd = new SqlCommand(movQuery, con);
                movCmd.Parameters.AddWithValue("@IdUsuario", idUsuario);

                SqlDataAdapter da = new SqlDataAdapter(movCmd);
                DataTable dtMovimientos = new DataTable();
                da.Fill(dtMovimientos);

                // Evaluar si existen movimientos o si la cuenta es nueva
                if (dtMovimientos.Rows.Count > 0)
                {
                    rptMovimientos.DataSource = dtMovimientos;
                    rptMovimientos.DataBind();
                    rptMovimientos.Visible = true;
                    pnlSinMovimientos.Visible = false;
                }
                else
                {
                    rptMovimientos.Visible = false;
                    pnlSinMovimientos.Visible = true;
                }
            }

            // Abrir el modal
            Page.ClientScript.RegisterStartupScript(this.GetType(), "ModalScript", "toggleModal(true);", true);
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

        public static string GenerarIniciales(string nombreCompleto)
        {
            if (string.IsNullOrWhiteSpace(nombreCompleto)) return "CF";
            string[] partes = nombreCompleto.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (partes.Length == 1) return partes[0].Substring(0, 1).ToUpper();
            if (partes.Length >= 4) return (partes[0].Substring(0, 1) + partes[2].Substring(0, 1)).ToUpper();
            return (partes[0].Substring(0, 1) + partes[1].Substring(0, 1)).ToUpper();
        }
    }
}