using System;
using System.Configuration;
using System.IO;
using System.Net;
using System.Net.Mail;
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace CoopFacil.Helpers
{
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

    public static class ComprobanteServicioHelper
    {
        public static byte[] GenerarPdfComprobante(DatosComprobante datos)
        {
            using (MemoryStream ms = new MemoryStream())
            {
                Document doc = new Document(PageSize.A4, 36, 36, 36, 36);
                PdfWriter.GetInstance(doc, ms);
                doc.Open();

                // Colores Corporativos
                BaseColor colorVerde = new BaseColor(16, 185, 129); // Emerald-500
                BaseColor colorOscuro = new BaseColor(15, 35, 61);   // #0F233D

                // Fuentes
                Font fontTitulo = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 18, colorOscuro);
                Font fontSubtitulo = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 12, colorVerde);
                Font fontNormal = FontFactory.GetFont(FontFactory.HELVETICA, 10, BaseColor.BLACK);
                Font fontBold = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.BLACK);
                Font fontHeaderTabla = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 10, BaseColor.WHITE);

                // Encabezado
                Paragraph header = new Paragraph("COOPFACIL COOPERATIVA FINANCIERA", fontTitulo);
                header.Alignment = Element.ALIGN_CENTER;
                doc.Add(header);

                Paragraph sub = new Paragraph("Comprobante Oficial de Movimiento / Pre-Apertura", fontSubtitulo);
                sub.Alignment = Element.ALIGN_CENTER;
                sub.SpacingAfter = 20f;
                doc.Add(sub);

                // Tabla de Datos principales
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

                // Mensaje Final de Certificación
                Paragraph nota = new Paragraph("\nEste documento es un comprobante digital generado automáticamente por la plataforma CoopFácil. Consérvalo para tus registros personales.", FontFactory.GetFont(FontFactory.HELVETICA_ITALIC, 8, BaseColor.DARK_GRAY));
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
                    <p>Adjunto a este correo encontrarás el comprobante en formato **PDF**.</p>
                    <hr style='border: none; border-top: 1px solid #e2e8f0; margin: 20px 0;' />
                    <p style='font-size: 11px; color: #64748b;'>CoopFácil © {DateTime.Now.Year} - Todos los derechos reservados.</p>
                </div>";

                // Adjuntar el PDF generado en memoria
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