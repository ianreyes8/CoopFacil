<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="CoopFacil.Index" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" class="dark">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Inicio - CoopFacil Cooperativa Financiera</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        coop: {
                            darkBg: '#0B1A30',
                            darkCard: '#0F233D',
                            emerald: '#10B981',
                            blue: '#3B82F6'
                        }
                    }
                }
            }
        }
    </script>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <script>
    (function () {
        const savedTheme = localStorage.getItem('coopfacil-theme');
        if (savedTheme === 'light') {
            document.documentElement.classList.remove('dark');
        } else {
            document.documentElement.classList.add('dark');
        }
    })();
</script>
</head>
<body class="bg-slate-50 dark:bg-[#0B1A30] text-slate-800 dark:text-slate-100 font-sans antialiased min-h-screen flex flex-col justify-between transition-colors duration-300">
    <form id="form1" runat="server" autocomplete="off" class="min-h-screen flex flex-col justify-between">
        
        <div>
            <!-- 1. BARRA DE NAVEGACIÓN SUPERIOR (STICKY) -->
            <header class="bg-white/90 dark:bg-[#0B1A30]/90 backdrop-blur-md border-b border-slate-200 dark:border-slate-800 sticky top-0 z-50 w-full px-4 sm:px-8 py-3.5 flex items-center justify-between gap-4 transition-colors duration-300">
                
                <div class="flex items-center gap-4">
                    <a href="Index.aspx" class="flex items-center gap-3 group">
                        <div class="w-10 h-10 rounded-xl bg-emerald-500/10 dark:bg-emerald-600/20 border border-emerald-500/30 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-xl shadow-inner group-hover:scale-105 transition-transform">
                            <i class="fa-solid fa-users-gear"></i>
                        </div>
                        <div class="flex flex-col">
                            <span class="text-xl font-extrabold tracking-tight leading-none text-slate-900 dark:text-white">
                                Coop<span class="text-emerald-600 dark:text-emerald-400">Facil</span>
                            </span>
                            <span class="text-[9px] font-bold tracking-widest text-slate-500 dark:text-slate-400 uppercase mt-1">
                                COOPERATIVA FINANCIERA
                            </span>
                        </div>
                    </a>

                    <asp:Panel ID="pnlBienvenida" runat="server" Visible="false" CssClass="hidden lg:flex items-center gap-2 bg-slate-100 dark:bg-[#0F233D] border border-emerald-500/40 px-3.5 py-1.5 rounded-xl shadow-sm">
                        <i class="fa-solid fa-circle-user text-emerald-600 dark:text-emerald-400 text-base"></i>
                        <span class="text-xs font-bold text-slate-700 dark:text-slate-200">
                            Bienvenido <asp:Literal ID="litBienvenida" runat="server"></asp:Literal>
                        </span>
                    </asp:Panel>
                </div>

                <nav class="hidden md:flex items-center gap-8 text-sm font-semibold">
                    <a href="Index.aspx" class="text-emerald-600 dark:text-emerald-400 font-bold border-b-2 border-emerald-600 dark:border-emerald-400 pb-1">Inicio</a>
                    <a href="Pages/QuienesSomos.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition pb-1 border-b-2 border-transparent">Quiénes Somos</a>
                    <a href="Pages/Servicios.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition pb-1 border-b-2 border-transparent">Servicios</a>
                    <a href="Pages/Transparencia.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition pb-1 border-b-2 border-transparent">Transparencia</a>
                    <a href="Pages/Contacto.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition pb-1 border-b-2 border-transparent">Contacto</a>
                </nav>

                <div class="flex items-center gap-2.5">
                    
                    <button type="button" onclick="toggleTheme()" id="themeToggleBtn" title="Cambiar Tema" class="w-10 h-10 rounded-xl bg-slate-100 dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-amber-400 hover:bg-slate-200 dark:hover:bg-slate-800 transition flex items-center justify-center text-base shadow-sm">
                        <i id="themeIconSun" class="fa-solid fa-sun hidden"></i>
                        <i id="themeIconMoon" class="fa-solid fa-moon"></i>
                    </button>

                    <asp:HyperLink ID="lnkIniciarSesion" runat="server" NavigateUrl="Default.aspx" CssClass="bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs sm:text-sm px-4 sm:px-5 py-2.5 rounded-xl transition flex items-center gap-2 shadow-lg shadow-blue-500/20">
                        <i class="fa-solid fa-right-to-bracket"></i> Iniciar Sesión
                    </asp:HyperLink>

                    <asp:LinkButton ID="btnCerrarSesion" runat="server" OnClick="btnCerrarSesion_Click" Visible="false" CssClass="bg-slate-100 dark:bg-[#0F233D] hover:bg-red-500/10 border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-slate-200 hover:text-red-600 dark:hover:text-red-400 font-bold text-xs sm:text-sm px-4 py-2.5 rounded-xl transition flex items-center gap-2">
                        <i class="fa-solid fa-right-from-bracket"></i> Cerrar Sesión
                    </asp:LinkButton>

                </div>

            </header>

            <!-- 2. DASHBOARD / RESUMEN FINANCIERO DEL SOCIO (ADAPTABLE A TEMA Y CON TARJETAS INTERACTIVAS) -->
            <asp:Panel ID="pnlResumenSocio" runat="server" Visible="false" CssClass="max-w-7xl mx-auto px-6 pt-8 pb-4">
                <div class="bg-slate-100 dark:bg-[#0F233D] border border-slate-200 dark:border-emerald-500/40 rounded-3xl p-6 sm:p-8 shadow-sm dark:shadow-2xl relative overflow-hidden transition-colors duration-300">
                    
                    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-200 dark:border-slate-700/60 pb-6 mb-6">
                        <div class="flex items-center gap-4">
                            <div class="w-12 h-12 rounded-2xl bg-emerald-500/10 dark:bg-emerald-500/20 border border-emerald-500/30 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-2xl shadow-inner">
                                <i class="fa-solid fa-id-card"></i>
                            </div>
                            <div>
                                <span class="text-xs font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-widest block">BANCA EN LÍNEA · RESUMEN DE CUENTAS</span>
                                <h2 class="text-xl sm:text-2xl font-black text-slate-900 dark:text-white">
                                    <asp:Literal ID="litNombreSocio" runat="server"></asp:Literal>
                                </h2>
                            </div>
                        </div>
                        <div class="bg-white dark:bg-[#071322] border border-slate-200 dark:border-slate-700 px-4 py-2 rounded-xl flex items-center gap-2 w-fit shadow-sm">
                            <i class="fa-solid fa-hashtag text-emerald-600 dark:text-emerald-400 text-xs"></i>
                            <span class="text-xs font-extrabold text-slate-700 dark:text-slate-300">
                                <asp:Literal ID="litNumeroSocio" runat="server"></asp:Literal>
                            </span>
                        </div>
                    </div>

                    <!-- TARJETAS DE SALDOS REALES INTERACTIVAS -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        
                        <!-- CUENTA DE AHORROS -->
                        <a href="Pages/CuentaAhorro.aspx" class="group bg-white dark:bg-[#071322]/80 border border-slate-200 dark:border-slate-700/80 hover:border-emerald-500 dark:hover:border-emerald-400 rounded-2xl p-5 flex flex-col justify-between gap-3 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all duration-300 cursor-pointer">
                            <div class="flex items-center justify-between">
                                <span class="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase group-hover:text-emerald-600 dark:group-hover:text-emerald-400 transition">Cuenta Ahorro Libre</span>
                                <div class="w-9 h-9 rounded-xl bg-emerald-500/10 dark:bg-emerald-500/20 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-base group-hover:scale-110 transition">
                                    <i class="fa-solid fa-wallet"></i>
                                </div>
                            </div>
                            <div>
                                <span class="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white tracking-tight block">
                                    <asp:Literal ID="litSaldo" runat="server" Text="$0.00"></asp:Literal>
                                </span>
                                <span class="text-[10px] text-emerald-600 dark:text-emerald-400 block mt-1 font-semibold">✓ Saldo disponible acumulado</span>
                            </div>
                        </a>

                        <!-- DEPÓSITO A PLAZO / CDT -->
                        <a href="Pages/AhorroProgramado.aspx" class="group bg-white dark:bg-[#071322]/80 border border-slate-200 dark:border-slate-700/80 hover:border-blue-500 dark:hover:border-blue-400 rounded-2xl p-5 flex flex-col justify-between gap-3 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all duration-300 cursor-pointer">
                            <div class="flex items-center justify-between">
                                <span class="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase group-hover:text-blue-600 dark:group-hover:text-blue-400 transition">Inversión a Plazo (CDT)</span>
                                <div class="w-9 h-9 rounded-xl bg-blue-500/10 dark:bg-blue-500/20 text-blue-600 dark:text-blue-400 flex items-center justify-center text-base group-hover:scale-110 transition">
                                    <i class="fa-solid fa-piggy-bank"></i>
                                </div>
                            </div>
                            <div>
                                <span class="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white tracking-tight block">
                                    <asp:Literal ID="litCDT" runat="server" Text="$0.00"></asp:Literal>
                                </span>
                                <span class="text-[10px] text-blue-600 dark:text-blue-400 block mt-1 font-semibold">★ Rentabilidad preferencial activada</span>
                            </div>
                        </a>

                        <!-- PRÉSTAMOS ACTIVOS -->
                        <a href="Pages/CreditoPersonal.aspx" class="group bg-white dark:bg-[#071322]/80 border border-slate-200 dark:border-slate-700/80 hover:border-amber-500 dark:hover:border-amber-400 rounded-2xl p-5 flex flex-col justify-between gap-3 shadow-sm hover:shadow-xl hover:-translate-y-1 transition-all duration-300 cursor-pointer">
                            <div class="flex items-center justify-between">
                                <span class="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase group-hover:text-amber-600 dark:group-hover:text-amber-400 transition">Saldo Préstamo Activo</span>
                                <div class="w-9 h-9 rounded-xl bg-amber-500/10 dark:bg-amber-500/20 text-amber-600 dark:text-amber-400 flex items-center justify-center text-base group-hover:scale-110 transition">
                                    <i class="fa-solid fa-file-invoice-dollar"></i>
                                </div>
                            </div>
                            <div>
                                <span class="text-2xl sm:text-3xl font-black text-amber-600 dark:text-amber-400 tracking-tight block">
                                    <asp:Literal ID="litPrestamo" runat="server" Text="$0.00"></asp:Literal>
                                </span>
                                <span class="text-[10px] text-slate-500 dark:text-slate-400 block mt-1 font-semibold">Tasa del 10% Anual fija</span>
                            </div>
                        </a>

                    </div>

                </div>
            </asp:Panel>

            <!-- 3. HERO SECTION (VISUAL INSTITUCIONAL) -->
            <section class="relative max-w-7xl mx-auto px-6 pt-6 pb-8 flex flex-col items-center text-center gap-6 overflow-hidden">
                <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-emerald-500/10 border border-emerald-500/30 text-emerald-700 dark:text-emerald-400 text-xs font-extrabold uppercase tracking-wider shadow-sm">
                    <i class="fa-solid fa-shield-halved text-emerald-600 dark:text-emerald-400"></i> "Finanzas que construyen comunidad desde 1987"
                </div>

                <h1 class="text-3xl sm:text-5xl lg:text-6xl font-black text-slate-900 dark:text-white tracking-tight max-w-4xl leading-tight">
                    El Impulso Financiero que Tu Futuro Necesita con <span class="text-transparent bg-clip-text bg-gradient-to-r from-emerald-600 to-teal-500 dark:from-emerald-400 dark:to-teal-200">Garantía Solidaria</span>
                </h1>

                <p class="text-slate-600 dark:text-slate-300 text-sm sm:text-base leading-relaxed max-w-2xl">
                    Somos una institución financiera comprometida con el desarrollo social y económico de nuestros socios. Brindamos servicios integrales de ahorro, crédito e inversión con total transparencia y respaldo.
                </p>

                <div class="flex flex-wrap items-center justify-center gap-4 mt-2">
                    <a href="Pages/Servicios.aspx" class="bg-emerald-600 hover:bg-emerald-500 text-white font-extrabold text-xs sm:text-sm px-7 py-3.5 rounded-xl shadow-xl shadow-emerald-600/20 transition flex items-center gap-2">
                        <i class="fa-solid fa-rocket"></i> Explorar Portafolio de Servicios
                    </a>
                    <a href="Pages/Contacto.aspx" class="bg-white dark:bg-[#0F233D] hover:bg-slate-100 dark:hover:bg-slate-800 border border-slate-300 dark:border-slate-700 text-slate-800 dark:text-slate-200 font-bold text-xs sm:text-sm px-6 py-3.5 rounded-xl transition flex items-center gap-2 shadow-sm">
                        <i class="fa-solid fa-calendar-check text-emerald-600 dark:text-emerald-400"></i> Agendar Cita Presencial
                    </a>
                </div>
            </section>

            <!-- 4. BARRA DE MÉTRICAS -->
            <section class="max-w-7xl mx-auto px-6 py-4">
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4 bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-800 rounded-2xl p-6 shadow-lg transition-colors duration-300">
                    <div class="flex flex-col items-center text-center gap-1 border-r border-slate-200 dark:border-slate-800/80 last:border-none">
                        <span class="text-2xl sm:text-3xl font-black text-emerald-600 dark:text-emerald-400">+35 Años</span>
                        <span class="text-[10px] sm:text-[11px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">De Trayectoria</span>
                    </div>
                    <div class="flex flex-col items-center text-center gap-1 border-r border-slate-200 dark:border-slate-800/80 last:border-none">
                        <span class="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white">10.00%</span>
                        <span class="text-[10px] sm:text-[11px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">Tasa Especial Crédito</span>
                    </div>
                    <div class="flex flex-col items-center text-center gap-1 border-r border-slate-200 dark:border-slate-800/80 last:border-none">
                        <span class="text-2xl sm:text-3xl font-black text-emerald-600 dark:text-emerald-400">100%</span>
                        <span class="text-[10px] sm:text-[11px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">Transparencia</span>
                    </div>
                    <div class="flex flex-col items-center text-center gap-1">
                        <span class="text-2xl sm:text-3xl font-black text-slate-900 dark:text-white">+15,000</span>
                        <span class="text-[10px] sm:text-[11px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">Socios Activos</span>
                    </div>
                </div>
            </section>

            <!-- 5. MENÚ DE MÓDULOS PÚBLICOS -->
            <main class="max-w-7xl mx-auto px-6 py-8 flex flex-col gap-6 flex-grow w-full">
                <div class="flex flex-col gap-1">
                    <span class="text-xs font-bold uppercase tracking-widest text-emerald-600 dark:text-emerald-400">Explora la Cooperativa</span>
                    <h2 class="text-2xl font-extrabold text-slate-900 dark:text-white">Acceso a Módulos Institucionales</h2>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <a href="Pages/QuienesSomos.aspx" class="group bg-white dark:bg-[#0F233D] hover:bg-slate-100/80 dark:hover:bg-[#122B4A] border-2 border-slate-200 dark:border-slate-800 hover:border-blue-500/60 dark:hover:border-blue-500/50 rounded-2xl p-6 sm:p-8 transition-all duration-300 shadow-sm hover:shadow-xl flex flex-col justify-between gap-6 relative overflow-hidden">
                        <div class="flex items-start justify-between gap-4">
                            <div class="w-14 h-14 rounded-2xl bg-blue-500/10 dark:bg-blue-600/20 border border-blue-500/30 flex items-center justify-center text-blue-600 dark:text-blue-400 text-2xl group-hover:scale-110 transition-transform">
                                <i class="fa-solid fa-users"></i>
                            </div>
                            <span class="text-xs font-bold text-slate-500 dark:text-slate-400 bg-slate-100 dark:bg-[#0B1A30] px-3 py-1 rounded-full border border-slate-200 dark:border-slate-800">Institucional</span>
                        </div>
                        <div class="flex flex-col gap-2">
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors flex items-center justify-between">
                                Quiénes Somos
                                <i class="fa-solid fa-arrow-right text-xs opacity-0 group-hover:opacity-100 transition-all -translate-x-2 group-hover:translate-x-0"></i>
                            </h3>
                            <p class="text-xs sm:text-sm text-slate-600 dark:text-slate-300 leading-relaxed">Conoce nuestra historia, visión, principios cooperativos y el compromiso social con el que respaldamos tus metas financieras.</p>
                        </div>
                    </a>

                    <a href="Pages/Servicios.aspx" class="group bg-white dark:bg-[#0F233D] hover:bg-slate-100/80 dark:hover:bg-[#122B4A] border-2 border-slate-200 dark:border-slate-800 hover:border-emerald-500/60 dark:hover:border-emerald-500/50 rounded-2xl p-6 sm:p-8 transition-all duration-300 shadow-sm hover:shadow-xl flex flex-col justify-between gap-6 relative overflow-hidden">
                        <div class="flex items-start justify-between gap-4">
                            <div class="w-14 h-14 rounded-2xl bg-emerald-500/10 dark:bg-emerald-600/20 border border-emerald-500/30 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-2xl group-hover:scale-110 transition-transform">
                                <i class="fa-solid fa-hand-holding-dollar"></i>
                            </div>
                            <span class="text-xs font-bold text-emerald-700 dark:text-emerald-400 bg-emerald-50 dark:bg-[#0B1A30] px-3 py-1 rounded-full border border-emerald-200 dark:border-emerald-500/30">Portafolio</span>
                        </div>
                        <div class="flex flex-col gap-2">
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white group-hover:text-emerald-600 dark:group-hover:text-emerald-400 transition-colors flex items-center justify-between">
                                Servicios Financieros
                                <i class="fa-solid fa-arrow-right text-xs opacity-0 group-hover:opacity-100 transition-all -translate-x-2 group-hover:translate-x-0"></i>
                            </h3>
                            <p class="text-xs sm:text-sm text-slate-600 dark:text-slate-300 leading-relaxed">Explora nuestros créditos a tasa preferencial del 10% (Personal, Vehicular e Hipotecario) con simuladores interactivos de cuotas.</p>
                        </div>
                    </a>

                    <a href="Pages/Transparencia.aspx" class="group bg-white dark:bg-[#0F233D] hover:bg-slate-100/80 dark:hover:bg-[#122B4A] border-2 border-slate-200 dark:border-slate-800 hover:border-blue-500/60 dark:hover:border-blue-500/50 rounded-2xl p-6 sm:p-8 transition-all duration-300 shadow-sm hover:shadow-xl flex flex-col justify-between gap-6 relative overflow-hidden">
                        <div class="flex items-start justify-between gap-4">
                            <div class="w-14 h-14 rounded-2xl bg-blue-500/10 dark:bg-blue-600/20 border border-blue-500/30 flex items-center justify-center text-blue-600 dark:text-blue-400 text-2xl group-hover:scale-110 transition-transform">
                                <i class="fa-solid fa-scale-balanced"></i>
                            </div>
                            <span class="text-xs font-bold text-slate-500 dark:text-slate-400 bg-slate-100 dark:bg-[#0B1A30] px-3 py-1 rounded-full border border-slate-200 dark:border-slate-800">Gobierno y Ética</span>
                        </div>
                        <div class="flex flex-col gap-2">
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors flex items-center justify-between">
                                Transparencia
                                <i class="fa-solid fa-arrow-right text-xs opacity-0 group-hover:opacity-100 transition-all -translate-x-2 group-hover:translate-x-0"></i>
                            </h3>
                            <p class="text-xs sm:text-sm text-slate-600 dark:text-slate-300 leading-relaxed">Accede a nuestros informes financieros, estados auditados, reglamentos internos y memorias de labores correspondientes.</p>
                        </div>
                    </a>

                    <a href="Pages/Contacto.aspx" class="group bg-white dark:bg-[#0F233D] hover:bg-slate-100/80 dark:hover:bg-[#122B4A] border-2 border-slate-200 dark:border-slate-800 hover:border-emerald-500/60 dark:hover:border-emerald-500/50 rounded-2xl p-6 sm:p-8 transition-all duration-300 shadow-sm hover:shadow-xl flex flex-col justify-between gap-6 relative overflow-hidden">
                        <div class="flex items-start justify-between gap-4">
                            <div class="w-14 h-14 rounded-2xl bg-emerald-500/10 dark:bg-emerald-600/20 border border-emerald-500/30 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-2xl group-hover:scale-110 transition-transform">
                                <i class="fa-solid fa-envelope-open-text"></i>
                            </div>
                            <span class="text-xs font-bold text-slate-500 dark:text-slate-400 bg-slate-100 dark:bg-[#0B1A30] px-3 py-1 rounded-full border border-slate-200 dark:border-slate-800">Atención a Socios</span>
                        </div>
                        <div class="flex flex-col gap-2">
                            <h3 class="text-xl font-bold text-slate-900 dark:text-white group-hover:text-emerald-600 dark:group-hover:text-emerald-400 transition-colors flex items-center justify-between">
                                Contacto y Citas
                                <i class="fa-solid fa-arrow-right text-xs opacity-0 group-hover:opacity-100 transition-all -translate-x-2 group-hover:translate-x-0"></i>
                            </h3>
                            <p class="text-xs sm:text-sm text-slate-600 dark:text-slate-300 leading-relaxed">Ubica nuestras agencias, agenda tu asesoría personalizada presencial o en línea, o comunícate directamente con nuestros ejecutivos.</p>
                        </div>
                    </a>
                </div>

                <!-- 6. SIMULADORES RÁPIDOS (ADAPTABLES Y BOTONES INTERACTIVOS) -->
                <section class="bg-slate-100 dark:bg-[#0F233D] border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm dark:shadow-xl flex flex-col lg:flex-row items-center justify-between gap-6 mt-4 transition-colors duration-300">
                    <div class="flex flex-col gap-2 text-center lg:text-left max-w-xl">
                        <span class="text-xs font-extrabold uppercase tracking-widest text-emerald-600 dark:text-emerald-400">FINANCIAMIENTO CON TASA DEL 10% ANUAL</span>
                        <h3 class="text-xl sm:text-2xl font-black text-slate-900 dark:text-white">¿Buscas calcular tus cuotas mensuales?</h3>
                        <p class="text-xs sm:text-sm text-slate-600 dark:text-slate-300">Prueba nuestros simuladores en tiempo real para Crédito Personal, Vehicular e Hipotecario.</p>
                    </div>

                    <div class="flex flex-wrap items-center justify-center gap-3 w-full lg:w-auto">
                        <a href="Pages/CreditoPersonal.aspx" class="group bg-white dark:bg-[#0B1A30] hover:bg-emerald-600 hover:text-white dark:hover:bg-emerald-500 border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-200 font-bold px-4 py-3 rounded-xl text-xs transition-all duration-300 flex items-center gap-2 shadow-sm hover:shadow-md hover:-translate-y-0.5">
                            <i class="fa-solid fa-coins text-emerald-600 dark:text-emerald-400 group-hover:text-white transition-colors"></i> Personal
                        </a>
                        <a href="Pages/CreditoVehicular.aspx" class="group bg-white dark:bg-[#0B1A30] hover:bg-emerald-600 hover:text-white dark:hover:bg-emerald-500 border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-200 font-bold px-4 py-3 rounded-xl text-xs transition-all duration-300 flex items-center gap-2 shadow-sm hover:shadow-md hover:-translate-y-0.5">
                            <i class="fa-solid fa-car text-emerald-600 dark:text-emerald-400 group-hover:text-white transition-colors"></i> Vehicular
                        </a>
                        <a href="Pages/CreditoHipotecario.aspx" class="group bg-white dark:bg-[#0B1A30] hover:bg-emerald-600 hover:text-white dark:hover:bg-emerald-500 border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-200 font-bold px-4 py-3 rounded-xl text-xs transition-all duration-300 flex items-center gap-2 shadow-sm hover:shadow-md hover:-translate-y-0.5">
                            <i class="fa-solid fa-house-chimney text-emerald-600 dark:text-emerald-400 group-hover:text-white transition-colors"></i> Hipotecario
                        </a>
                    </div>
                </section>
            </main>
        </div>

        <footer class="bg-white dark:bg-[#0F233D] border-t border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400 text-xs py-8 mt-auto transition-colors duration-300">
            <div class="max-w-7xl mx-auto px-6 flex flex-col sm:flex-row items-center justify-between gap-4 text-center sm:text-left">
                <div class="flex items-center gap-2">
                    <i class="fa-solid fa-users-gear text-emerald-600 dark:text-emerald-400 text-lg"></i>
                    <span class="font-extrabold text-slate-900 dark:text-white text-sm">Coop<span class="text-emerald-600 dark:text-emerald-400">Facil</span></span>
                    <span>| © <%= DateTime.Now.Year %> Todos los derechos reservados.</span>
                </div>
                <div class="flex items-center gap-6">
                    <a href="Pages/QuienesSomos.aspx" class="hover:text-emerald-600 dark:hover:text-emerald-400 transition">Nosotros</a>
                    <a href="Pages/Transparencia.aspx" class="hover:text-emerald-600 dark:hover:text-emerald-400 transition">Transparencia</a>
                    <a href="Pages/Contacto.aspx" class="hover:text-emerald-600 dark:hover:text-emerald-400 transition">Soporte</a>
                </div>
            </div>
        </footer>

    </form>

    <script>
        function updateThemeIcons(isDark) {
            const sunIcon = document.getElementById('themeIconSun');
            const moonIcon = document.getElementById('themeIconMoon');
            if (isDark) {
                sunIcon.classList.remove('hidden');
                moonIcon.classList.add('hidden');
            } else {
                sunIcon.classList.add('hidden');
                moonIcon.classList.remove('hidden');
            }
        }

        function toggleTheme() {
            const isDark = document.documentElement.classList.toggle('dark');
            localStorage.setItem('coopfacil-theme', isDark ? 'dark' : 'light');
            updateThemeIcons(isDark);
        }

        document.addEventListener('DOMContentLoaded', function () {
            const isDark = document.documentElement.classList.contains('dark');
            updateThemeIcons(isDark);
        });
    </script>
</body>
</html>