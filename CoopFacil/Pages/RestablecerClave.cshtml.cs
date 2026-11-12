using System;
using CoopFacil.Helpers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace CoopFacil.Pages
{
    /// <summary>Paso 2 de la recuperación: elegir la nueva contraseña con el enlace recibido por correo.</summary>
    public class RestablecerClaveModel : PageModel
    {
        [BindProperty(SupportsGet = true)] public string Token { get; set; }
        [BindProperty] public string Clave { get; set; }
        [BindProperty] public string Confirmar { get; set; }

        public bool TokenValido { get; private set; }
        public bool Listo { get; private set; }
        public string Error { get; private set; }

        public void OnGet()
        {
            TokenValido = RecuperacionClave.TokenValido(Token);
        }

        public IActionResult OnPost()
        {
            TokenValido = RecuperacionClave.TokenValido(Token);
            if (!TokenValido) return Page();

            if (string.IsNullOrEmpty(Clave) || Clave.Length < 8)
            {
                Error = "La contraseña debe tener un mínimo de 8 caracteres.";
                return Page();
            }
            if (Clave.Length > 100)
            {
                Error = "La contraseña es demasiado larga.";
                return Page();
            }
            if (Clave != Confirmar)
            {
                Error = "Las contraseñas no coinciden.";
                return Page();
            }

            try
            {
                if (RecuperacionClave.Restablecer(Token, Clave))
                {
                    Listo = true;
                    return Page();
                }
                TokenValido = false;
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("[Recuperación] " + ex.GetType().Name);
                Error = "No pudimos cambiar la contraseña en este momento. Inténtalo de nuevo en unos minutos.";
            }
            return Page();
        }
    }
}
