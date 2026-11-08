<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CuentaAhorro.aspx.cs" Inherits="CoopFacil.Pages.CuentaAhorro" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" class="dark">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Cuenta de Ahorro - CoopFacil</title>
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
    <form id="form1" runat="server" autocomplete="off" class="min-h-screen flex flex-col justify-between">
        
        <div>
            <!-- BARRA DE NAVEGACIÓN PRINCIPAL -->
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
                    <a href="QuienesSomos.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition pb-1 border-b-2 border-transparent">Quiénes Somos</a>
                    <a href="Servicios.aspx" class="text-emerald-600 dark:text-emerald-400 font-bold border-b-2 border-emerald-600 dark:border-emerald-400 pb-1">Servicios</a>
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

            <!-- CONTENIDO CONFORME AL BOCETO ESTRUCTURAL -->
            <main class="max-w-6xl mx-auto px-6 py-8 flex flex-col gap-6 flex-grow w-full">
                
                <!-- 1. ENCABEZADO DE CUENTA DE AHORRO -->
                <section class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm dark:shadow-xl text-center flex flex-col items-center justify-center gap-3">
                    <div class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-emerald-500/10 border border-emerald-500/30 text-emerald-600 dark:text-emerald-400 text-xs font-bold uppercase tracking-wider">
                        <i class="fa-solid fa-wallet"></i> PRODUCTO DE AHORRO & DESEMBOLSO
                    </div>
                    <h1 class="text-3xl sm:text-4xl font-black text-slate-900 dark:text-white">
                        Cuenta de Ahorro
                    </h1>
                    <p class="text-xs sm:text-sm text-slate-600 dark:text-slate-300 max-w-2xl">
                        Plataforma central de captación y recepción de fondos desembolsados por créditos aprobados en CoopFácil.
                    </p>
                </section>

                <!-- 2. BLOQUE: NOMBRE DEL CLIENTE Y Nº DE CUENTA -->
                <section class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-800 rounded-3xl p-6 shadow-sm dark:shadow-xl flex flex-col sm:flex-row items-center justify-between gap-4">
                    <div class="flex items-center gap-4">
                        <div class="w-12 h-12 rounded-2xl bg-emerald-500/20 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-2xl shadow-inner">
                            <i class="fa-solid fa-id-card"></i>
                        </div>
                        <div class="flex flex-col">
                            <span class="text-[10px] font-extrabold uppercase tracking-widest text-slate-400">Titular de la Cuenta</span>
                            <span class="text-xl sm:text-2xl font-black text-slate-900 dark:text-white">
                                <asp:Literal ID="litNombreCliente" runat="server" Text="Cliente Invitado"></asp:Literal>
                            </span>
                        </div>
                    </div>

                    <div class="bg-slate-50 dark:bg-[#0B1A30] border border-emerald-500/40 px-5 py-3 rounded-2xl flex items-center gap-3 shadow-inner">
                        <i class="fa-solid fa-hashtag text-emerald-600 dark:text-emerald-400 text-base"></i>
                        <div class="flex flex-col">
                            <span class="text-[9px] font-bold text-slate-400 uppercase tracking-wider">Nº de Cuenta</span>
                            <span class="text-sm font-black text-emerald-600 dark:text-emerald-400">
                                <asp:Literal ID="litNumeroCuenta" runat="server" Text="CTA-7788-000000"></asp:Literal>
                            </span>
                        </div>
                    </div>
                </section>

                <!-- 3. BLOQUE: REFLEJO DEL DINERO DESEMBOLSADO DE LOS CRÉDITOS -->
                <section class="bg-gradient-to-r from-emerald-600 to-teal-600 dark:from-emerald-700 dark:to-teal-900 rounded-3xl p-8 shadow-xl text-white flex flex-col items-center justify-center text-center gap-2 relative overflow-hidden">
                    <div class="absolute -right-8 -bottom-8 text-white/10 text-9xl font-black select-none pointer-events-none">
                        <i class="fa-solid fa-money-bill-wave"></i>
                    </div>
                    <span class="text-xs font-extrabold uppercase tracking-widest text-emerald-100">
                        Reflejo del Dinero Desembolsado de los Créditos
                    </span>
                    <h2 class="text-4xl sm:text-6xl font-black tracking-tight my-1">
                        <asp:Literal ID="litTotalDesembolsado" runat="server" Text="$0.00 USD"></asp:Literal>
                    </h2>
                    <span class="text-xs text-emerald-100/90 font-medium bg-black/20 px-4 py-1.5 rounded-full border border-white/20">
                        <i class="fa-solid fa-circle-check text-emerald-300 mr-1"></i> Fondos disponibles abonados directamente por créditos adquiridos
                    </span>
                </section>

                <!-- 4. BLOQUE: REFLEJO DE LOS CRÉDITOS ADQUIRIDOS CON LA COOPERATIVA -->
                <section class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-800 rounded-3xl p-6 sm:p-8 shadow-sm dark:shadow-xl flex flex-col gap-6">
                    <div class="flex items-center justify-between border-b border-slate-200 dark:border-slate-800 pb-4">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-blue-500/20 text-blue-600 dark:text-blue-400 flex items-center justify-center text-xl">
                                <i class="fa-solid fa-list-check"></i>
                            </div>
                            <div>
                                <h3 class="text-xl font-bold text-slate-900 dark:text-white">Reflejo de los Créditos Adquiridos con la Cooperativa</h3>
                                <p class="text-xs text-slate-500 dark:text-slate-400">Detalle de préstamos solicitados y aprobados por el titular</p>
                            </div>
                        </div>
                        <span class="bg-blue-500/10 text-blue-600 dark:text-blue-400 text-xs font-bold px-3 py-1.5 rounded-xl border border-blue-500/20 hidden sm:inline-block">
                            <asp:Literal ID="litCantidadCreditos" runat="server" Text="0 Crédito(s)"></asp:Literal>
                        </span>
                    </div>

                    <!-- REPEATER DE CRÉDITOS ACUMULADOS -->
                    <asp:Repeater ID="rptCreditos" runat="server">
                        <HeaderTemplate>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-2xl p-5 flex flex-col justify-between gap-4 shadow-sm hover:border-emerald-500/50 transition duration-300">
                                <div class="flex items-center justify-between border-b border-slate-200 dark:border-slate-800 pb-3">
                                    <div class="flex items-center gap-2">
                                        <i class="fa-solid fa-hand-holding-dollar text-emerald-600 dark:text-emerald-400 text-base"></i>
                                        <span class="text-sm font-black text-slate-900 dark:text-white"><%# Eval("TipoCredito") %></span>
                                    </div>
                                    <span class="text-[10px] font-bold bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 px-2.5 py-1 rounded-lg border border-emerald-500/20">
                                        <%# Eval("NumeroTransaccion") %>
                                    </span>
                                </div>

                                <div class="grid grid-cols-3 gap-2 text-center">
                                    <div class="flex flex-col bg-white dark:bg-[#0F233D] p-2.5 rounded-xl border border-slate-200 dark:border-slate-800">
                                        <span class="text-[9px] font-bold text-slate-400 uppercase">Monto Solicitado</span>
                                        <span class="text-sm font-black text-emerald-600 dark:text-emerald-400 mt-0.5">$<%# string.Format("{0:N2}", Eval("Monto")) %></span>
                                    </div>
                                    <div class="flex flex-col bg-white dark:bg-[#0F233D] p-2.5 rounded-xl border border-slate-200 dark:border-slate-800">
                                        <span class="text-[9px] font-bold text-slate-400 uppercase">Plazo</span>
                                        <span class="text-sm font-black text-slate-900 dark:text-white mt-0.5"><%# Eval("PlazoMeses") %> Meses</span>
                                    </div>
                                    <div class="flex flex-col bg-white dark:bg-[#0F233D] p-2.5 rounded-xl border border-slate-200 dark:border-slate-800">
                                        <span class="text-[9px] font-bold text-slate-400 uppercase">Cuota Mensual</span>
                                        <span class="text-sm font-black text-blue-600 dark:text-blue-400 mt-0.5">$<%# string.Format("{0:N2}", Eval("CuotaMensual")) %></span>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>

                    <!-- PANEL DE ESTADO CUANDO NO HAY CRÉDITOS REGISTRADOS -->
                    <asp:Panel ID="pnlSinCreditos" runat="server" Visible="false" CssClass="p-8 text-center bg-slate-50 dark:bg-[#0B1A30] rounded-2xl border border-dashed border-slate-300 dark:border-slate-800 flex flex-col items-center gap-3">
                        <i class="fa-solid fa-folder-open text-4xl text-slate-400"></i>
                        <p class="text-xs text-slate-500 dark:text-slate-400">Aún no has registrado solicitudes de crédito en esta sesión.</p>
                        <a href="CreditoPersonal.aspx" class="bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs px-4 py-2 rounded-xl transition">
                            Solicitar Crédito Personal
                        </a>
                    </asp:Panel>

                </section>

            </main>
        </div>

        <footer class="bg-white dark:bg-[#0F233D] border-t border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400 text-xs text-center py-6 mt-auto">
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