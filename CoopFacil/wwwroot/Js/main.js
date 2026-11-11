// Funciones JavaScript para interactividad en la interfaz
function toggleModalPortalSocio(mostrar) {
    var modal = document.getElementById('modalPortalSocio');
    if (modal) {
        if (mostrar) {
            modal.classList.remove('hidden');
        } else {
            modal.classList.add('hidden');
        }
    }
}