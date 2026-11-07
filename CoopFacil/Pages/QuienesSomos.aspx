<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuienesSomos.aspx.cs" Inherits="CoopFacil.Pages.QuienesSomos" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" class="dark">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quiénes Somos - CoopFacil</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: { coop: { darkBg: '#0B1A30', darkCard: '#0F233D', emerald: '#10B981', blue: '#3B82F6' } }
                }
            }
        }
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script>
    (function () {
        const savedTheme = localStorage.getItem('coopfacil-theme');
        if (savedTheme === 'light') { document.documentElement.classList.remove('dark'); }
        else { document.documentElement.classList.add('dark'); }
    })();
</script>
</head>
<body class="bg-slate-50 dark:bg-[#0B1A30] text-slate-800 dark:text-slate-100 font-sans antialiased min-h-screen flex flex-col justify-between transition-colors duration-300">
    <form id="form1" runat="server" class="min-h-screen flex flex-col justify-between">
        
        <header class="bg-white/90 dark:bg-[#0B1A30]/95 backdrop-blur-md border-b border-slate-200 dark:border-slate-800 sticky top-0 z-50 w-full px-6 sm:px-10 py-4 flex items-center justify-between gap-4 transition-colors duration-300">
            
            <div class="flex items-center gap-4">
                <a href="../Index.aspx" class="flex items-center gap-3 group">
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

                <asp:Panel ID="pnlBienvenida" runat="server" Visible="false" CssClass="hidden lg:flex items-center gap-2 bg-slate-100 dark:bg-[#0F233D] border border-emerald-500/40 px-3 py-1.5 rounded-xl shadow-sm">
                    <i class="fa-solid fa-circle-user text-emerald-600 dark:text-emerald-400 text-base"></i>
                    <span class="text-xs font-bold text-slate-700 dark:text-white">
                        Bienvenido <asp:Literal ID="litBienvenida" runat="server"></asp:Literal>
                    </span>
                </asp:Panel>
            </div>

            <nav class="hidden md:flex items-center gap-8 text-sm font-semibold">
                    <a href="../Index.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition pb-1 border-b-2 border-transparent">Inicio</a>
                    <a href="QuienesSomos.aspx" class="text-emerald-600 dark:text-emerald-400 font-bold border-b-2 border-emerald-600 dark:border-emerald-400 pb-1">Quiénes Somos</a>
                    <a href="Servicios.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition pb-1 border-b-2 border-transparent">Servicios</a>
                    <a href="Transparencia.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition pb-1 border-b-2 border-transparent">Transparencia</a>
                    <a href="Contacto.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition pb-1 border-b-2 border-transparent">Contacto</a>
            </nav>

            <div class="flex items-center gap-3">
                <button type="button" onclick="toggleTheme()" id="themeToggleBtn" title="Cambiar Tema" class="w-10 h-10 rounded-xl bg-slate-100 dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-amber-400 hover:bg-slate-200 dark:hover:bg-slate-800 transition flex items-center justify-center text-base shadow-sm">
                    <i id="themeIconSun" class="fa-solid fa-sun hidden"></i>
                    <i id="themeIconMoon" class="fa-solid fa-moon"></i>
                </button>

                <asp:HyperLink ID="lnkIniciarSesion" runat="server" NavigateUrl="../Default.aspx" CssClass="bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs sm:text-sm px-5 py-2.5 rounded-xl transition flex items-center gap-2 shadow-lg shadow-blue-500/20">
                    <i class="fa-solid fa-right-to-bracket"></i> Iniciar Sesión
                </asp:HyperLink>

                <asp:LinkButton ID="btnCerrarSesion" runat="server" OnClick="btnCerrarSesion_Click" Visible="false" CssClass="bg-slate-100 dark:bg-[#0F233D] hover:bg-slate-200 dark:hover:bg-slate-700 border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-white font-bold text-xs sm:text-sm px-4 py-2.5 rounded-xl transition flex items-center gap-2">
                    <i class="fa-solid fa-right-from-bracket"></i> Cerrar Sesión
                </asp:LinkButton>
            </div>

        </header>

        <main class="max-w-7xl mx-auto px-6 py-10 flex flex-col gap-10 flex-grow w-full">
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                
                <div class="lg:col-span-7 flex flex-col gap-8">
                    <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-8 shadow-sm dark:shadow-xl flex flex-col gap-4">
                        <span class="text-xs font-bold uppercase tracking-wider text-emerald-600 dark:text-emerald-400 flex items-center gap-2">
                            <span class="w-4 h-[2px] bg-emerald-600 dark:bg-emerald-400 inline-block"></span> IDENTIDAD COOPERATIVA
                        </span>
                        <h1 class="text-3xl sm:text-4xl font-extrabold text-slate-900 dark:text-white tracking-tight leading-tight">
                            Somos más que una institución financiera
                        </h1>
                        <p class="text-sm sm:text-base text-slate-600 dark:text-slate-300 leading-relaxed">
                            Nacimos en 1987 de la unión de 47 familias trabajadoras con una convicción: que el acceso al crédito justo y al ahorro seguro no debería ser privilegio de pocos. Hoy, con más de 8,400 socios, seguimos siendo fieles a ese principio fundacional.
                        </p>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                        <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 shadow-sm dark:shadow-xl flex flex-col gap-3">
                            <div class="w-10 h-10 rounded-xl bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-lg">
                                <i class="fa-solid fa-bullseye"></i>
                            </div>
                            <h3 class="text-lg font-bold text-slate-900 dark:text-white">Nuestra Misión</h3>
                            <p class="text-xs text-slate-600 dark:text-slate-300 leading-relaxed">
                                Impulsar el desarrollo socioeconómico integral de nuestros socios mediante soluciones financieras inclusivas, transparentes y competitivas de ahorro, crédito e inversión.
                            </p>
                        </div>

                        <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 shadow-sm dark:shadow-xl flex flex-col gap-3">
                            <div class="w-10 h-10 rounded-xl bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-lg">
                                <i class="fa-solid fa-eye"></i>
                            </div>
                            <h3 class="text-lg font-bold text-slate-900 dark:text-white">Nuestra Visión</h3>
                            <p class="text-xs text-slate-600 dark:text-slate-300 leading-relaxed">
                                Ser la cooperativa financiera referente por su solidez, innovación en servicios digitales y capacidad de transformar vidas con un modelo autosostenible.
                            </p>
                        </div>
                    </div>

                    <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 shadow-sm dark:shadow-xl flex flex-col gap-6">
                        <div class="flex items-center gap-3 border-b border-slate-200 dark:border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-amber-500/10 border border-amber-500/20 flex items-center justify-center text-amber-600 dark:text-amber-400 text-lg">
                                <i class="fa-solid fa-chart-line"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-bold text-slate-900 dark:text-white">Alcances e Impacto</h3>
                                <p class="text-xs text-slate-500 dark:text-slate-400">Compromiso real con nuestra comunidad</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                            <div class="flex items-start gap-3">
                                <div class="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center text-emerald-600 dark:text-emerald-400 flex-shrink-0 mt-0.5">
                                    <i class="fa-solid fa-building-columns text-sm"></i>
                                </div>
                                <div>
                                    <h4 class="text-sm font-bold text-slate-900 dark:text-white">Cobertura Territorial</h4>
                                    <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">Presencia activa en 8 departamentos con 12 oficinas físicas.</p>
                                </div>
                            </div>

                            <div class="flex items-start gap-3">
                                <div class="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center text-emerald-600 dark:text-emerald-400 flex-shrink-0 mt-0.5">
                                    <i class="fa-solid fa-code text-sm"></i>
                                </div>
                                <div>
                                    <h4 class="text-sm font-bold text-slate-900 dark:text-white">Innovación Digital</h4>
                                    <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">Servicios en línea para consultas y solicitudes 24/7.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="lg:col-span-5 flex flex-col gap-6">
                    <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 shadow-sm dark:shadow-xl flex flex-col gap-2">
                        <span class="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">ACTIVOS TOTALES</span>
                        <div class="text-4xl font-extrabold text-blue-600 dark:text-blue-400">$100M</div>
                        <span class="text-xs text-emerald-600 dark:text-emerald-400 font-semibold flex items-center gap-1">
                            <i class="fa-solid fa-arrow-up"></i> 14.2% vs año anterior
                        </span>
                    </div>

                    <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 shadow-sm dark:shadow-xl flex flex-col gap-2">
                        <span class="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">SOLVENCIA</span>
                        <div class="text-4xl font-extrabold text-blue-600 dark:text-blue-400">18.4%</div>
                        <span class="text-xs text-slate-500 dark:text-slate-400">Índice BIS (mín. legal 8%)</span>
                    </div>

                    <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 shadow-sm dark:shadow-xl flex flex-col gap-2">
                        <span class="text-xs font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">CALIFICACIÓN DE RIESGO</span>
                        <div class="text-4xl font-extrabold text-emerald-600 dark:text-emerald-400">AA+</div>
                        <span class="text-xs text-slate-500 dark:text-slate-400">Fitch Ratings · Perspectiva Estable</span>
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-5 shadow-sm dark:shadow-xl flex flex-col gap-1">
                            <span class="text-[11px] font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">CARTERA SANA</span>
                            <div class="text-2xl font-extrabold text-emerald-600 dark:text-emerald-400">97.8%</div>
                            <span class="text-[11px] text-slate-500 dark:text-slate-400">Morosidad 2.2%</span>
                        </div>

                        <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-5 shadow-sm dark:shadow-xl flex flex-col gap-1">
                            <span class="text-[11px] font-bold uppercase tracking-wider text-slate-500 dark:text-slate-400">OFICINAS</span>
                            <div class="text-2xl font-extrabold text-blue-600 dark:text-blue-400">3</div>
                            <span class="text-[11px] text-slate-500 dark:text-slate-400">En 1 departamento</span>
                        </div>
                    </div>
                </div>

            </div>
        </main>

        <footer class="bg-white dark:bg-[#0F233D] border-t border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400 text-xs text-center py-6 mt-auto transition-colors duration-300">
            <p>© <%= DateTime.Now.Year %> CoopFacil. Todos los derechos reservados.</p>
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