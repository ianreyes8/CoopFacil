using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
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

        /// <summary>Genera un número de socio ("Socio #123456") que no exista todavía.</summary>
        public static string GenerarNumeroSocioUnico(MySqlConnection con, MySqlTransaction tx)
        {
            var rnd = new Random();
            for (int intento = 0; intento < 30; intento++)
            {
                string numero = $"Socio #{rnd.Next(100000, 999999)}";
                using var cmd = new MySqlCommand("SELECT COUNT(*) FROM Usuarios WHERE NumeroSocio = @n", con, tx);
                cmd.Parameters.AddWithValue("@n", numero);
                if (Convert.ToInt32(cmd.ExecuteScalar()) == 0) return numero;
            }
            throw new InvalidOperationException("No se pudo generar un número de socio único.");
        }

        // ------------------------------------------------------------------ créditos

        public static void GuardarCredito(string correo, CreditoSolicitado c)
        {
            if (string.IsNullOrEmpty(Conexion) || string.IsNullOrWhiteSpace(correo)) return;
            try
            {
                using var con = new MySqlConnection(Conexion);
                con.Open();
                using var tx = con.BeginTransaction();

                int idUsuario;
                using (var cmdId = new MySqlCommand("SELECT IdUsuario FROM Usuarios WHERE Email = @correo FOR UPDATE", con, tx))
                {
                    cmdId.Parameters.AddWithValue("@correo", correo.Trim());
                    object r = cmdId.ExecuteScalar();
                    if (r == null || r == DBNull.Value) return;
                    idUsuario = Convert.ToInt32(r);
                }

                using (var cmd = new MySqlCommand(@"
                    INSERT INTO Creditos (IdUsuario, NumeroTransaccion, TipoCredito, Monto, PlazoMeses, CuotaMensual, Fecha)
                    VALUES (@id, @tx, @tipo, @monto, @plazo, @cuota, @fecha)", con, tx))
                {
                    cmd.Parameters.AddWithValue("@id", idUsuario);
                    cmd.Parameters.AddWithValue("@tx", c.NumeroTransaccion ?? "");
                    cmd.Parameters.AddWithValue("@tipo", c.TipoCredito ?? "");
                    cmd.Parameters.AddWithValue("@monto", c.Monto);
                    cmd.Parameters.AddWithValue("@plazo", c.PlazoMeses);
                    cmd.Parameters.AddWithValue("@cuota", c.CuotaMensual);
                    cmd.Parameters.AddWithValue("@fecha", c.FechaMovimiento);
                    cmd.ExecuteNonQuery();
                }

                // El monto aprobado se desembolsa en la cuenta del socio y queda como movimiento.
                decimal nuevoSaldo = AplicarMovimiento(con, tx, idUsuario, c.Monto, true,
                    "Desembolso de " + c.TipoCredito, "Credito", c.NumeroTransaccion);
                tx.Commit();
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

        // ------------------------------------------------------------------ cuenta, movimientos, transferencias

        public class PerfilCuenta
        {
            public int IdUsuario { get; set; }
            public string Nombre { get; set; } = "";
            public string Email { get; set; } = "";
            public string NumeroSocio { get; set; } = "";
            public string NumeroCuenta { get; set; } = "";
            public decimal Saldo { get; set; }
        }

        public class MovimientoCuenta
        {
            public DateTime Fecha { get; set; }
            public string Descripcion { get; set; } = "";
            public decimal Monto { get; set; }
            public decimal SaldoResultante { get; set; }
            public bool EsPositivo { get; set; }
            public string Tipo { get; set; } = "";
        }

        public class ResultadoOperacion
        {
            public bool Exito { get; set; }
            public string Mensaje { get; set; } = "";
            public string Referencia { get; set; } = "";
        }

        public class DatosTarjeta
        {
            public string Numero { get; set; } = "";
            public string Vence { get; set; } = "";
            public string Cvv { get; set; } = "";
        }

        /// <summary>
        /// Datos de la tarjeta virtual de débito, derivados siempre igual a partir del número de cuenta
        /// (no se guardan en la base de datos): número de 16 dígitos, vencimiento MM/AA y CVV de 3 dígitos.
        /// </summary>
        public static DatosTarjeta GenerarDatosTarjeta(string numeroCuenta)
        {
            string cuenta = new string((numeroCuenta ?? "").Where(char.IsDigit).ToArray()).PadLeft(12, '0');
            byte[] h = System.Security.Cryptography.SHA256.HashData(System.Text.Encoding.UTF8.GetBytes("CoopFacil.Tarjeta|" + cuenta));

            string relleno = (BitConverter.ToUInt32(h, 0) % 1000).ToString("D3");
            string numero = "5" + cuenta.Substring(cuenta.Length - 12) + relleno;
            int mes = h[4] % 12 + 1;
            int anio = 30 + h[5] % 3;
            int cvv = (int)(BitConverter.ToUInt32(h, 8) % 900) + 100;

            return new DatosTarjeta
            {
                Numero = string.Join(" ", Enumerable.Range(0, 4).Select(i => numero.Substring(i * 4, 4))),
                Vence = $"{mes:D2}/{anio:D2}",
                Cvv = cvv.ToString()
            };
        }

        public static string FormatearCuenta(string numero)
        {
            string limpio = new string((numero ?? "").Where(char.IsDigit).ToArray());
            if (limpio.Length != 12) return numero ?? "";
            return $"{limpio.Substring(0, 4)} {limpio.Substring(4, 4)} {limpio.Substring(8, 4)}";
        }

        public static PerfilCuenta ObtenerPerfil(int idUsuario)
        {
            if (string.IsNullOrEmpty(Conexion)) return null;
            using var con = new MySqlConnection(Conexion);
            con.Open();
            using var cmd = new MySqlCommand(
                "SELECT NombreCompleto, Email, NumeroSocio, NumeroCuenta, Saldo FROM Usuarios WHERE IdUsuario = @id", con);
            cmd.Parameters.AddWithValue("@id", idUsuario);
            using var r = cmd.ExecuteReader();
            if (!r.Read()) return null;
            return new PerfilCuenta
            {
                IdUsuario = idUsuario,
                Nombre = r.GetString(0),
                Email = r.GetString(1),
                NumeroSocio = r.GetString(2),
                NumeroCuenta = r.IsDBNull(3) ? "" : r.GetString(3),
                Saldo = r.GetDecimal(4)
            };
        }

        public static List<MovimientoCuenta> ObtenerMovimientos(int idUsuario, int maximo = 50)
        {
            var lista = new List<MovimientoCuenta>();
            if (string.IsNullOrEmpty(Conexion)) return lista;
            using var con = new MySqlConnection(Conexion);
            con.Open();
            using var cmd = new MySqlCommand(@"
                SELECT Fecha, Descripcion, Monto, SaldoResultante, EsPositivo, Tipo
                FROM Movimientos WHERE IdUsuario = @id ORDER BY Fecha DESC, IdMovimiento DESC LIMIT @max", con);
            cmd.Parameters.AddWithValue("@id", idUsuario);
            cmd.Parameters.AddWithValue("@max", maximo);
            using var r = cmd.ExecuteReader();
            while (r.Read())
            {
                lista.Add(new MovimientoCuenta
                {
                    Fecha = r.GetDateTime(0),
                    Descripcion = r.GetString(1),
                    Monto = r.GetDecimal(2),
                    SaldoResultante = r.GetDecimal(3),
                    EsPositivo = Convert.ToInt32(r.GetValue(4)) != 0,
                    Tipo = r.GetString(5)
                });
            }
            return lista;
        }

        /// <summary>Suma o resta saldo y registra el movimiento. Debe llamarse dentro de una transacción con la fila bloqueada.</summary>
        private static decimal AplicarMovimiento(MySqlConnection con, MySqlTransaction tx, int idUsuario, decimal monto,
            bool esPositivo, string descripcion, string tipo, string referencia)
        {
            using (var upd = new MySqlCommand(
                "UPDATE Usuarios SET Saldo = Saldo + @delta WHERE IdUsuario = @id", con, tx))
            {
                upd.Parameters.AddWithValue("@delta", esPositivo ? monto : -monto);
                upd.Parameters.AddWithValue("@id", idUsuario);
                upd.ExecuteNonQuery();
            }

            decimal nuevoSaldo;
            using (var sel = new MySqlCommand("SELECT Saldo FROM Usuarios WHERE IdUsuario = @id", con, tx))
            {
                sel.Parameters.AddWithValue("@id", idUsuario);
                nuevoSaldo = Convert.ToDecimal(sel.ExecuteScalar());
            }

            using (var mov = new MySqlCommand(@"
                INSERT INTO Movimientos (IdUsuario, Descripcion, Monto, SaldoResultante, Estado, EsPositivo, Tipo, Referencia)
                VALUES (@id, @desc, @monto, @saldo, 'Completado', @pos, @tipo, @ref)", con, tx))
            {
                mov.Parameters.AddWithValue("@id", idUsuario);
                mov.Parameters.AddWithValue("@desc", descripcion.Length > 255 ? descripcion.Substring(0, 255) : descripcion);
                mov.Parameters.AddWithValue("@monto", monto);
                mov.Parameters.AddWithValue("@saldo", nuevoSaldo);
                mov.Parameters.AddWithValue("@pos", esPositivo ? 1 : 0);
                mov.Parameters.AddWithValue("@tipo", tipo);
                mov.Parameters.AddWithValue("@ref", (object)referencia ?? DBNull.Value);
                mov.ExecuteNonQuery();
            }
            return nuevoSaldo;
        }

        public const decimal DepositoMaximo = 5000.00m;

        public static ResultadoOperacion Depositar(int idUsuario, decimal monto)
        {
            monto = Math.Round(monto, 2);
            if (monto <= 0) return new ResultadoOperacion { Mensaje = "El monto a depositar debe ser mayor que cero." };
            if (monto > DepositoMaximo)
                return new ResultadoOperacion { Mensaje = $"El depósito no puede superar ${DepositoMaximo:N2}." };

            using var con = new MySqlConnection(Conexion);
            con.Open();
            using var tx = con.BeginTransaction();

            using (var bloqueo = new MySqlCommand("SELECT Saldo FROM Usuarios WHERE IdUsuario = @id FOR UPDATE", con, tx))
            {
                bloqueo.Parameters.AddWithValue("@id", idUsuario);
                if (bloqueo.ExecuteScalar() == null) return new ResultadoOperacion { Mensaje = "No se encontró tu cuenta." };
            }

            string referencia = "DEP-" + DateTime.Now.ToString("yyyyMMddHHmmss") + "-" + idUsuario;
            AplicarMovimiento(con, tx, idUsuario, monto, true, "Depósito en cuenta", "Deposito", referencia);
            tx.Commit();
            return new ResultadoOperacion { Exito = true, Referencia = referencia, Mensaje = $"Depósito de ${monto:N2} realizado correctamente." };
        }

        /// <summary>
        /// Transfiere dinero a otra cuenta de la aplicación (por número de cuenta de 12 dígitos o por correo).
        /// Todo ocurre en una sola transacción: o se descuenta y se acredita, o no pasa nada.
        /// </summary>
        public static ResultadoOperacion Transferir(int idOrigen, string destino, decimal monto, string concepto)
        {
            monto = Math.Round(monto, 2);
            if (string.IsNullOrWhiteSpace(destino)) return new ResultadoOperacion { Mensaje = "Indica el número de cuenta o el correo del destinatario." };
            if (monto <= 0) return new ResultadoOperacion { Mensaje = "El monto debe ser mayor que cero." };
            concepto = (concepto ?? "").Trim();
            if (concepto.Length > 150) concepto = concepto.Substring(0, 150);

            using var con = new MySqlConnection(Conexion);
            con.Open();
            using var tx = con.BeginTransaction();

            // 1. Buscar al destinatario
            string limpio = new string(destino.Where(char.IsDigit).ToArray());
            int idDestino;
            string nombreDestino;
            using (var buscar = new MySqlCommand(
                "SELECT IdUsuario, NombreCompleto FROM Usuarios WHERE NumeroCuenta = @cuenta OR Email = @correo LIMIT 1", con, tx))
            {
                buscar.Parameters.AddWithValue("@cuenta", destino.Contains("@") ? "" : limpio);
                buscar.Parameters.AddWithValue("@correo", destino.Trim());
                using var r = buscar.ExecuteReader();
                if (!r.Read()) return new ResultadoOperacion { Mensaje = "No existe ninguna cuenta con ese número de cuenta o correo." };
                idDestino = r.GetInt32(0);
                nombreDestino = r.GetString(1);
            }

            if (idDestino == idOrigen) return new ResultadoOperacion { Mensaje = "No puedes transferirte dinero a tu propia cuenta." };

            // 2. Bloquear ambas filas siempre en el mismo orden (evita bloqueos cruzados entre dos transferencias simultáneas)
            decimal saldoOrigen = 0m;
            string nombreOrigen = "";
            using (var bloqueo = new MySqlCommand(
                "SELECT IdUsuario, Saldo, NombreCompleto FROM Usuarios WHERE IdUsuario IN (@a, @b) ORDER BY IdUsuario FOR UPDATE", con, tx))
            {
                bloqueo.Parameters.AddWithValue("@a", idOrigen);
                bloqueo.Parameters.AddWithValue("@b", idDestino);
                using var r = bloqueo.ExecuteReader();
                while (r.Read())
                {
                    if (r.GetInt32(0) == idOrigen) { saldoOrigen = r.GetDecimal(1); nombreOrigen = r.GetString(2); }
                }
            }

            if (saldoOrigen < monto)
                return new ResultadoOperacion { Mensaje = $"Saldo insuficiente. Tu saldo disponible es ${saldoOrigen:N2}." };

            // 3. Registrar la transferencia y los dos movimientos
            string referencia = "TRF-" + DateTime.Now.ToString("yyyyMMddHHmmss") + "-" + idOrigen + idDestino;
            using (var ins = new MySqlCommand(@"
                INSERT INTO Transferencias (Referencia, IdOrigen, IdDestino, Monto, Concepto)
                VALUES (@ref, @o, @d, @m, @c)", con, tx))
            {
                ins.Parameters.AddWithValue("@ref", referencia);
                ins.Parameters.AddWithValue("@o", idOrigen);
                ins.Parameters.AddWithValue("@d", idDestino);
                ins.Parameters.AddWithValue("@m", monto);
                ins.Parameters.AddWithValue("@c", string.IsNullOrEmpty(concepto) ? (object)DBNull.Value : concepto);
                ins.ExecuteNonQuery();
            }

            string sufijo = string.IsNullOrEmpty(concepto) ? "" : " - " + concepto;
            AplicarMovimiento(con, tx, idOrigen, monto, false, "Transferencia enviada a " + nombreDestino + sufijo, "TransferenciaEnviada", referencia);
            AplicarMovimiento(con, tx, idDestino, monto, true, "Transferencia recibida de " + nombreOrigen + sufijo, "TransferenciaRecibida", referencia);
            tx.Commit();

            return new ResultadoOperacion
            {
                Exito = true,
                Referencia = referencia,
                Mensaje = $"Transferencia de ${monto:N2} enviada a {nombreDestino}."
            };
        }
    }
}
