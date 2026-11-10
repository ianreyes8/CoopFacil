using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace CoopFacil.Helpers
{
    [Serializable]
    public class CreditoSolicitado
    {
        public string TipoCredito { get; set; }
        public decimal Monto { get; set; }
        public int PlazoMeses { get; set; }
        public decimal CuotaMensual { get; set; }
        public string NumeroTransaccion { get; set; }
        public DateTime FechaMovimiento { get; set; }
    }

    public class DatosComprobante
    {
        public string NumeroTransaccion { get; set; }
        public string NombreCliente { get; set; }
        public string DUI { get; set; }
        public string Telefono { get; set; }
        public string CorreoCliente { get; set; }
        public string NombreServicio { get; set; }
        public decimal Monto { get; set; }
        public string DetalleAdicional { get; set; }
        public DateTime FechaMovimiento { get; set; }
    }

    // CLASE PARA PERMANENCIA DE DATOS DE SOCIO
    public class RegistroSocioData
    {
        public string DUI { get; set; }
        public string Correo { get; set; }
        public string NombreCliente { get; set; }
        public string NumeroCuenta { get; set; }
        public bool TieneCuentaAhorro { get; set; }
        public List<CreditoSolicitado> Creditos { get; set; } = new List<CreditoSolicitado>();
    }

    // REPOSITORIO DE ALMACENAMIENTO PERSISTENTE GLOBAL
    public static class RepositorioBanco
    {
        private static readonly Dictionary<string, RegistroSocioData> _socios = new Dictionary<string, RegistroSocioData>(StringComparer.OrdinalIgnoreCase);

        public static RegistroSocioData ObtenerOcrear(string identificador, string nombre = "")
        {
            if (string.IsNullOrWhiteSpace(identificador)) return new RegistroSocioData();

            identificador = identificador.Trim();

            // 1. Buscar si la clave directa existe (por Correo o DUI)
            if (_socios.ContainsKey(identificador))
            {
                var s = _socios[identificador];
                if (!string.IsNullOrEmpty(nombre)) s.NombreCliente = nombre;
                return s;
            }

            // 2. Buscar si la instancia existe por coincidencia de Correo o DUI en la colección
            var socioExistente = _socios.Values.FirstOrDefault(s =>
                (!string.IsNullOrEmpty(s.DUI) && s.DUI.Equals(identificador, StringComparison.OrdinalIgnoreCase)) ||
                (!string.IsNullOrEmpty(s.Correo) && s.Correo.Equals(identificador, StringComparison.OrdinalIgnoreCase))
            );

            if (socioExistente != null)
            {
                _socios[identificador] = socioExistente;
                if (!string.IsNullOrEmpty(nombre)) socioExistente.NombreCliente = nombre;
                return socioExistente;
            }

            // 3. Crear nuevo socio si no existía previamente
            var nuevoSocio = new RegistroSocioData
            {
                DUI = identificador.Contains("@") ? "" : identificador,
                Correo = identificador.Contains("@") ? identificador : "",
                NombreCliente = nombre,
                TieneCuentaAhorro = false,
                NumeroCuenta = ""
            };

            _socios[identificador] = nuevoSocio;
            return nuevoSocio;
        }

        public static void AsociarIdentificadores(string dui, string correo, string nombre = "")
        {
            if (string.IsNullOrWhiteSpace(dui) && string.IsNullOrWhiteSpace(correo)) return;

            RegistroSocioData socio = null;

            if (!string.IsNullOrWhiteSpace(dui) && _socios.ContainsKey(dui.Trim()))
                socio = _socios[dui.Trim()];
            else if (!string.IsNullOrWhiteSpace(correo) && _socios.ContainsKey(correo.Trim()))
                socio = _socios[correo.Trim()];

            if (socio == null) socio = new RegistroSocioData();

            if (!string.IsNullOrWhiteSpace(dui)) socio.DUI = dui.Trim();
            if (!string.IsNullOrWhiteSpace(correo)) socio.Correo = correo.Trim();
            if (!string.IsNullOrWhiteSpace(nombre)) socio.NombreCliente = nombre.Trim();

            if (!string.IsNullOrWhiteSpace(dui)) _socios[dui.Trim()] = socio;
            if (!string.IsNullOrWhiteSpace(correo)) _socios[correo.Trim()] = socio;
        }

        public static void RegistrarCuentaAhorro(string identificador, string numeroCuenta, string correo = "")
        {
            var socio = ObtenerOcrear(identificador);
            socio.TieneCuentaAhorro = true;
            socio.NumeroCuenta = numeroCuenta;

            if (!string.IsNullOrWhiteSpace(correo))
            {
                socio.Correo = correo;
                _socios[correo.Trim()] = socio;
            }
        }

        public static void AgregarCredito(string identificador, CreditoSolicitado credito, string correo = "")
        {
            var socio = ObtenerOcrear(identificador);
            socio.Creditos.Add(credito);

            if (!string.IsNullOrWhiteSpace(correo))
            {
                socio.Correo = correo;
                _socios[correo.Trim()] = socio;
            }
        }
    }

    public static class ComprobanteServicioHelper
    {
        public static byte[] GenerarPdfComprobante(DatosComprobante datos)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                Document doc = new Document(PageSize.A4, 36, 36, 36, 36);
                PdfWriter.GetInstance(doc, ms);
                doc.Open();

                BaseColor colorVerde = new BaseColor(16, 185, 129);
                BaseColor colorOscuro = new BaseColor(15, 35, 61);

                Font fontTitulo = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 18, colorOscuro);
                Font fontSubtitulo = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 12, colorVerde);
                Font fontNormal = FontFactory.GetFont(FontFactory.HELVETICA, 10, new BaseColor(0, 0, 0));
                Font fontBold = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10, new BaseColor(0, 0, 0));

                Paragraph header = new Paragraph("COOPFACIL COOPERATIVA FINANCIERA", fontTitulo);
                header.Alignment = Element.ALIGN_CENTER;
                doc.Add(header);

                Paragraph sub = new Paragraph("Comprobante Oficial de Movimiento / Pre-Apertura", fontSubtitulo);
                sub.Alignment = Element.ALIGN_CENTER;
                sub.SpacingAfter = 20f;
                doc.Add(sub);

                PdfPTable tabla = new PdfPTable(2);
                tabla.WidthPercentage = 100;
                tabla.SetWidths(new float[] { 35f, 65f });

                void AgregarFila(string campo, string valor)
                {
                    PdfPCell cellCampo = new PdfPCell(new Phrase(campo, fontBold))
                    {
                        BackgroundColor = new BaseColor(241, 245, 249),
                        Padding = 8f
                    };
                    PdfPCell cellValor = new PdfPCell(new Phrase(valor, fontNormal))
                    {
                        Padding = 8f
                    };
                    tabla.AddCell(cellCampo);
                    tabla.AddCell(cellValor);
                }

                AgregarFila("N° Comprobante / Solicitud:", datos.NumeroTransaccion);
                AgregarFila("Fecha y Hora:", datos.FechaMovimiento.ToString("dd/MM/yyyy HH:mm:ss"));
                AgregarFila("Cliente / Socio:", datos.NombreCliente);
                AgregarFila("DUI:", datos.DUI);
                AgregarFila("Teléfono de Contacto:", datos.Telefono);
                AgregarFila("Correo Electrónico:", datos.CorreoCliente);
                AgregarFila("Servicio / Trámite:", datos.NombreServicio);
                AgregarFila("Monto Aplicado / Inicial:", "$" + datos.Monto.ToString("N2") + " USD");
                AgregarFila("Detalles Adicionales:", datos.DetalleAdicional);

                doc.Add(tabla);

                Paragraph nota = new Paragraph("\nEste documento es un comprobante digital generado automáticamente por la plataforma CoopFácil. Consérvalo para tus registros personales.", FontFactory.GetFont(FontFactory.HELVETICA_OBLIQUE, 8, new BaseColor(64, 64, 64)));
                nota.Alignment = Element.ALIGN_CENTER;
                nota.SpacingBefore = 30f;
                doc.Add(nota);

                doc.Close();
                return ms.ToArray();
            }
        }

        public static bool EnviarComprobantePorCorreo(DatosComprobante datos, byte[] pdfBytes)
        {
            try
            {
                string emisor = ConfigurationManager.AppSettings["SmtpCorreoEmisor"];
                string password = ConfigurationManager.AppSettings["SmtpPassword"];
                string host = ConfigurationManager.AppSettings["SmtpHost"] ?? "smtp.gmail.com";
                int port = int.Parse(ConfigurationManager.AppSettings["SmtpPort"] ?? "587");

                if (string.IsNullOrEmpty(emisor) || string.IsNullOrEmpty(password))
                {
                    return false;
                }

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress(emisor, "CoopFácil Cooperativa Financiera");
                mail.To.Add(datos.CorreoCliente);
                mail.Subject = "Comprobante de " + datos.NombreServicio + " - N° " + datos.NumeroTransaccion;
                mail.IsBodyHtml = true;

                mail.Body = $@"
                <div style='font-family: Arial, sans-serif; color: #0F233D; max-width: 600px; margin: 0 auto; border: 1px solid #e2e8f0; border-radius: 12px; padding: 24px;'>
                    <h2 style='color: #10B981; margin-top: 0;'>¡Hola {datos.NombreCliente}!</h2>
                    <p>Confirmamos que tu solicitud o movimiento para <strong>{datos.NombreServicio}</strong> ha sido procesado con éxito.</p>
                    <div style='background-color: #f8fafc; padding: 16px; border-radius: 8px; margin: 20px 0;'>
                        <p style='margin: 4px 0;'><strong>N° Transacción:</strong> {datos.NumeroTransaccion}</p>
                        <p style='margin: 4px 0;'><strong>Monto:</strong> ${datos.Monto:N2} USD</p>
                        <p style='margin: 4px 0;'><strong>Fecha:</strong> {datos.FechaMovimiento:dd/MM/yyyy HH:mm:ss}</p>
                    </div>
                    <p>Adjunto a este correo encontrarás el comprobante en formato PDF.</p>
                    <hr style='border: none; border-top: 1px solid #e2e8f0; margin: 20px 0;' />
                    <p style='font-size: 11px; color: #64748b;'>CoopFácil © {DateTime.Now.Year} - Todos los derechos reservados.</p>
                </div>";

                if (pdfBytes != null && pdfBytes.Length > 0)
                {
                    MemoryStream streamPdf = new MemoryStream(pdfBytes);
                    Attachment adjunto = new Attachment(streamPdf, "Comprobante_" + datos.NumeroTransaccion + ".pdf", "application/pdf");
                    mail.Attachments.Add(adjunto);
                }

                SmtpClient smtp = new SmtpClient(host, port)
                {
                    Credentials = new NetworkCredential(emisor, password),
                    EnableSsl = true
                };

                smtp.Send(mail);
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
    }
}