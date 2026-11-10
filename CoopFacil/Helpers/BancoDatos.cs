using System;
using System.Collections.Generic;
using System.Configuration;
using MySqlConnector;

namespace CoopFacil.Helpers
{
    /// <summary>Acceso a la base de datos para cuentas, movimientos y créditos.</summary>
    public static class BancoDatos
    {
        public const decimal SaldoBienvenida = 100.00m;

        public static string Conexion => ConfigurationManager.ConnectionStrings["CoopFacilDB"]?.ConnectionString;

        /// <summary>Genera un número de cuenta de 12 dígitos que no exista todavía.</summary>
        public static string GenerarNumeroCuentaUnico(MySqlConnection con, MySqlTransaction tx)
        {
            var rnd = new Random();
            for (int intento = 0; intento < 20; intento++)
            {
                string numero = "100" + rnd.Next(100000000, 999999999);
                using var cmd = new MySqlCommand("SELECT COUNT(*) FROM Usuarios WHERE NumeroCuenta = @n", con, tx);
                cmd.Parameters.AddWithValue("@n", numero);
                if (Convert.ToInt32(cmd.ExecuteScalar()) == 0) return numero;
            }
            throw new InvalidOperationException("No se pudo generar un número de cuenta único.");
        }

        // ------------------------------------------------------------------ créditos

        public static void GuardarCredito(string correo, CreditoSolicitado c)
        {
            if (string.IsNullOrEmpty(Conexion) || string.IsNullOrWhiteSpace(correo)) return;
            try
            {
                using var con = new MySqlConnection(Conexion);
                con.Open();
                using var cmd = new MySqlCommand(@"
                    INSERT INTO Creditos (IdUsuario, NumeroTransaccion, TipoCredito, Monto, PlazoMeses, CuotaMensual, Fecha)
                    SELECT IdUsuario, @tx, @tipo, @monto, @plazo, @cuota, @fecha FROM Usuarios WHERE Email = @correo", con);
                cmd.Parameters.AddWithValue("@tx", c.NumeroTransaccion ?? "");
                cmd.Parameters.AddWithValue("@tipo", c.TipoCredito ?? "");
                cmd.Parameters.AddWithValue("@monto", c.Monto);
                cmd.Parameters.AddWithValue("@plazo", c.PlazoMeses);
                cmd.Parameters.AddWithValue("@cuota", c.CuotaMensual);
                cmd.Parameters.AddWithValue("@fecha", c.FechaMovimiento);
                cmd.Parameters.AddWithValue("@correo", correo.Trim());
                cmd.ExecuteNonQuery();
            }
            catch
            {
                // El crédito sigue disponible en memoria aunque falle el guardado.
            }
        }

        public static List<CreditoSolicitado> CargarCreditos(int idUsuario)
        {
            var lista = new List<CreditoSolicitado>();
            if (string.IsNullOrEmpty(Conexion)) return lista;
            try
            {
                using var con = new MySqlConnection(Conexion);
                con.Open();
                using var cmd = new MySqlCommand(
                    "SELECT NumeroTransaccion, TipoCredito, Monto, PlazoMeses, CuotaMensual, Fecha FROM Creditos WHERE IdUsuario = @id ORDER BY Fecha", con);
                cmd.Parameters.AddWithValue("@id", idUsuario);
                using var r = cmd.ExecuteReader();
                while (r.Read())
                {
                    lista.Add(new CreditoSolicitado
                    {
                        NumeroTransaccion = r.GetString(0),
                        TipoCredito = r.GetString(1),
                        Monto = r.GetDecimal(2),
                        PlazoMeses = r.GetInt32(3),
                        CuotaMensual = r.GetDecimal(4),
                        FechaMovimiento = r.GetDateTime(5)
                    });
                }
            }
            catch
            {
            }
            return lista;
        }
    }
}
