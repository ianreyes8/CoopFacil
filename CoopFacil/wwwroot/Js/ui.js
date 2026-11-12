/* CoopFacil - comportamiento común de la interfaz (menú móvil, animaciones, formularios de acceso) */
(function () {
    'use strict';

    // ----- Encabezado: sombra al desplazarse
    var cabecera = document.querySelector('.cf-header');
    function alDesplazar() { if (cabecera) cabecera.classList.toggle('cf-scrolled', window.scrollY > 8); }
    window.addEventListener('scroll', alDesplazar, { passive: true });
    alDesplazar();

    // ----- Menú móvil
    var boton = document.getElementById('btnMenuMovil');
    var menu = document.getElementById('menuMovil');
    function cerrarMenu() {
        if (!boton || !menu) return;
        boton.setAttribute('aria-expanded', 'false');
        menu.classList.remove('abierto');
    }
    if (boton && menu) {
        boton.addEventListener('click', function (ev) {
            ev.stopPropagation();
            var abierto = boton.getAttribute('aria-expanded') === 'true';
            boton.setAttribute('aria-expanded', abierto ? 'false' : 'true');
            menu.classList.toggle('abierto', !abierto);
        });
        document.addEventListener('click', function (ev) { if (!menu.contains(ev.target) && !boton.contains(ev.target)) cerrarMenu(); });
        document.addEventListener('keydown', function (ev) { if (ev.key === 'Escape') cerrarMenu(); });
        window.addEventListener('resize', function () { if (window.innerWidth >= 1024) cerrarMenu(); });
    }

    // ----- Aparición suave de los bloques marcados con .reveal
    var bloques = document.querySelectorAll('.reveal');
    if ('IntersectionObserver' in window && bloques.length) {
        var obs = new IntersectionObserver(function (entradas) {
            entradas.forEach(function (e) { if (e.isIntersecting) { e.target.classList.add('visible'); obs.unobserve(e.target); } });
        }, { threshold: 0.12, rootMargin: '0px 0px -40px 0px' });
        bloques.forEach(function (b) { obs.observe(b); });
    } else {
        bloques.forEach(function (b) { b.classList.add('visible'); });
    }

    // ----- Mostrar u ocultar contraseña: <button data-ver-clave="idDelCampo">
    document.querySelectorAll('[data-ver-clave]').forEach(function (b) {
        b.addEventListener('click', function () {
            var campo = document.getElementById(b.getAttribute('data-ver-clave'));
            if (!campo) return;
            var oculto = campo.type === 'password';
            campo.type = oculto ? 'text' : 'password';
            var icono = b.querySelector('i');
            if (icono) icono.className = oculto ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye';
            b.setAttribute('aria-label', oculto ? 'Ocultar contraseña' : 'Mostrar contraseña');
            campo.focus();
        });
    });

    // ----- Indicador de fuerza de contraseña: <div class="cf-fuerza" data-para="idDelCampo" data-texto="idDelTexto">
    document.querySelectorAll('.cf-fuerza').forEach(function (barra) {
        var campo = document.getElementById(barra.getAttribute('data-para'));
        var texto = document.getElementById(barra.getAttribute('data-texto'));
        if (!campo) return;
        var etiquetas = ['', 'Débil', 'Aceptable', 'Buena', 'Excelente'];
        function evaluar() {
            var v = campo.value, puntos = 0;
            if (v.length >= 8) puntos++;
            if (/[a-z]/.test(v) && /[A-Z]/.test(v)) puntos++;
            if (/\d/.test(v)) puntos++;
            if (/[^A-Za-z0-9]/.test(v) || v.length >= 14) puntos++;
            if (!v.length) puntos = 0;
            barra.setAttribute('data-nivel', puntos);
            if (texto) texto.textContent = v.length ? 'Seguridad: ' + etiquetas[puntos] : 'Mínimo 8 caracteres. Mezcla mayúsculas, números y símbolos.';
        }
        campo.addEventListener('input', evaluar);
        evaluar();
    });

    // ----- Coincidencia de contraseñas: <input data-igual-a="idDelOtroCampo"> con <p data-aviso-igual="idDeEsteCampo">
    document.querySelectorAll('[data-igual-a]').forEach(function (campo) {
        var otro = document.getElementById(campo.getAttribute('data-igual-a'));
        var aviso = document.querySelector('[data-aviso-igual="' + campo.id + '"]');
        if (!otro || !aviso) return;
        function comparar() {
            if (!campo.value) { aviso.textContent = ''; return; }
            var igual = campo.value === otro.value;
            aviso.textContent = igual ? 'Las contraseñas coinciden' : 'Las contraseñas no coinciden';
            aviso.className = 'mt-1.5 text-xs font-medium ' + (igual ? 'text-emerald-500' : 'text-red-400');
        }
        campo.addEventListener('input', comparar);
        otro.addEventListener('input', comparar);
    });

    // ----- Estado "Procesando..." al enviar. No se desactiva el botón: un botón desactivado no se envía
    //       con el formulario y la página no sabría cuál se pulsó.
    document.querySelectorAll('form').forEach(function (f) {
        f.addEventListener('submit', function (ev) {
            if (f.dataset.enviando === '1') { ev.preventDefault(); return; }
            var b = ev.submitter || f.querySelector('[data-cargando]');
            if (b && b.hasAttribute('data-cargando')) {
                f.dataset.enviando = '1';
                b.classList.add('btn-cargando');
                setTimeout(function () { f.dataset.enviando = '0'; b.classList.remove('btn-cargando'); }, 8000);
            }
        });
    });
})();
