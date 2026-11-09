using Microsoft.Extensions.Configuration;

namespace System.Configuration
{
    public class ConnectionStringSettings
    {
        public ConnectionStringSettings(string name, string connectionString)
        {
            Name = name;
            ConnectionString = connectionString;
        }

        public string Name { get; }
        public string ConnectionString { get; }
    }

    public class ConnectionStringSettingsCollection
    {
        private readonly Dictionary<string, ConnectionStringSettings> _valores = new(StringComparer.OrdinalIgnoreCase);
        internal void Agregar(ConnectionStringSettings c) => _valores[c.Name] = c;
        public ConnectionStringSettings? this[string nombre] => _valores.TryGetValue(nombre, out var c) ? c : null;
    }

    public class AppSettingsCollection
    {
        private readonly Dictionary<string, string> _valores = new(StringComparer.OrdinalIgnoreCase);
        internal void Agregar(string clave, string valor) => _valores[clave] = valor;
        public string? this[string clave] => _valores.TryGetValue(clave, out var v) && v.Length > 0 ? v : null;
    }

    /// <summary>
    /// Mismo uso que en Web Forms: ConfigurationManager.ConnectionStrings["CoopFacilDB"] y
    /// ConfigurationManager.AppSettings["SmtpHost"]. Los valores ya no viven en Web.config:
    ///   - Base de datos: variable MYSQL_URL (Railway) o ConnectionStrings:CoopFacilDB (appsettings).
    ///   - Correo: sección AppSettings de appsettings.json / appsettings.Local.json / variables de entorno.
    /// </summary>
    public static class ConfigurationManager
    {
        public static ConnectionStringSettingsCollection ConnectionStrings { get; } = new();
        public static AppSettingsCollection AppSettings { get; } = new();

        public static void Inicializar(IConfiguration configuracion)
        {
            foreach (var par in configuracion.GetSection("AppSettings").GetChildren())
                if (par.Value is not null) AppSettings.Agregar(par.Key, par.Value);

            var url = Environment.GetEnvironmentVariable("MYSQL_URL");
            if (!string.IsNullOrWhiteSpace(url)
                && Uri.TryCreate(url, UriKind.Absolute, out var uri)
                && uri.Scheme.StartsWith("mysql", StringComparison.OrdinalIgnoreCase))
            {
                var credenciales = uri.UserInfo.Split(':', 2);
                var builder = new MySqlConnector.MySqlConnectionStringBuilder
                {
                    Server = uri.Host,
                    Port = (uint)(uri.Port > 0 ? uri.Port : 3306),
                    UserID = Uri.UnescapeDataString(credenciales[0]),
                    Password = credenciales.Length > 1 ? Uri.UnescapeDataString(credenciales[1]) : "",
                    Database = uri.AbsolutePath.TrimStart('/')
                };
                ConnectionStrings.Agregar(new ConnectionStringSettings("CoopFacilDB", builder.ConnectionString));
                return;
            }

            var local = configuracion.GetConnectionString("CoopFacilDB");
            if (!string.IsNullOrWhiteSpace(local))
                ConnectionStrings.Agregar(new ConnectionStringSettings("CoopFacilDB", local));
        }
    }
}
