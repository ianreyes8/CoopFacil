using System;
using System.Collections.Generic;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using MySqlConnector;

namespace CoopFacil.Helpers
{
    internal static class Hash
    {
        public static string Sha256(string texto) =>
            Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(texto))).ToLowerInvariant();
    }

    /// <summary>Sesiones iniciadas guardadas en la base de datos: sobreviven a un reinicio del servidor.</summary>
    public static class SesionesBD
    {
        // La sesión en memoria dura 20 min sin actividad; en la base de datos se deja un margen y se renueva cada pocos minutos.
        public static readonly TimeSpan Vigencia = TimeSpan.FromMinutes(25);
        public static readonly TimeSpan CadaRenovacion = TimeSpan.FromMinutes(5);

        private static string Con => BancoDatos.Conexion;

        public static void Guardar(string idSesion, int idUsuario)
        {
            if (string.IsNullOrEmpty(Con) || string.IsNullOrEmpty(idSesion)) return;
            try
            {
                using var con = new MySqlConnection(Con);
                con.Open();
                var ahora = DateTime.Now;
                using (var limpiar = new MySqlCommand("DELETE FROM Sesiones WHERE Expira < @a", con))
                {
                    limpiar.Parameters.AddWithValue("@a", ahora);
                    limpiar.ExecuteNonQuery();
                }
                using var cmd = new MySqlCommand(
                    "INSERT INTO Sesiones (IdSesionHash, IdUsuario, Creada, Expira) VALUES (@h, @u, @c, @e) " +
                    "ON DUPLICATE KEY UPDATE IdUsuario = VALUES(IdUsuario), Expira = VALUES(Expira)", con);
                cmd.Parameters.AddWithValue("@h", Hash.Sha256(idSesion));
                cmd.Parameters.AddWithValue("@u", idUsuario);
                cmd.Parameters.AddWithValue("@c", ahora);
                cmd.Parameters.AddWithValue("@e", ahora + Vigencia);
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex) { Console.Error.WriteLine("[Sesiones] No se pudo guardar: " + ex.GetType().Name); }
        }

        /// <summary>Devuelve el IdUsuario de una sesión vigente, o 0 si no existe o ya venció.</summary>
        public static int Obtener(string idSesion)
        {
            if (string.IsNullOrEmpty(Con) || string.IsNullOrEmpty(idSesion)) return 0;
            try
            {
                using var con = new MySqlConnection(Con);
                con.Open();
                using var cmd = new MySqlCommand("SELECT IdUsuario FROM Sesiones WHERE IdSesionHash = @h AND Expira > @a", con);
                cmd.Parameters.AddWithValue("@h", Hash.Sha256(idSesion));
                cmd.Parameters.AddWithValue("@a", DateTime.Now);
                var r = cmd.ExecuteScalar();
                return r == null || r == DBNull.Value ? 0 : Convert.ToInt32(r);
            }
            catch (Exception ex) { Console.Error.WriteLine("[Sesiones] No se pudo leer: " + ex.GetType().Name); return 0; }
        }

        public static void Renovar(string idSesion)
        {
            if (string.IsNullOrEmpty(Con) || string.IsNullOrEmpty(idSesion)) return;
            try
            {
                using var con = new MySqlConnection(Con);
                con.Open();
                using var cmd = new MySqlCommand("UPDATE Sesiones SET Expira = @e WHERE IdSesionHash = @h AND Expira > @a", con);
                cmd.Parameters.AddWithValue("@h", Hash.Sha256(idSesion));
                cmd.Parameters.AddWithValue("@a", DateTime.Now);
                cmd.Parameters.AddWithValue("@e", DateTime.Now + Vigencia);
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex) { Console.Error.WriteLine("[Sesiones] No se pudo renovar: " + ex.GetType().Name); }
        }

        public static void Eliminar(string idSesion)
        {
            if (string.IsNullOrEmpty(Con) || string.IsNullOrEmpty(idSesion)) return;
            try
            {
                using var con = new MySqlConnection(Con);
                con.Open();
                using var cmd = new MySqlCommand("DELETE FROM Sesiones WHERE IdSesionHash = @h", con);
                cmd.Parameters.AddWithValue("@h", Hash.Sha256(idSesion));
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex) { Console.Error.WriteLine("[Sesiones] No se pudo cerrar: " + ex.GetType().Name); }
        }
    }

    /// <summary>
    /// Límite de intentos fallidos por correo y por dirección IP, para frenar el adivinado de contraseñas
    /// y el envío masivo de correos de recuperación.
    /// </summary>
    public static class LimiteIntentos
    {
        public const string Login = "login";
        public const string Recuperar = "recuperar";

        private static string Con => BancoDatos.Conexion;
        private static string Norm(string c) { c = (c ?? "").Trim().ToLowerInvariant(); return c.Length > 100 ? c.Substring(0, 100) : c; }
        private static string NormIp(string ip) { ip = ip ?? ""; return ip.Length > 45 ? ip.Substring(0, 45) : ip; }

        /// <summary>Devuelve null si puede intentar, o cuánto falta para que se libere el bloqueo.</summary>
        public static TimeSpan? Bloqueo(string tipo, string correo, string ip, int maxPorCorreo, int maxPorIp, TimeSpan ventana)
        {
            if (string.IsNullOrEmpty(Con)) return null;
            try
            {
                using var con = new MySqlConnection(Con);
                con.Open();
                var ahora = DateTime.Now;
                var desde = ahora - ventana;
                TimeSpan? espera = null;
                foreach (var (columna, valor, max) in new[] { ("Correo", Norm(correo), maxPorCorreo), ("Ip", NormIp(ip), maxPorIp) })
                {
                    if (string.IsNullOrEmpty(valor)) continue;
                    using var cmd = new MySqlCommand(
                        $"SELECT COUNT(*), MIN(Fecha) FROM IntentosAcceso WHERE Tipo = @t AND {columna} = @v AND Fecha >= @d", con);
                    cmd.Parameters.AddWithValue("@t", tipo);
                    cmd.Parameters.AddWithValue("@v", valor);
                    cmd.Parameters.AddWithValue("@d", desde);
                    using var rd = cmd.ExecuteReader();
                    if (rd.Read() && Convert.ToInt32(rd[0]) >= max && rd[1] != DBNull.Value)
                    {
                        var libre = Convert.ToDateTime(rd[1]) + ventana - ahora;
                        if (libre > TimeSpan.Zero && (espera == null || libre > espera)) espera = libre;
                    }
                }
                return espera;
            }
            catch (Exception ex) { Console.Error.WriteLine("[Intentos] No se pudo consultar: " + ex.GetType().Name); return null; }
        }

        public static void RegistrarFallo(string tipo, string correo, string ip)
        {
            if (string.IsNullOrEmpty(Con)) return;
            try
            {
                using var con = new MySqlConnection(Con);
                con.Open();
                var ahora = DateTime.Now;
                using (var limpiar = new MySqlCommand("DELETE FROM IntentosAcceso WHERE Fecha < @d", con))
                {
                    limpiar.Parameters.AddWithValue("@d", ahora.AddDays(-1));
                    limpiar.ExecuteNonQuery();
                }
                using var cmd = new MySqlCommand("INSERT INTO IntentosAcceso (Tipo, Correo, Ip, Fecha) VALUES (@t, @c, @i, @f)", con);
                cmd.Parameters.AddWithValue("@t", tipo);
                cmd.Parameters.AddWithValue("@c", Norm(correo));
                cmd.Parameters.AddWithValue("@i", NormIp(ip));
                cmd.Parameters.AddWithValue("@f", ahora);
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex) { Console.Error.WriteLine("[Intentos] No se pudo registrar: " + ex.GetType().Name); }
        }

        public static void Limpiar(string tipo, string correo)
        {
            if (string.IsNullOrEmpty(Con)) return;
            try
            {
                using var con = new MySqlConnection(Con);
                con.Open();
                using var cmd = new MySqlCommand("DELETE FROM IntentosAcceso WHERE Tipo = @t AND Correo = @c", con);
                cmd.Parameters.AddWithValue("@t", tipo);
                cmd.Parameters.AddWithValue("@c", Norm(correo));
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex) { Console.Error.WriteLine("[Intentos] No se pudo limpiar: " + ex.GetType().Name); }
        }

        public static string TextoEspera(TimeSpan espera)
        {
            int min = (int)Math.Ceiling(espera.TotalMinutes);
            if (min < 1) min = 1;
            return min == 1 ? "1 minuto" : min + " minutos";
        }
    }

    /// <summary>Restablecer contraseña con un enlace de un solo uso enviado por correo.</summary>
    public static class RecuperacionClave
    {
        public static readonly TimeSpan Vigencia = TimeSpan.FromMinutes(30);
        private static string Con => BancoDatos.Conexion;

        /// <summary>Crea un token para el correo. Devuelve null si el correo no pertenece a ningún socio.</summary>
        public static (string Token, string Nombre)? Crear(string correo)
        {
            if (string.IsNullOrEmpty(Con)) return null;
            using var con = new MySqlConnection(Con);
            con.Open();
            int id; string nombre;
            using (var cmd = new MySqlCommand("SELECT IdUsuario, NombreCompleto FROM Usuarios WHERE Email = @e", con))
            {
                cmd.Parameters.AddWithValue("@e", (correo ?? "").Trim());
                using var rd = cmd.ExecuteReader();
                if (!rd.Read()) return null;
                id = Convert.ToInt32(rd["IdUsuario"]);
                nombre = rd["NombreCompleto"].ToString();
            }
            string token = Convert.ToBase64String(RandomNumberGenerator.GetBytes(32)).Replace('+', '-').Replace('/', '_').TrimEnd('=');
            var ahora = DateTime.Now;
            using (var viejos = new MySqlCommand("DELETE FROM RecuperacionClave WHERE IdUsuario = @u OR Expira < @a", con))
            {
                viejos.Parameters.AddWithValue("@u", id);
                viejos.Parameters.AddWithValue("@a", ahora);
                viejos.ExecuteNonQuery();
            }
            using (var ins = new MySqlCommand("INSERT INTO RecuperacionClave (IdUsuario, TokenHash, Creada, Expira) VALUES (@u, @h, @c, @e)", con))
            {
                ins.Parameters.AddWithValue("@u", id);
                ins.Parameters.AddWithValue("@h", Hash.Sha256(token));
                ins.Parameters.AddWithValue("@c", ahora);
                ins.Parameters.AddWithValue("@e", ahora + Vigencia);
                ins.ExecuteNonQuery();
            }
            return (token, nombre);
        }

        public static bool TokenValido(string token)
        {
            if (string.IsNullOrEmpty(Con) || string.IsNullOrEmpty(token) || token.Length > 100) return false;
            try
            {
                using var con = new MySqlConnection(Con);
                con.Open();
                using var cmd = new MySqlCommand("SELECT COUNT(*) FROM RecuperacionClave WHERE TokenHash = @h AND Usado = 0 AND Expira > @a", con);
                cmd.Parameters.AddWithValue("@h", Hash.Sha256(token));
                cmd.Parameters.AddWithValue("@a", DateTime.Now);
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
            catch (Exception ex) { Console.Error.WriteLine("[Recuperación] " + ex.GetType().Name); return false; }
        }

        /// <summary>Cambia la contraseña y gasta el token. Cierra todas las sesiones guardadas del socio.</summary>
        public static bool Restablecer(string token, string nuevaClave)
        {
            if (string.IsNullOrEmpty(Con) || string.IsNullOrEmpty(token) || token.Length > 100) return false;
            using var con = new MySqlConnection(Con);
            con.Open();
            using var tx = con.BeginTransaction();
            int id;
            using (var cmd = new MySqlCommand(
                "SELECT IdUsuario FROM RecuperacionClave WHERE TokenHash = @h AND Usado = 0 AND Expira > @a FOR UPDATE", con, tx))
            {
                cmd.Parameters.AddWithValue("@h", Hash.Sha256(token));
                cmd.Parameters.AddWithValue("@a", DateTime.Now);
                var r = cmd.ExecuteScalar();
                if (r == null || r == DBNull.Value) { tx.Rollback(); return false; }
                id = Convert.ToInt32(r);
            }
            using (var up = new MySqlCommand("UPDATE Usuarios SET Password = @p WHERE IdUsuario = @u", con, tx))
            {
                up.Parameters.AddWithValue("@p", PasswordHasher.Hashear(nuevaClave));
                up.Parameters.AddWithValue("@u", id);
                up.ExecuteNonQuery();
            }
            foreach (var tabla in new[] { "RecuperacionClave", "Sesiones" })
            {
                using var del = new MySqlCommand($"DELETE FROM {tabla} WHERE IdUsuario = @u", con, tx);
                del.Parameters.AddWithValue("@u", id);
                del.ExecuteNonQuery();
            }
            tx.Commit();
            return true;
        }
    }
}
