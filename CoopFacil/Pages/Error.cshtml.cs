using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace CoopFacil.Pages
{
    [IgnoreAntiforgeryToken]
    public class ErrorModel : PageModel
    {
        public int Codigo { get; private set; } = 500;
        public string Titulo { get; private set; }
        public string Mensaje { get; private set; }

        public void OnGet() => Preparar();
        public void OnPost() => Preparar();

        private void Preparar()
        {
            int codigo = Response.StatusCode;
            if (int.TryParse(Request.Query["codigo"], out int pedido) && pedido >= 400 && pedido < 600) codigo = pedido;
            if (codigo < 400) codigo = 500;
            Codigo = codigo;
            Response.StatusCode = codigo;

            if (codigo == 404)
            {
                Titulo = "No encontramos esta página";
                Mensaje = "Es posible que el enlace esté incompleto o que la página ya no exista. Volvamos a un lugar seguro.";
            }
            else if (codigo == 403 || codigo == 401)
            {
                Titulo = "No tienes acceso a esta página";
                Mensaje = "Inicia sesión con tu cuenta de socio para continuar.";
            }
            else if (codigo >= 500)
            {
                Titulo = "Algo salió mal de nuestro lado";
                Mensaje = "Ya quedó registrado y lo estamos revisando. Inténtalo de nuevo en unos minutos.";
            }
            else
            {
                Titulo = "No pudimos completar la solicitud";
                Mensaje = "Revisa el enlace o regresa al inicio para intentarlo de nuevo.";
            }
        }
    }
}
