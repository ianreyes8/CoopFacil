using System;
using System.Collections.Generic;
using MySqlConnector;
using CoopFacil.Compat;

namespace CoopFacil.Helpers
{
    /// <summary>Arma los datos de sesión de un socio a partir de la base de datos (al iniciar sesión y al recuperarla tras un reinicio).</summary>
    public static class SesionUsuario
    {
        /// <summary>Devuelve los valores de sesión del socio, o null si no existe.</summary>
        public static Dictionary<string, object> Construir(int idUsuario)
        {
            string con = BancoDatos.Conexion;
            if (string.IsNullOrEmpty(con)) return null;

            int id; string nombre, correo, numeroSocio, dui, telefono, numCuenta; decimal saldo, cdt, prestamo; bool tieneCuenta;
            using (var cn = new MySqlConnection(con))
            {
                cn.Open();
                using var cmd = new MySqlCommand("SELECT * FROM Usuarios WHERE IdUsuario = @u", cn);
                cmd.Parameters.AddWithValue("@u", idUsuario);
                using var r = cmd.ExecuteReader();
                if (!r.Read()) return null;
                id = Convert.ToInt32(r["IdUsuario"]);
                nombre = r["NombreCompleto"].ToString();
                correo = r["Email"].ToString();
                numeroSocio = Texto(r, "NumeroSocio");
                saldo = Decimal(r, "Saldo"); cdt = Decimal(r, "CDT"); prestamo = Decimal(r, "Prestamo");
                dui = Texto(r, "DUI"); telefono = Texto(r, "Telefono"); numCuenta = Texto(r, "NumeroCuenta");
                tieneCuenta = r["TieneCuentaAhorro"] != DBNull.Value && Convert.ToBoolean(r["TieneCuentaAhorro"]);
            }

            string identificador = !string.IsNullOrWhiteSpace(dui) && !dui.Contains("@") ? dui : correo;
            RepositorioBanco.AsociarIdentificadores(dui, correo, nombre);
            var socio = RepositorioBanco.ObtenerOcrear(identificador, nombre);
            if (tieneCuenta)
            {
                socio.TieneCuentaAhorro = true;
                if (!string.IsNullOrEmpty(numCuenta)) socio.NumeroCuenta = numCuenta;
            }
            // Los créditos viven en la base de datos: se recuperan si el servidor se reinició.
            if (socio.Creditos.Count == 0) socio.Creditos.AddRange(BancoDatos.CargarCreditos(id));
            if (!string.IsNullOrEmpty(numCuenta)) socio.NumeroCuenta = numCuenta;

            var d = new Dictionary<string, object>
            {
                ["IdUsuario"] = id,
                ["NombreCompleto"] = nombre,
                ["ClienteNombreCompleto"] = nombre,
                ["UsuarioNombre"] = nombre,
                ["NombreUsuario"] = nombre,
                ["UsuarioCorreo"] = correo,
                ["CorreoUsuario"] = correo,
                ["Email"] = correo,
                ["Correo"] = correo,
                ["NumeroSocio"] = numeroSocio,
                ["UsuarioTelefono"] = telefono,
                ["Telefono"] = telefono,
                ["Saldo"] = saldo,
                ["CDT"] = cdt,
                ["Prestamo"] = prestamo,
                ["ListaCreditos"] = socio.Creditos,
                ["TieneCuentaAhorro"] = socio.TieneCuentaAhorro
            };
            if (!identificador.Contains("@"))
            {
                d["ClienteDUI"] = identificador; d["UsuarioDUI"] = identificador; d["DUI"] = identificador;
            }
            if (!string.IsNullOrEmpty(socio.NumeroCuenta)) d["NumeroCuentaAhorro"] = socio.NumeroCuenta;
            return d;
        }

        /// <summary>Inicia sesión: identificador nuevo (evita fijación de sesión), datos del socio y registro en la base de datos.</summary>
        public static bool Iniciar(SesionWeb sesion, int idUsuario)
        {
            var datos = Construir(idUsuario);
            if (datos == null) return false;
            sesion.RegenerarId();
            foreach (var par in datos) sesion[par.Key] = par.Value;
            SesionesBD.Guardar(sesion.SessionID, idUsuario);
            return true;
        }

        private static string Texto(MySqlDataReader r, string col)
        {
            try { return r[col] != DBNull.Value ? r[col].ToString() : ""; } catch (IndexOutOfRangeException) { return ""; }
        }

        private static decimal Decimal(MySqlDataReader r, string col)
        {
            try { return r[col] != DBNull.Value ? Convert.ToDecimal(r[col]) : 0m; } catch (IndexOutOfRangeException) { return 0m; }
        }
    }
}
