/* CoopFacil - mejoras de los formularios:
   mostrar/ocultar contraseña, indicador de seguridad y coincidencia (registro) y estado "Procesando..." al enviar. */
(function () {
    'use strict';

    // ---------- Mostrar u ocultar contraseña
    function agregarOjo(campo) {
        if (campo.dataset.ojo) return;
        campo.dataset.ojo = '1';

        var envoltura = document.createElement('div');
        envoltura.className = 'relative';
        campo.parentNode.insertBefore(envoltura, campo);
        envoltura.appendChild(campo);
        campo.classList.add('pr-12');

        var ojo = document.createElement('button');
        ojo.type = 'button';
        ojo.tabIndex = 0;
        ojo.setAttribute('aria-label', 'Mostrar contraseña');
        ojo.setAttribute('aria-pressed', 'false');
        ojo.className = 'absolute inset-y-0 right-0 px-4 flex items-center text-slate-400 hover:text-emerald-500 transition cursor-pointer';
        ojo.innerHTML = '<i class="fa-solid fa-eye" aria-hidden="true"></i>';
        ojo.addEventListener('click', function () {
            var visible = campo.type === 'password';
            campo.type = visible ? 'text' : 'password';
            ojo.setAttribute('aria-pressed', visible ? 'true' : 'false');
            ojo.setAttribute('aria-label', visible ? 'Ocultar contraseña' : 'Mostrar contraseña');
            ojo.firstElementChild.className = visible ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye';
            campo.focus();
        });
        envoltura.appendChild(ojo);
        return envoltura;
    }

    var clave = document.getElementById('txtPassword');
    var confirmar = document.getElementById('txtPasswordConfirm');
    var envClave = clave ? agregarOjo(clave) : null;
    var envConfirmar = confirmar ? agregarOjo(confirmar) : null;

    // ---------- Indicador de seguridad y coincidencia (solo en el registro)
    if (clave && confirmar && envClave && envConfirmar) {
        var panel = document.createElement('div');
        panel.className = 'mt-2';
        panel.innerHTML =
            '<div class="flex gap-1.5" aria-hidden="true">' +
            '<span class="h-1.5 flex-1 rounded-full bg-slate-200 dark:bg-slate-700 transition-colors"></span>'.repeat(4) +
            '</div>' +
            '<p class="mt-1.5 text-[11px] text-slate-500 dark:text-slate-400" id="cfFortaleza" aria-live="polite">Mínimo 8 caracteres. Combina mayúsculas, números y símbolos para mayor seguridad.</p>';
        envClave.insertAdjacentElement('afterend', panel);
        var barras = panel.querySelectorAll('span');
        var texto = panel.querySelector('#cfFortaleza');

        var coincide = document.createElement('p');
        coincide.className = 'mt-1.5 text-[11px] min-h-[1rem]';
        coincide.setAttribute('aria-live', 'polite');
        envConfirmar.insertAdjacentElement('afterend', coincide);

        var niveles = [
            { texto: 'Muy débil', color: 'bg-red-500', clase: 'text-red-500' },
            { texto: 'Débil', color: 'bg-orange-500', clase: 'text-orange-500' },
            { texto: 'Aceptable', color: 'bg-yellow-500', clase: 'text-yellow-600 dark:text-yellow-400' },
            { texto: 'Buena', color: 'bg-emerald-500', clase: 'text-emerald-600 dark:text-emerald-400' },
            { texto: 'Excelente', color: 'bg-emerald-500', clase: 'text-emerald-600 dark:text-emerald-400' }
        ];
        var coloresPosibles = ['bg-red-500', 'bg-orange-500', 'bg-yellow-500', 'bg-emerald-500', 'bg-slate-200', 'dark:bg-slate-700'];
        var clasesTexto = ['text-red-500', 'text-orange-500', 'text-yellow-600', 'dark:text-yellow-400', 'text-emerald-600', 'dark:text-emerald-400', 'text-slate-500', 'dark:text-slate-400'];

        function puntuar(v) {
            if (!v) return -1;
            var p = 0;
            if (v.length >= 8) p++;
            if (v.length >= 12) p++;
            if (/[a-z]/.test(v) && /[A-Z]/.test(v)) p++;
            if (/\d/.test(v)) p++;
            if (/[^A-Za-z0-9]/.test(v)) p++;
            if (v.length < 8) p = Math.min(p, 1);
            return Math.min(p, 4);
        }

        function pintarFortaleza() {
            var p = puntuar(clave.value);
            barras.forEach(function (b, i) {
                coloresPosibles.forEach(function (c) { c.split(' ').forEach(function (k) { b.classList.remove(k); }); });
                if (p >= 0 && i <= Math.max(p - 1, 0) && p >= 0) b.classList.add(niveles[p].color);
                else { b.classList.add('bg-slate-200'); b.classList.add('dark:bg-slate-700'); }
            });
            clasesTexto.forEach(function (c) { texto.classList.remove(c); });
            if (p < 0) {
                texto.textContent = 'Mínimo 8 caracteres. Combina mayúsculas, números y símbolos para mayor seguridad.';
                texto.classList.add('text-slate-500'); texto.classList.add('dark:text-slate-400');
            } else {
                texto.textContent = 'Seguridad: ' + niveles[p].texto + (clave.value.length < 8 ? ' (mínimo 8 caracteres)' : '');
                niveles[p].clase.split(' ').forEach(function (k) { texto.classList.add(k); });
            }
        }

        function pintarCoincidencia() {
            coincide.className = 'mt-1.5 text-[11px] min-h-[1rem]';
            if (!confirmar.value) { coincide.textContent = ''; return; }
            if (confirmar.value === clave.value) {
                coincide.textContent = '✓ Las contraseñas coinciden';
                coincide.classList.add('text-emerald-600'); coincide.classList.add('dark:text-emerald-400');
            } else {
                coincide.textContent = 'Las contraseñas no coinciden';
                coincide.classList.add('text-red-500');
            }
        }

        clave.addEventListener('input', function () { pintarFortaleza(); pintarCoincidencia(); });
        confirmar.addEventListener('input', pintarCoincidencia);
        pintarFortaleza();
        pintarCoincidencia();
    }

    // ---------- Estado "Procesando..." al enviar (sin deshabilitar el botón: así el servidor sabe cuál se pulsó)
    Array.prototype.forEach.call(document.querySelectorAll('form'), function (form) {
        var enviado = false;
        form.addEventListener('submit', function (ev) {
            if (enviado) { ev.preventDefault(); return; }
            var boton = ev.submitter;
            if (!boton || !/^(btnAcceder|btnRegistrar|btnTransferir|btnDepositar|btnEnviar)/.test(boton.name || '')) return;
            enviado = true;
            setTimeout(function () {
                boton.classList.add('opacity-70', 'cursor-wait');
                if (boton.tagName === 'INPUT') boton.value = 'Procesando…';
                else boton.innerHTML = '<i class="fa-solid fa-circle-notch fa-spin mr-2" aria-hidden="true"></i>Procesando…';
            }, 0);
        });
    });
    window.addEventListener('pageshow', function (ev) { if (ev.persisted) window.location.reload(); });
})();
