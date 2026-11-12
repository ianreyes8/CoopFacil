// Efectos de las páginas interiores: aparición al scroll, barra de progreso y cabecera con sombra.
(function () {
    'use strict';
    var raiz = document.documentElement;
    var reducir = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    document.body.classList.add('cf-ambiente');

    // Barra de progreso de lectura
    var barra = document.createElement('div');
    barra.className = 'cf-progreso';
    barra.setAttribute('aria-hidden', 'true');
    document.body.appendChild(barra);

    var cabecera = document.querySelector('header');
    var pendiente = false;
    function actualizar() {
        pendiente = false;
        var alto = document.documentElement.scrollHeight - window.innerHeight;
        barra.style.transform = 'scaleX(' + (alto > 0 ? Math.min(window.scrollY / alto, 1) : 0) + ')';
        if (cabecera) cabecera.classList.toggle('cf-scroll', window.scrollY > 8);
    }
    window.addEventListener('scroll', function () { if (!pendiente) { pendiente = true; requestAnimationFrame(actualizar); } }, { passive: true });
    actualizar();

    // Aparición escalonada de bloques
    if (reducir || !('IntersectionObserver' in window)) return;
    var main = document.querySelector('main');
    if (!main) return;
    var objetivos = [];
    Array.prototype.forEach.call(main.children, function (hijo) {
        // secciones y tarjetas grandes: se revelan; los hijos con rejilla se revelan uno a uno
        var rejilla = hijo.matches('[class*="grid"]') ? hijo : null;
        if (rejilla) { Array.prototype.forEach.call(hijo.children, function (c, i) { objetivos.push([c, i]); }); }
        else {
            objetivos.push([hijo, 0]);
            var interior = hijo.querySelectorAll(':scope > [class*="grid"] > *');
            Array.prototype.forEach.call(interior, function (c, i) { objetivos.push([c, i]); });
        }
    });
    raiz.classList.add('cf-js');
    var obs = new IntersectionObserver(function (entradas) {
        entradas.forEach(function (e) { if (e.isIntersecting) { var t = e.target; t.classList.add('cf-vis'); obs.unobserve(t); setTimeout(function () { t.classList.remove('cf-rev', 'cf-vis'); t.style.removeProperty('--cf-d'); }, 1300); } });
    }, { threshold: 0.08, rootMargin: '0px 0px -30px 0px' });
    objetivos.forEach(function (par) {
        var el = par[0];
        if (el.classList.contains('cf-rev')) return;
        el.classList.add('cf-rev');
        el.style.setProperty('--cf-d', Math.min(par[1], 5) * 0.09 + 's');
        obs.observe(el);
    });
    // Respaldo: si algo falla, a los 2.5 s todo queda visible
    setTimeout(function () { document.querySelectorAll('.cf-rev').forEach(function (e) { e.classList.add('cf-vis'); }); }, 2500);
})();
