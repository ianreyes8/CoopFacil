using System;
using System.Configuration;
using System.Net;
using CoopFacil.Helpers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace CoopFacil.Pages
{
    /// <summary>Paso 1 de la recuperación: pedir el enlace por correo. Siempre responde igual, exista o no el correo.</summary>
    public class OlvidoClaveModel : PageModel
    {
        [BindProperty] public string Correo { get; set; }
        public bool Enviado { get; private set; }
        public string Error { get; private set; }

        public void OnGet() { }

        public IActionResult OnPost()
        {
            string correo = (Correo ?? "").Trim();
            if (correo.Length == 0 || correo.Length > 100 || !correo.Contains("@") || !correo.Contains("."))
            {
                Error = "Ingresa un correo electrónico válido.";
                return Page();
            }

            string ip = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "";
            var espera = LimiteIntentos.Bloqueo(LimiteIntentos.Recuperar, correo, ip, 3, 10, TimeSpan.FromHours(1));
            if (espera != null)
            {
                Error = "Ya solicitaste varios enlaces. Vuelve a intentarlo en " + LimiteIntentos.TextoEspera(espera.Value) + ".";
                return Page();
            }
            // Cada solicitud cuenta, exista o no el correo (así tampoco se puede usar para averiguar qué correos están registrados).
            LimiteIntentos.RegistrarFallo(LimiteIntentos.Recuperar, correo, ip);

            try
            {
                var creado = RecuperacionClave.Crear(correo);
                if (creado != null)
                {
                    string baseUrl = ConfigurationManager.AppSettings["UrlPublica"]?.TrimEnd('/') ?? $"{Request.Scheme}://{Request.Host}";
                    string enlace = baseUrl + Url.Content("~/Pages/RestablecerClave.aspx") + "?token=" + Uri.EscapeDataString(creado.Value.Token);
                    bool enviado = CorreoSimple.Enviar(correo, "Restablece tu contraseña de CoopFácil", ConstruirCorreo(creado.Value.Nombre, enlace));

                    // Solo en desarrollo: si el correo no está configurado, el enlace se muestra en la consola del servidor.
                    if (!enviado && string.Equals(Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT"), "Development", StringComparison.OrdinalIgnoreCase))
                        Console.WriteLine("[Recuperación - solo desarrollo] Enlace para " + correo + ": " + enlace);
                }
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("[Recuperación] " + ex.GetType().Name);
            }

            Enviado = true;
            return Page();
        }

        private static string ConstruirCorreo(string nombre, string enlace)
        {
            string n = WebUtility.HtmlEncode(nombre ?? "");
            string e = WebUtility.HtmlEncode(enlace);
            return $@"<div style='font-family: Arial, sans-serif; max-width: 520px; margin: 0 auto; padding: 24px; color: #1e293b;'>
                <h2 style='color: #059669; margin-top: 0;'>Restablece tu contraseña</h2>
                <p>Hola {n},</p>
                <p>Recibimos una solicitud para cambiar la contraseña de tu cuenta de CoopFácil. Pulsa el botón para crear una nueva:</p>
                <p style='text-align: center; margin: 28px 0;'><a href='{e}' style='background: #059669; color: #ffffff; padding: 12px 24px; border-radius: 10px; text-decoration: none; font-weight: bold;'>Crear nueva contraseña</a></p>
                <p style='font-size: 13px; color: #475569;'>El enlace es válido por 30 minutos y solo se puede usar una vez. Si no fuiste tú, ignora este mensaje: tu contraseña actual no cambiará.</p>
                <hr style='border: none; border-top: 1px solid #e2e8f0; margin: 20px 0;' />
                <p style='font-size: 11px; color: #64748b;'>CoopFácil © {DateTime.Now.Year}</p>
            </div>";
        }
    }
}
