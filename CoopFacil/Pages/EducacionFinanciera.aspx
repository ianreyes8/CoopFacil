<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EducacionFinanciera.aspx.cs" Inherits="CoopFacil.Pages.EducacionFinanciera" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" class="dark">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Educación Financiera - CoopFacil</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
tailwind.config = {
    darkMode: 'class',
    theme: {
        extend: {
            colors: {
                coop: { darkBg: '#0B1A30', darkCard: '#0F233D', emerald: '#10B981', blue: '#3B82F6' }
            }
        }
    }
}
</script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script>
        (function() {
            const savedTheme = localStorage.getItem('coopfacil-theme');
            if (savedTheme === 'light') { document.documentElement.classList.remove('dark'); }
            else { document.documentElement.classList.add('dark'); }
        })();
    </script>
</head>
<body class="bg-slate-50 dark:bg-[#0B1A30] text-slate-800 dark:text-slate-100 font-sans antialiased min-h-screen flex flex-col justify-between transition-colors duration-300">
    <form id="form1" runat="server" class="min-h-screen flex flex-col justify-between">
        
        <div>
            <!-- BARRA DE NAVEGACIÓN PRINCIPAL -->
            <header class="bg-white/90 dark:bg-[#0B1A30]/95 backdrop-blur-md border-b border-slate-200 dark:border-slate-800 sticky top-0 z-50 w-full px-6 sm:px-10 py-4 flex items-center justify-between gap-4 transition-colors duration-300">
                
                <!-- LOGO COOPFACIL + SALUDO SI HAY SESIÓN -->
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

                    <!-- MENSAJE DE BIENVENIDA SI TIENE SESIÓN ACTIVA -->
                    <asp:Panel ID="pnlBienvenida" runat="server" Visible="false" CssClass="hidden lg:flex items-center gap-2 bg-slate-100 dark:bg-[#0F233D] border border-emerald-500/40 px-3 py-1.5 rounded-xl shadow-sm">
                        <i class="fa-solid fa-circle-user text-emerald-600 dark:text-emerald-400 text-base"></i>
                        <span class="text-xs font-bold text-slate-700 dark:text-white">
                            Bienvenido <asp:Literal ID="litBienvenida" runat="server"></asp:Literal>
                        </span>
                    </asp:Panel>
                </div>

                <!-- ENLACES DE NAVEGACIÓN (CENTRO) -->
                <nav class="hidden md:flex items-center gap-8 text-sm font-semibold">
                    <a href="QuienesSomos.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition">Quiénes Somos</a>
                    <a href="Servicios.aspx" class="text-emerald-600 dark:text-emerald-400 font-bold border-b-2 border-emerald-600 dark:border-emerald-400 pb-1">Servicios</a>
                    <a href="Transparencia.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition">Transparencia</a>
                    <a href="Contacto.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition">Contacto</a>
                </nav>

                <!-- CONTROLES DE SESIÓN Y TEMA (DERECHA) -->
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

            <!-- CONTENIDO PRINCIPAL -->
            <main class="max-w-7xl mx-auto px-6 py-10 flex flex-col gap-10 flex-grow w-full">
                
                <!-- REGRESO A SERVICIOS Y TITULAR -->
                <div class="flex flex-col gap-3">
                    <a href="Servicios.aspx" class="text-xs font-bold text-emerald-600 dark:text-emerald-400 hover:underline flex items-center gap-2 w-fit">
                        <i class="fa-solid fa-arrow-left"></i> Volver al Portafolio de Servicios
                    </a>
                    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 mt-2">
                        <div>
                            <span class="text-xs font-bold uppercase tracking-wider text-amber-600 dark:text-amber-400">VALOR AGREGADO COOPERATIVO</span>
                            <h1 class="text-3xl sm:text-4xl font-extrabold text-slate-900 dark:text-white tracking-tight flex items-center gap-3 mt-1">
                                <i class="fa-solid fa-graduation-cap text-amber-600 dark:text-amber-400"></i> Programa de Educación Financiera
                            </h1>
                        </div>
                        <div class="bg-white dark:bg-[#0F233D] border border-amber-500/40 px-4 py-2 rounded-xl flex items-center gap-3 shadow-sm dark:shadow-lg">
                            <span class="text-xs text-slate-600 dark:text-slate-300 font-medium">Capacitación Abierta:</span>
                            <span class="text-lg font-black text-amber-600 dark:text-amber-400">100% Gratuito</span>
                        </div>
                    </div>
                    <p class="text-sm sm:text-base text-slate-600 dark:text-slate-300 leading-relaxed max-w-3xl">
                        Aprende a gestionar tu dinero con responsabilidad, evalúa tu salud financiera en tiempo real, participa en seminarios web interactivos y descarga herramientas exclusivas para optimizar tu presupuesto familiar o empresarial.
                    </p>
                </div>

                <!-- COMPONENTE 1: TEST RÁPIDO DE SALUD FINANCIERA -->
                <section class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-amber-500/50 rounded-2xl p-6 sm:p-8 shadow-sm dark:shadow-2xl flex flex-col gap-6">
                    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-200 dark:border-slate-800 pb-4">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-amber-500/20 border border-amber-400/40 flex items-center justify-center text-amber-600 dark:text-amber-400 text-xl">
                                <i class="fa-solid fa-heart-pulse"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-slate-900 dark:text-white">Test Rápido de Salud Financiera</h2>
                                <p class="text-xs text-slate-500 dark:text-slate-400">Responde 4 sencillas preguntas y recibe un diagnóstico con recomendaciones a tu medida</p>
                            </div>
                        </div>
                        <span class="text-xs font-bold text-amber-600 dark:text-amber-400 bg-slate-50 dark:bg-[#0B1A30] border border-amber-500/30 px-3 py-1.5 rounded-lg w-fit">
                            Diagnóstico Inmediato
                        </span>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        
                        <!-- P1: AHORRO -->
                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-5 flex flex-col gap-3">
                            <label class="text-xs font-bold text-slate-900 dark:text-white flex items-center gap-2">
                                <span class="w-5 h-5 rounded-full bg-amber-500/20 text-amber-600 dark:text-amber-400 text-[11px] font-black flex items-center justify-center">1</span>
                                ¿Qué porcentaje de tus ingresos mensuales destinas al ahorro?
                            </label>
                            <select id="qAhorro" onchange="evaluarSaludFinanciera()" class="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2.5 text-xs font-bold text-slate-900 dark:text-white focus:outline-none focus:border-amber-400 transition">
                                <option value="0">Menos del 5% o nada</option>
                                <option value="1">Entre el 5% y el 10%</option>
                                <option value="2" selected="selected">Más del 10% de mis ingresos</option>
                            </select>
                        </div>

                        <!-- P2: DEUDAS -->
                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-5 flex flex-col gap-3">
                            <label class="text-xs font-bold text-slate-900 dark:text-white flex items-center gap-2">
                                <span class="w-5 h-5 rounded-full bg-amber-500/20 text-amber-600 dark:text-amber-400 text-[11px] font-black flex items-center justify-center">2</span>
                                ¿Qué porcentaje de tus ingresos utilizas para pagar deudas?
                            </label>
                            <select id="qDeudas" onchange="evaluarSaludFinanciera()" class="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2.5 text-xs font-bold text-slate-900 dark:text-white focus:outline-none focus:border-amber-400 transition">
                                <option value="0">Más del 50% (Siento sobreendeudamiento)</option>
                                <option value="1" selected="selected">Entre el 30% y el 50% de mi ingreso</option>
                                <option value="2">Menos del 30% o no poseo deudas</option>
                            </select>
                        </div>

                        <!-- P3: FONDO DE EMERGENCIA -->
                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-5 flex flex-col gap-3">
                            <label class="text-xs font-bold text-slate-900 dark:text-white flex items-center gap-2">
                                <span class="w-5 h-5 rounded-full bg-amber-500/20 text-amber-600 dark:text-amber-400 text-[11px] font-black flex items-center justify-center">3</span>
                                ¿Cuentas con un fondo de emergencia para imprevistos?
                            </label>
                            <select id="qFondo" onchange="evaluarSaludFinanciera()" class="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2.5 text-xs font-bold text-slate-900 dark:text-white focus:outline-none focus:border-amber-400 transition">
                                <option value="0">No tengo ahorros para imprevistos</option>
                                <option value="1" selected="selected">Tengo cubierto entre 1 y 2 meses de gastos</option>
                                <option value="2">Tengo 3 o más meses de gastos guardados</option>
                            </select>
                        </div>

                        <!-- P4: PRESUPUESTO -->
                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-5 flex flex-col gap-3">
                            <label class="text-xs font-bold text-slate-900 dark:text-white flex items-center gap-2">
                                <span class="w-5 h-5 rounded-full bg-amber-500/20 text-amber-600 dark:text-amber-400 text-[11px] font-black flex items-center justify-center">4</span>
                                ¿Llevas un registro ordenado y mensual de tus gastos?
                            </label>
                            <select id="qPresupuesto" onchange="evaluarSaludFinanciera()" class="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2.5 text-xs font-bold text-slate-900 dark:text-white focus:outline-none focus:border-amber-400 transition">
                                <option value="0">Rara vez o nunca llevo control</option>
                                <option value="1">Llevo un cálculo aproximado mental</option>
                                <option value="2" selected="selected">Uso plantilla o app registrada mes a mes</option>
                            </select>
                        </div>

                    </div>

                    <div id="pnlResultadoDiagnostico" class="bg-slate-50 dark:bg-[#0B1A30] border border-amber-500/40 rounded-xl p-6 flex flex-col md:flex-row items-center justify-between gap-6 shadow-inner">
                        <div class="flex flex-col gap-2 text-center md:text-left">
                            <span class="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-widest">Diagnóstico Recomendado</span>
                            <h3 id="lblTituloDiagnostico" class="text-2xl font-black text-amber-600 dark:text-amber-400">Salud Financiera Estable</h3>
                            <p id="lblTextoDiagnostico" class="text-xs sm:text-sm text-slate-600 dark:text-slate-300 max-w-2xl leading-relaxed">
                                Llevas un control adecuado de tus finanzas. Sin embargo, fortalecer tu fondo de emergencia te brindará mayor tranquilidad ante situaciones inesperadas.
                            </p>
                        </div>

                        <div class="flex flex-col gap-2 min-w-[240px] w-full md:w-auto">
                            <span class="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase text-center md:text-right">Productos CoopFacil Sugeridos:</span>
                            <div id="divSugerenciaProductos" class="flex flex-col gap-2">
                            </div>
                        </div>
                    </div>
                </section>

                <!-- COMPONENTE 2: INSCRIPCIÓN A TALLERES Y WEBINARS DEL MES -->
                <section class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                    
                    <div class="lg:col-span-7 flex flex-col gap-6">
                        <div class="flex items-center gap-3 border-b border-slate-200 dark:border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-amber-500/20 border border-amber-400/40 flex items-center justify-center text-amber-600 dark:text-amber-400 text-xl">
                                <i class="fa-solid fa-calendar-check"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-slate-900 dark:text-white">Talleres y Webinars</h2>
                                <p class="text-xs text-slate-500 dark:text-slate-400">Participa en vivo, haz preguntas a nuestros expertos y recibe constancia de participación</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 gap-4">
                            
                            <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 hover:border-amber-400/80 rounded-2xl p-5 shadow-sm dark:shadow-xl flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 transition">
                                <div class="flex flex-col gap-1.5">
                                    <div class="flex items-center gap-2">
                                        <span class="bg-amber-500/20 text-amber-600 dark:text-amber-400 font-bold text-[10px] px-2.5 py-1 rounded-md border border-amber-500/30">WEBINAR VIRTUAL</span>
                                    </div>
                                    <h3 class="text-base font-bold text-slate-900 dark:text-white">Finanzas para Emprendedores y Microempresas</h3>
                                    <p class="text-xs text-slate-600 dark:text-slate-300">Aprende a separar tus finanzas personales de las del negocio, estructurar costos y calcular tu margen real.</p>
                                </div>
                                <button type="button" onclick="seleccionarTaller('1')" class="bg-amber-600 hover:bg-amber-500 text-white text-xs font-bold px-4 py-2.5 rounded-xl transition whitespace-nowrap shadow-md">
                                    Inscribirme <i class="fa-solid fa-arrow-right text-[10px]"></i>
                                </button>
                            </div>

                            <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 hover:border-amber-400/80 rounded-2xl p-5 shadow-sm dark:shadow-xl flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 transition">
                                <div class="flex flex-col gap-1.5">
                                    <div class="flex items-center gap-2">
                                        <span class="bg-emerald-500/20 text-emerald-600 dark:text-emerald-400 font-bold text-[10px] px-2.5 py-1 rounded-md border border-emerald-500/30">TALLER PRESENCIAL</span>
                                    </div>
                                    <h3 class="text-base font-bold text-slate-900 dark:text-white">Cómo Salir de Deudas y Optimizar tu Presupuesto</h3>
                                    <p class="text-xs text-slate-600 dark:text-slate-300">Métodos bola de nieve y avalancha para liquidar deudas, reducir intereses y negociar con acreedores.</p>
                                </div>
                                <button type="button" onclick="seleccionarTaller('2')" class="bg-emerald-600 hover:bg-emerald-500 text-white text-xs font-bold px-4 py-2.5 rounded-xl transition whitespace-nowrap shadow-md">
                                    Inscribirme <i class="fa-solid fa-arrow-right text-[10px]"></i>
                                </button>
                            </div>

                            <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 hover:border-amber-400/80 rounded-2xl p-5 shadow-sm dark:shadow-xl flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 transition">
                                <div class="flex flex-col gap-1.5">
                                    <div class="flex items-center gap-2">
                                        <span class="bg-blue-500/20 text-blue-600 dark:text-blue-400 font-bold text-[10px] px-2.5 py-1 rounded-md border border-blue-500/30">WEBINAR VIRTUAL</span>
                                    </div>
                                    <h3 class="text-base font-bold text-slate-900 dark:text-white">Estrategias de Inversión y Planificación de Retiro</h3>
                                    <p class="text-xs text-slate-600 dark:text-slate-300">Descubre opciones de inversión de bajo riesgo, ahorros con interés compuesto y protección patrimonial.</p>
                                </div>
                                <button type="button" onclick="seleccionarTaller('3')" class="bg-blue-600 hover:bg-blue-500 text-white text-xs font-bold px-4 py-2.5 rounded-xl transition whitespace-nowrap shadow-md">
                                    Inscribirme <i class="fa-solid fa-arrow-right text-[10px]"></i>
                                </button>
                            </div>

                        </div>
                    </div>

                    <div id="secFormularioInscripcion" class="lg:col-span-5 bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-amber-500/40 rounded-2xl p-6 shadow-sm dark:shadow-xl flex flex-col gap-5">
                        <div class="flex items-center gap-3 border-b border-slate-200 dark:border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-amber-500/20 border border-amber-400/30 flex items-center justify-center text-amber-600 dark:text-amber-400 text-xl">
                                <i class="fa-solid fa-user-plus"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-slate-900 dark:text-white">Inscripción Directa</h2>
                                <p class="text-xs text-slate-500 dark:text-slate-400">Reserva tu cupo sin costo de forma inmediata</p>
                            </div>
                        </div>

                        <asp:Panel ID="pnlMensajeTaller" runat="server" Visible="false" CssClass="mb-2 p-4 rounded-xl border flex items-center gap-3 text-sm font-bold">
                            <asp:Literal ID="litMensajeTaller" runat="server"></asp:Literal>
                        </asp:Panel>

                        <div class="flex flex-col gap-4">
                            
                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Selecciona el Taller / Webinar <span class="text-amber-600 dark:text-amber-400">*</span></label>
                                <asp:DropDownList ID="ddlTallerSeleccionado" runat="server" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-amber-400 transition font-medium">
                                    <asp:ListItem Text="Finanzas para Emprendedores y Microempresas" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Cómo Salir de Deudas y Optimizar tu Presupuesto" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="Estrategias de Inversión y Planificación de Retiro" Value="3"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Nombre Completo <span class="text-amber-600 dark:text-amber-400">*</span></label>
                                <asp:TextBox ID="txtNombreInscripcion" runat="server" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-amber-400 transition" placeholder="Ej. Ana Lucía Gómez"></asp:TextBox>
                            </div>

                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Correo Electrónico <span class="text-amber-600 dark:text-amber-400">*</span></label>
                                <asp:TextBox ID="txtCorreoInscripcion" runat="server" TextMode="Email" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-amber-400 transition" placeholder="correo@ejemplo.com"></asp:TextBox>
                            </div>

                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Teléfono para Recordatorios <span class="text-amber-600 dark:text-amber-400">*</span></label>
                                <asp:TextBox ID="txtTelefonoInscripcion" runat="server" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-amber-400 transition" placeholder="7777-8888"></asp:TextBox>
                            </div>

                            <asp:Button ID="btnInscribirseTaller" runat="server" Text="Confirmar Reservación de Cupo" OnClick="btnInscribirseTaller_Click" CssClass="mt-2 w-full bg-amber-600 hover:bg-amber-500 text-white font-bold text-xs py-3 rounded-xl shadow-lg shadow-amber-950 transition cursor-pointer" />
                        </div>
                    </div>

                </section>

                <!-- COMPONENTE 3: CENTRO DE RECURSOS Y DESCARGAS -->
                <section class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 sm:p-8 shadow-sm dark:shadow-2xl flex flex-col gap-6">
                    <div class="flex items-center justify-between border-b border-slate-200 dark:border-slate-800 pb-4">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-emerald-500/20 border border-emerald-400/40 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-xl">
                                <i class="fa-solid fa-file-arrow-down"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-slate-900 dark:text-white">Centro de Recursos y Descargas</h2>
                                <p class="text-xs text-slate-500 dark:text-slate-400">Descarga de forma gratuita plantillas, guías prácticas e instructivos diseñados por nuestros asesores</p>
                            </div>
                        </div>
                        <span class="hidden sm:inline-block text-xs font-bold text-emerald-600 dark:text-emerald-400 bg-slate-50 dark:bg-[#0B1A30] border border-emerald-500/30 px-3 py-1.5 rounded-lg">
                            Descargas Libres
                        </span>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        
                        <!-- DOCUMENTO 1: PLANTILLA EXCEL DE PRESUPUESTO -->
                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-5 flex flex-col justify-between gap-4 group hover:border-emerald-500/50 transition">
                            <div class="flex flex-col gap-3">
                                <div class="w-10 h-10 rounded-lg bg-emerald-500/20 border border-emerald-400/30 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-lg">
                                    <i class="fa-solid fa-file-excel"></i>
                                </div>
                                <h3 class="text-sm font-bold text-slate-900 dark:text-white group-hover:text-emerald-600 dark:group-hover:text-emerald-400 transition">Plantilla de Presupuesto CoopFácil</h3>
                                <p class="text-xs text-slate-500 dark:text-slate-400 leading-relaxed">
                                    Herramienta interactiva para calcular ingresos, salidas de dinero y capacidad mensual de ahorro.
                                </p>
                            </div>
                            <asp:LinkButton ID="btnDescargarExcel" runat="server" OnClick="btnDescargarExcel_Click" CssClass="w-full bg-white dark:bg-[#0F233D] hover:bg-emerald-600 border border-emerald-500/40 text-emerald-600 dark:text-emerald-400 hover:text-white text-xs font-bold py-2.5 rounded-lg transition flex items-center justify-center gap-2 shadow-sm">
                                <i class="fa-solid fa-download"></i> Descargar Excel (.xlsx)
                            </asp:LinkButton>
                        </div>

                        <!-- DOCUMENTO 2: GUÍA SENCILLA DE AHORRO PDF -->
                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-5 flex flex-col justify-between gap-4 group hover:border-amber-500/50 transition">
                            <div class="flex flex-col gap-3">
                                <div class="w-10 h-10 rounded-lg bg-amber-500/20 border border-amber-400/30 flex items-center justify-center text-amber-600 dark:text-amber-400 text-lg">
                                    <i class="fa-solid fa-file-pdf"></i>
                                </div>
                                <h3 class="text-sm font-bold text-slate-900 dark:text-white group-hover:text-amber-600 dark:group-hover:text-amber-400 transition">Guía Sencilla de Ahorro</h3>
                                <p class="text-xs text-slate-500 dark:text-slate-400 leading-relaxed">
                                    7 ideas fáciles para hacer rendir tu dinero, opciones de cuenta y consejos para tu fondo de reserva[cite: 43].
                                </p>
                            </div>
                            <asp:LinkButton ID="btnDescargarGuiaPDF" runat="server" OnClick="btnDescargarGuiaPDF_Click" CssClass="w-full bg-white dark:bg-[#0F233D] hover:bg-amber-600 border border-amber-500/40 text-amber-600 dark:text-amber-400 hover:text-white text-xs font-bold py-2.5 rounded-lg transition flex items-center justify-center gap-2 shadow-sm">
                                <i class="fa-solid fa-download"></i> Descargar PDF (.pdf)
                            </asp:LinkButton>
                        </div>

                        <!-- DOCUMENTO 3: MANUAL DE SANEAMIENTO Y GESTIÓN DE DEUDAS PDF -->
                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-5 flex flex-col justify-between gap-4 group hover:border-blue-500/50 transition">
                            <div class="flex flex-col gap-3">
                                <div class="w-10 h-10 rounded-lg bg-blue-500/20 border border-blue-400/30 flex items-center justify-center text-blue-600 dark:text-blue-400 text-lg">
                                    <i class="fa-solid fa-shield-halved"></i>
                                </div>
                                <h3 class="text-sm font-bold text-slate-900 dark:text-white group-hover:text-blue-600 dark:group-hover:text-blue-400 transition">Manual de Saneamiento y Deudas</h3>
                                <p class="text-xs text-slate-500 dark:text-slate-400 leading-relaxed">
                                    Pasos claros para evaluar tu nivel de endeudamiento, cuotas vs. ingresos y consolidación de deudas[cite: 41, 42].
                                </p>
                            </div>
                            <asp:LinkButton ID="btnDescargarManualPDF" runat="server" OnClick="btnDescargarManualPDF_Click" CssClass="w-full bg-white dark:bg-[#0F233D] hover:bg-blue-600 border border-blue-500/40 text-blue-600 dark:text-blue-400 hover:text-white text-xs font-bold py-2.5 rounded-lg transition flex items-center justify-center gap-2 shadow-sm">
                                <i class="fa-solid fa-download"></i> Descargar Guía (.pdf)
                            </asp:LinkButton>
                        </div>

                    </div>
                </section>

            </main>
        </div>

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

        function evaluarSaludFinanciera() {
            const ahorro = parseInt(document.getElementById('qAhorro').value) || 0;
            const deudas = parseInt(document.getElementById('qDeudas').value) || 0;
            const fondo = parseInt(document.getElementById('qFondo').value) || 0;
            const presupuesto = parseInt(document.getElementById('qPresupuesto').value) || 0;

            const puntajeTotal = ahorro + deudas + fondo + presupuesto;

            const lblTitulo = document.getElementById('lblTituloDiagnostico');
            const lblTexto = document.getElementById('lblTextoDiagnostico');
            const divProductos = document.getElementById('divSugerenciaProductos');

            if (puntajeTotal >= 7) {
                lblTitulo.innerText = "🌟 Salud Financiera Excelente";
                lblTitulo.className = "text-2xl font-black text-emerald-600 dark:text-emerald-400";
                lblTexto.innerText = "¡Felicidades! Tienes hábitos financieros sólidos. Es el momento ideal para hacer crecer tu patrimonio mediante planes de inversión a plazo y proyectos de mayor envergadura.";
                divProductos.innerHTML = `
                    <a href="AhorroProgramado.aspx" class="bg-emerald-500/20 border border-emerald-500/40 text-emerald-700 dark:text-emerald-300 hover:bg-emerald-600 hover:text-white px-3 py-1.5 rounded-lg text-xs font-bold flex items-center justify-between transition">
                        <span>Ahorro Programado (8.0% EA)</span> <i class="fa-solid fa-chevron-right text-[10px]"></i>
                    </a>
                    <a href="CreditoHipotecario.aspx" class="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-white px-3 py-1.5 rounded-lg text-xs font-bold flex items-center justify-between transition">
                        <span>Crédito Hipotecario (7.5% EA)</span> <i class="fa-solid fa-chevron-right text-[10px]"></i>
                    </a>`;
            } else if (puntajeTotal >= 4) {
                lblTitulo.innerText = "⚡ Salud Financiera Estable";
                lblTitulo.className = "text-2xl font-black text-amber-600 dark:text-amber-400";
                lblTexto.innerText = "Llevas un buen manejo general, pero cuentas con margen para optimizar tus excedentes y construir un fondo de reserva más robusto que proteja tu tranquilidad.";
                divProductos.innerHTML = `
                    <a href="AhorroProgramado.aspx" class="bg-amber-500/20 border border-amber-500/40 text-amber-700 dark:text-amber-300 hover:bg-amber-600 hover:text-white px-3 py-1.5 rounded-lg text-xs font-bold flex items-center justify-between transition">
                        <span>Ahorro Programado</span> <i class="fa-solid fa-chevron-right text-[10px]"></i>
                    </a>
                    <a href="CuentaAhorro.aspx" class="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-300 hover:text-amber-600 dark:hover:text-white px-3 py-1.5 rounded-lg text-xs font-bold flex items-center justify-between transition">
                        <span>Cuenta de Ahorro Libre</span> <i class="fa-solid fa-chevron-right text-[10px]"></i>
                    </a>`;
            } else {
                lblTitulo.innerText = "⚠️ Salud Financiera en Riesgo";
                lblTitulo.className = "text-2xl font-black text-red-600 dark:text-red-400";
                lblTexto.innerText = "Tus compromisos o falta de fondo de reserva generan vulnerabilidad. Te sugerimos reestructurar o consolidar tus deudas a una menor tasa para liberar flujo de caja inmediato.";
                divProductos.innerHTML = `
                    <a href="CreditoPersonal.aspx" class="bg-blue-500/20 border border-blue-500/40 text-blue-700 dark:text-blue-300 hover:bg-blue-600 hover:text-white px-3 py-1.5 rounded-lg text-xs font-bold flex items-center justify-between transition">
                        <span>Consolidación de Deudas</span> <i class="fa-solid fa-chevron-right text-[10px]"></i>
                    </a>
                    <a href="CuentaAhorro.aspx" class="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-300 hover:text-blue-600 dark:hover:text-white px-3 py-1.5 rounded-lg text-xs font-bold flex items-center justify-between transition">
                        <span>Cuenta de Ahorro Base</span> <i class="fa-solid fa-chevron-right text-[10px]"></i>
                    </a>`;
            }
        }

        function seleccionarTaller(idTaller) {
            const ddl = document.getElementById('<%= ddlTallerSeleccionado.ClientID %>');
            if (ddl) {
                ddl.value = idTaller;
            }
            const secForm = document.getElementById('secFormularioInscripcion');
            if (secForm) {
                secForm.scrollIntoView({ behavior: 'smooth' });
            }
        }

        document.addEventListener('DOMContentLoaded', function () {
            const isDark = document.documentElement.classList.contains('dark');
            updateThemeIcons(isDark);

            evaluarSaludFinanciera();
        });
    </script>
</body>
</html>