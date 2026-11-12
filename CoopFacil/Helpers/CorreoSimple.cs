using System;
using System.Collections.Generic;
using System.Configuration;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Mail;
using System.Text;
using System.Text.Json;

namespace CoopFacil.Helpers
{
    /// <summary>Correos sin adjuntos (por ejemplo, recuperar contraseña). Usa Resend si hay clave; si no, SMTP.</summary>
    public static class CorreoSimple
    {
        private static readonly HttpClient Cliente = new HttpClient { Timeout = TimeSpan.FromSeconds(20) };

        public static bool Enviar(string para, string asunto, string html)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(para)) return false;
                string apiKey = ConfigurationManager.AppSettings["ResendApiKey"];
                if (!string.IsNullOrEmpty(apiKey)) return PorResend(apiKey, para, asunto, html);
                return PorSmtp(para, asunto, html);
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("[Correo] Error al enviar: " + ex.GetType().Name);
                return false;
            }
        }

        private static bool PorResend(string apiKey, string para, string asunto, string html)
        {
            string remitente = ConfigurationManager.AppSettings["ResendRemitente"] ?? "CoopFácil <onboarding@resend.dev>";
            var cuerpo = new Dictionary<string, object>
            {
                ["from"] = remitente,
                ["to"] = new[] { para.Trim() },
                ["subject"] = asunto,
                ["html"] = html
            };
            using var solicitud = new HttpRequestMessage(HttpMethod.Post, "https://api.resend.com/emails")
            {
                Content = new StringContent(JsonSerializer.Serialize(cuerpo), Encoding.UTF8, "application/json")
            };
            solicitud.Headers.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
            using var respuesta = Cliente.Send(solicitud);
            if (respuesta.IsSuccessStatusCode) return true;
            string detalle = new System.IO.StreamReader(respuesta.Content.ReadAsStream()).ReadToEnd();
            Console.Error.WriteLine($"[Correo] Resend respondió {(int)respuesta.StatusCode}: {detalle}");
            return false;
        }

        private static bool PorSmtp(string para, string asunto, string html)
        {
            string emisor = ConfigurationManager.AppSettings["SmtpCorreoEmisor"];
            string password = ConfigurationManager.AppSettings["SmtpPassword"];
            string host = ConfigurationManager.AppSettings["SmtpHost"] ?? "smtp.gmail.com";
            int port = int.Parse(ConfigurationManager.AppSettings["SmtpPort"] ?? "587");
            if (string.IsNullOrEmpty(emisor) || string.IsNullOrEmpty(password)) return false;

            using var mail = new MailMessage { From = new MailAddress(emisor, "CoopFácil Cooperativa Financiera"), Subject = asunto, IsBodyHtml = true, Body = html };
            mail.To.Add(para);
            using var smtp = new SmtpClient(host, port) { Credentials = new NetworkCredential(emisor, password), EnableSsl = true };
            smtp.Send(mail);
            return true;
        }
    }
}
