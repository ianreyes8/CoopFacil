<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Servicios.aspx.cs" Inherits="CoopFacil.Pages.Servicios" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Servicios Financieros - CoopFacil</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="bg-[#0B1A30] text-white font-sans antialiased min-h-screen flex flex-col justify-between">
    <form id="form1" runat="server" class="min-h-screen flex flex-col justify-between">
        
        <div>
            <!-- BARRA DE NAVEGACIÓN PRINCIPAL -->
            <header class="bg-[#0B1A30]/95 backdrop-blur-md border-b border-slate-800 sticky top-0 z-50 w-full px-6 sm:px-10 py-4 flex items-center justify-between gap-4">
                
                <!-- LOGO COOPFACIL + SALUDO SI HAY SESIÓN -->
                <div class="flex items-center gap-4">
                    <a href="../Index.aspx" class="flex items-center gap-3 group">
                        <div class="w-10 h-10 rounded-xl bg-emerald-600/20 border border-emerald-500/30 flex items-center justify-center text-emerald-400 text-xl shadow-inner group-hover:bg-emerald-600/30 transition">
                            <i class="fa-solid fa-users-gear"></i>
                        </div>
                        <div class="flex flex-col">
                            <span class="text-xl font-extrabold tracking-tight leading-none text-white">
                                Coop<span class="text-emerald-400">Facil</span>
                            </span>
                            <span class="text-[9px] font-bold tracking-widest text-slate-400 uppercase mt-1">
                                COOPERATIVA FINANCIERA
                            </span>
                        </div>
                    </a>

                    <!-- MENSAJE DE BIENVENIDA SI TIENE SESIÓN ACTIVA -->
                    <asp:Panel ID="pnlBienvenida" runat="server" Visible="false" CssClass="hidden lg:flex items-center gap-2 bg-[#0F233D] border border-emerald-500/40 px-3 py-1.5 rounded-xl shadow-lg">
                        <i class="fa-solid fa-circle-user text-emerald-400 text-base"></i>
                        <span class="text-xs font-bold text-white">
                            Bienvenido <asp:Literal ID="litBienvenida" runat="server"></asp:Literal>
                        </span>
                    </asp:Panel>
                </div>

                <!-- ENLACES DE NAVEGACIÓN (CENTRO) -->
                <nav class="hidden md:flex items-center gap-8 text-sm font-semibold">
                    <a href="QuienesSomos.aspx" class="text-slate-300 hover:text-emerald-400 transition">Quiénes Somos</a>
                    <a href="Servicios.aspx" class="text-emerald-400 font-bold border-b-2 border-emerald-400 pb-1">Servicios</a>
                    <a href="Transparencia.aspx" class="text-slate-300 hover:text-emerald-400 transition">Transparencia</a>
                    <a href="Contacto.aspx" class="text-slate-300 hover:text-emerald-400 transition">Contacto</a>
                </nav>

                <!-- CONTROLES DE SESIÓN (DERECHA) -->
                <div class="flex items-center gap-3">
                    <!-- BOTÓN CUANDO NO HAY SESIÓN -->
                    <asp:HyperLink ID="lnkIniciarSesion" runat="server" NavigateUrl="../Default.aspx" CssClass="bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs sm:text-sm px-5 py-2.5 rounded-lg transition flex items-center gap-2 shadow-lg shadow-blue-900/40">
                        <i class="fa-solid fa-right-to-bracket"></i> Iniciar Sesión
                    </asp:HyperLink>

                    <!-- BOTONES CUANDO HAY SESIÓN ACTIVA -->
                    <asp:LinkButton ID="btnPortalSocio" runat="server" OnClick="btnPortalSocio_Click" CssClass="bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs sm:text-sm px-5 py-2.5 rounded-lg transition flex items-center gap-2 shadow-lg shadow-emerald-900/40">
                        <i class="fa-solid fa-user-check"></i> Portal Socio
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnCerrarSesion" runat="server" OnClick="btnCerrarSesion_Click" CssClass="bg-[#0F233D] hover:bg-slate-700 border border-slate-600 text-white font-bold text-xs sm:text-sm px-4 py-2.5 rounded-lg transition flex items-center gap-2">
                        <i class="fa-solid fa-right-from-bracket"></i> Cerrar Sesión
                    </asp:LinkButton>
                </div>

            </header>

            <!-- CONTENIDO PRINCIPAL DE SERVICIOS -->
            <main class="max-w-7xl mx-auto px-6 py-10 flex flex-col gap-10 flex-grow w-full">
                
                <!-- TITULAR -->
                <div class="text-center max-w-3xl mx-auto flex flex-col gap-3">
                    <span class="text-xs font-bold uppercase tracking-wider text-emerald-400">PORTAFOLIO INTEGRAL</span>
                    <h1 class="text-3xl sm:text-4xl font-extrabold text-white tracking-tight">
                        Soluciones Financieras a tu Medida
                    </h1>
                    <p class="text-sm sm:text-base text-slate-300 leading-relaxed">
                        Diseñamos productos financieros pensados para impulsar tu crecimiento personal, familiar y empresarial con las mejores condiciones del mercado.
                    </p>
                </div>

                <!-- BARRA DE NAVEGACIÓN Y FILTROS -->
                <div class="flex flex-wrap justify-center gap-3 mb-10">
                    <button type="button" onclick="filtrarServicios('all', this)" class="btn-filtro active-filter px-5 py-2.5 rounded-full text-xs sm:text-sm font-bold transition shadow-md bg-emerald-600 text-white border border-emerald-500">
                        Todos los servicios
                    </button>
                    <button type="button" onclick="filtrarServicios('credito', this)" class="btn-filtro px-5 py-2.5 rounded-full text-xs sm:text-sm font-medium transition bg-[#0F233D] text-slate-300 hover:text-white border border-slate-700/80 hover:border-slate-500">
                        Crédito
                    </button>
                    <button type="button" onclick="filtrarServicios('ahorro', this)" class="btn-filtro px-5 py-2.5 rounded-full text-xs sm:text-sm font-medium transition bg-[#0F233D] text-slate-300 hover:text-white border border-slate-700/80 hover:border-slate-500">
                        Ahorro e Inversión
                    </button>
                    <button type="button" onclick="filtrarServicios('valor', this)" class="btn-filtro px-5 py-2.5 rounded-full text-xs sm:text-sm font-medium transition bg-[#0F233D] text-slate-300 hover:text-white border border-slate-700/80 hover:border-slate-500">
                        Valor Agregado
                    </button>
                </div>

                <!-- TARJETAS DE SERVICIOS -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    
                    <!-- 1. CUENTA DE AHORRO -->
                    <div class="card-servicio cat-ahorro bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col justify-between hover:border-emerald-500 transition">
                        <div>
                            <div class="w-12 h-12 rounded-xl bg-emerald-500/20 border border-emerald-400/40 flex items-center justify-center mb-4">
                                <i class="fa-solid fa-wallet text-emerald-400 text-2xl"></i>
                            </div>
                            <h3 class="text-xl font-bold text-white mb-2">Cuenta de Ahorro</h3>
                            <p class="text-slate-300 text-xs sm:text-sm leading-relaxed mb-4">
                                Cuenta principal del socio con rendimiento inmediato, sin comisiones de mantenimiento y disponibilidad 24/7.
                            </p>
                            <ul class="text-xs text-slate-300 space-y-2 mb-6">
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-emerald-400"></i> Tasa preferencial 10% EA</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-emerald-400"></i> Sin cuota de manejo</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-emerald-400"></i> Tarjeta débito incluida</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-emerald-400"></i> Alertas en tiempo real</li>
                            </ul>
                        </div>
                        <a href="CuentaAhorro.aspx" class="text-emerald-400 font-bold text-xs sm:text-sm hover:underline flex items-center gap-1">
                            Ver condiciones <i class="fa-solid fa-arrow-right text-xs"></i>
                        </a>
                    </div>

                    <!-- 2. AHORRO PROGRAMADO -->
                    <div class="card-servicio cat-ahorro bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col justify-between hover:border-emerald-500 transition">
                        <div>
                            <div class="w-12 h-12 rounded-xl bg-emerald-500/20 border border-emerald-400/40 flex items-center justify-center mb-4">
                                <i class="fa-solid fa-piggy-bank text-emerald-400 text-2xl"></i>
                            </div>
                            <h3 class="text-xl font-bold text-white mb-2">Ahorro Programado</h3>
                            <p class="text-slate-300 text-xs sm:text-sm leading-relaxed mb-4">
                                Planifique sus metas de mediano y largo plazo con depósitos periódicos automáticos y tasas preferenciales.
                            </p>
                            <ul class="text-xs text-slate-300 space-y-2 mb-6">
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-emerald-400"></i> Tasa escalonada hasta 8.0% EA</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-emerald-400"></i> Plazos flexibles de 6 a 36 meses</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-emerald-400"></i> Débito automático programable</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-emerald-400"></i> Cero costo de apertura</li>
                            </ul>
                        </div>
                        <a href="AhorroProgramado.aspx" class="text-emerald-400 font-bold text-xs sm:text-sm hover:underline flex items-center gap-1">
                            Abrir plan <i class="fa-solid fa-arrow-right text-xs"></i>
                        </a>
                    </div>

                    <!-- 3. CRÉDITO PERSONAL -->
                    <div class="card-servicio cat-credito bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col justify-between hover:border-blue-500 transition">
                        <div>
                            <div class="w-12 h-12 rounded-xl bg-blue-500/20 border border-blue-400/40 flex items-center justify-center mb-4">
                                <i class="fa-solid fa-hand-holding-dollar text-blue-400 text-2xl"></i>
                            </div>
                            <h3 class="text-xl font-bold text-white mb-2">Crédito Personal</h3>
                            <p class="text-slate-300 text-xs sm:text-sm leading-relaxed mb-4">
                                Financiamiento de libre inversión para proyectos, imprevistos o consolidación de deudas con desembolso rápido.
                            </p>
                            <ul class="text-xs text-slate-300 space-y-2 mb-6">
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-blue-400"></i> Tasa competitiva del 10% EA</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-blue-400"></i> Plazos extendidos hasta 120 meses</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-blue-400"></i> Dictamen y pre-aprobación en línea</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-blue-400"></i> Sin penalidad por abono a capital</li>
                            </ul>
                        </div>
                        <a href="CreditoPersonal.aspx" class="text-blue-400 font-bold text-xs sm:text-sm hover:underline flex items-center gap-1">
                            Solicitar crédito <i class="fa-solid fa-arrow-right text-xs"></i>
                        </a>
                    </div>

                    <!-- 4. CRÉDITO HIPOTECARIO (ENLACE CORREGIDO A CreditoHipotecario.aspx) -->
                    <div class="card-servicio cat-credito bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col justify-between hover:border-blue-500 transition">
                        <div>
                            <div class="w-12 h-12 rounded-xl bg-blue-500/20 border border-blue-400/40 flex items-center justify-center mb-4">
                                <i class="fa-solid fa-house-chimney text-blue-400 text-2xl"></i>
                            </div>
                            <h3 class="text-xl font-bold text-white mb-2">Crédito Hipotecario</h3>
                            <p class="text-slate-300 text-xs sm:text-sm leading-relaxed mb-4">
                                Financiamiento para compra o remodelación de inmueble con las mejores tasas del mercado y agendamiento de citas.
                            </p>
                            <ul class="text-xs text-slate-300 space-y-2 mb-6">
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-blue-400"></i> Tasa preferencial desde 7.5% EA</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-blue-400"></i> Plazo máximo de hasta 20 años</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-blue-400"></i> Enganche / Prima desde el 10%</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-blue-400"></i> Asesoría especializada personalizada</li>
                            </ul>
                        </div>
                        <a href="CreditoHipotecario.aspx" class="text-blue-400 font-bold text-xs sm:text-sm hover:underline flex items-center gap-1">
                            Simular crédito <i class="fa-solid fa-arrow-right text-xs"></i>
                        </a>
                    </div>

                    <!-- 5. CRÉDITO VEHICULAR -->
                    <div class="card-servicio cat-credito bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col justify-between hover:border-blue-500 transition">
                        <div>
                            <div class="w-12 h-12 rounded-xl bg-blue-500/20 border border-blue-400/40 flex items-center justify-center mb-4">
                                <i class="fa-solid fa-car text-blue-400 text-2xl"></i>
                            </div>
                            <h3 class="text-xl font-bold text-white mb-2">Crédito Vehicular</h3>
                            <p class="text-slate-300 text-xs sm:text-sm leading-relaxed mb-4">
                                Adquiera su vehículo nuevo o usado con una financiación de hasta el 80% del valor comercial y rápida aprobación.
                            </p>
                            <ul class="text-xs text-slate-300 space-y-2 mb-6">
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-blue-400"></i> Tasa desde 9.8% EA</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-blue-400"></i> Hasta 60 meses de plazo</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-blue-400"></i> Aplica para vehículo nuevo o usado</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-blue-400"></i> Opción de seguro vehicular integrado</li>
                            </ul>
                        </div>
                        <a href="CreditoVehicular.aspx" class="text-blue-400 font-bold text-xs sm:text-sm hover:underline flex items-center gap-1">
                            Cotizar vehículo <i class="fa-solid fa-arrow-right text-xs"></i>
                        </a>
                    </div>

                    <!-- 6. EDUCACIÓN FINANCIERA -->
                    <div class="card-servicio cat-valor bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col justify-between hover:border-amber-400 transition">
                        <div>
                            <div class="w-12 h-12 rounded-xl bg-amber-500/20 border border-amber-400/40 flex items-center justify-center mb-4">
                                <i class="fa-solid fa-graduation-cap text-amber-400 text-2xl"></i>
                            </div>
                            <h3 class="text-xl font-bold text-white mb-2">Educación Financiera</h3>
                            <p class="text-slate-300 text-xs sm:text-sm leading-relaxed mb-4">
                                Talleres, asesorías personalizadas y programas gratuitos para aprender a administrar su presupuesto e inversiones.
                            </p>
                            <ul class="text-xs text-slate-300 space-y-2 mb-6">
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-amber-400"></i> Capacitaciones 100% gratuitas</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-amber-400"></i> Asesoría en elaboración de presupuesto</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-amber-400"></i> Webinars y módulos interactivos</li>
                                <li class="flex items-center gap-2"><i class="fa-solid fa-check text-amber-400"></i> Certificación de educación financiera</li>
                            </ul>
                        </div>
                        <a href="EducacionFinanciera.aspx" class="text-amber-400 font-bold text-xs sm:text-sm hover:underline flex items-center gap-1">
                            Conocer programas <i class="fa-solid fa-arrow-right text-xs"></i>
                        </a>
                    </div>

                </div>

            </main>
        </div>

        <!-- PIE DE PÁGINA -->
        <footer class="bg-[#0F233D] border-t-2 border-slate-700/80 text-slate-400 text-xs text-center py-6 mt-auto">
            <p>© 2026 CoopFacil. Todos los derechos reservados.</p>
        </footer>

    </form>

    <!-- SCRIPT INTERACTIVO DE FILTRADO -->
    <script>
        // @ts-nocheck
        function filtrarServicios(categoria, boton) {
            // Actualizar estado activo de los botones
            const botones = document.querySelectorAll('.btn-filtro');
            botones.forEach(btn => {
                btn.classList.remove('bg-emerald-600', 'text-white', 'border-emerald-500', 'font-bold');
                btn.classList.add('bg-[#0F233D]', 'text-slate-300', 'border-slate-700/80', 'font-medium');
            });

            boton.classList.remove('bg-[#0F233D]', 'text-slate-300', 'border-slate-700/80', 'font-medium');
            boton.classList.add('bg-emerald-600', 'text-white', 'border-emerald-500', 'font-bold');

            // Filtrar las tarjetas de servicios
            const tarjetas = document.querySelectorAll('.card-servicio');
            tarjetas.forEach(card => {
                const element = /** @type {HTMLElement} */ (card);
                if (categoria === 'all') {
                    element.style.display = 'flex';
                } else if (element.classList.contains('cat-' + categoria)) {
                    element.style.display = 'flex';
                } else {
                    element.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>