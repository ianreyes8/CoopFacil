/* CoopFacil - menú de navegación para pantallas pequeñas.
   Toma los enlaces del menú de escritorio (header nav) y los muestra en un panel desplegable con botón de hamburguesa. */
(function () {
    'use strict';

    var cabecera = document.querySelector('header');
    var nav = cabecera && cabecera.querySelector('nav');
    var tema = document.getElementById('themeToggleBtn');
    if (!nav || !tema || !tema.parentElement) return;

    // Botón de hamburguesa (junto a los demás botones del encabezado)
    var boton = document.createElement('button');
    boton.type = 'button';
    boton.id = 'menuMovilBtn';
    boton.setAttribute('aria-label', 'Abrir menú de navegación');
    boton.setAttribute('aria-expanded', 'false');
    boton.setAttribute('aria-controls', 'menuMovilPanel');
    boton.className = 'lg:hidden w-10 h-10 rounded-xl bg-slate-100 dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-200 flex items-center justify-center hover:bg-slate-200 dark:hover:bg-slate-800 transition cursor-pointer';
    boton.innerHTML = '<i class="fa-solid fa-bars" aria-hidden="true"></i>';
    tema.parentElement.appendChild(boton);

    // Panel desplegable con los mismos enlaces
    var panel = document.createElement('div');
    panel.id = 'menuMovilPanel';
    panel.className = 'lg:hidden fixed inset-x-0 z-40 overflow-hidden bg-white/95 dark:bg-[#0B1A30]/95 backdrop-blur-md border-b border-slate-200 dark:border-slate-800 shadow-2xl opacity-0';
    panel.style.maxHeight = '0px';
    panel.setAttribute('aria-hidden', 'true');

    var lista = document.createElement('nav');
    lista.setAttribute('aria-label', 'Menú principal');
    lista.className = 'flex flex-col gap-1 p-4';

    Array.prototype.forEach.call(nav.querySelectorAll('a'), function (origen) {
        var activo = /font-bold/.test(origen.className);
        var enlace = document.createElement('a');
        enlace.href = origen.getAttribute('href');
        enlace.textContent = origen.textContent.trim();
        enlace.className = 'flex items-center justify-between px-4 py-3.5 rounded-xl text-base font-semibold transition ' +
            (activo
                ? 'bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 border border-emerald-500/30'
                : 'text-slate-700 dark:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 border border-transparent');
        if (activo) enlace.setAttribute('aria-current', 'page');
        var flecha = document.createElement('i');
        flecha.className = 'fa-solid fa-chevron-right text-xs opacity-60';
        flecha.setAttribute('aria-hidden', 'true');
        enlace.appendChild(flecha);
        lista.appendChild(enlace);
    });

    panel.appendChild(lista);
    document.body.appendChild(panel);

    function posicionar() { panel.style.top = cabecera.getBoundingClientRect().bottom + 'px'; }

    function abrir() {
        posicionar();
        panel.style.maxHeight = panel.scrollHeight + 'px';
        panel.classList.remove('opacity-0');
        panel.setAttribute('aria-hidden', 'false');
        boton.setAttribute('aria-expanded', 'true');
        boton.setAttribute('aria-label', 'Cerrar menú de navegación');
        boton.firstElementChild.className = 'fa-solid fa-xmark';
    }

    function cerrar() {
        panel.style.maxHeight = '0px';
        panel.classList.add('opacity-0');
        panel.setAttribute('aria-hidden', 'true');
        boton.setAttribute('aria-expanded', 'false');
        boton.setAttribute('aria-label', 'Abrir menú de navegación');
        boton.firstElementChild.className = 'fa-solid fa-bars';
    }

    boton.addEventListener('click', function (ev) {
        ev.stopPropagation();
        if (boton.getAttribute('aria-expanded') === 'true') cerrar(); else abrir();
    });
    document.addEventListener('click', function (ev) {
        if (!panel.contains(ev.target) && !boton.contains(ev.target)) cerrar();
    });
    document.addEventListener('keydown', function (ev) { if (ev.key === 'Escape') cerrar(); });
    window.addEventListener('resize', function () { if (window.innerWidth >= 1024) cerrar(); else posicionar(); });
    window.addEventListener('scroll', function () { if (boton.getAttribute('aria-expanded') === 'true') posicionar(); }, { passive: true });
})();
