<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AhorroProgramado.aspx.cs" Inherits="CoopFacil.Pages.AhorroProgramado" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" class="dark">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Ahorro Programado - CoopFacil</title>
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
    (function () {
        const savedTheme = localStorage.getItem('coopfacil-theme');
        if (savedTheme === 'light') { document.documentElement.classList.remove('dark'); }
        else { document.documentElement.classList.add('dark'); }
    })();
</script>
</head>
<body class="bg-slate-50 dark:bg-[#0B1A30] text-slate-800 dark:text-slate-100 font-sans antialiased min-h-screen flex flex-col justify-between transition-colors duration-300">
    <!-- FORMULARIO CON AUTOCOMPLETADO DESACTIVADO GLOBALMENTE -->
    <form id="form1" runat="server" autocomplete="off" class="min-h-screen flex flex-col justify-between">
        
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
            <main class="max-w-7xl mx-auto px-6 py-8 flex flex-col gap-8 flex-grow w-full">
                
                <!-- ENLACE DE REGRESO -->
                <div>
                    <a href="Servicios.aspx" class="text-xs font-bold text-emerald-600 dark:text-emerald-400 hover:underline flex items-center gap-2 w-fit">
                        <i class="fa-solid fa-arrow-left"></i> Volver al Portafolio de Servicios
                    </a>
                </div>

                <!-- ENCABEZADO Y BADGE DE TASA ESCALONADA -->
                <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
                    <div>
                        <span class="text-[11px] font-bold uppercase tracking-wider text-emerald-600 dark:text-emerald-400 block mb-1">PLANES DE AHORRO CON META</span>
                        <h1 class="text-3xl sm:text-4xl font-extrabold text-slate-900 dark:text-white tracking-tight flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-emerald-500/20 border border-emerald-400/30 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-xl shadow-inner">
                                <i class="fa-solid fa-bullseye"></i>
                            </div>
                            Ahorro Programado
                        </h1>
                        <p class="text-xs sm:text-sm text-slate-600 dark:text-slate-300 leading-relaxed max-w-3xl mt-2">
                            Diseñado para ayudarte a alcanzar tus metas específicas (vacaciones, educación o fondo de emergencia) mediante aportes programados por débito automático. A mayor plazo de ahorro, obtendrás una tasa de interés superior para tus rendimientos.
                        </p>
                    </div>

                    <div class="bg-white dark:bg-[#0F233D] border border-emerald-500/40 px-5 py-2.5 rounded-xl flex items-center gap-2 shadow-sm dark:shadow-lg whitespace-nowrap">
                        <span class="text-xs text-slate-600 dark:text-slate-300 font-medium">Tasa Preferencial Escalonada:</span>
                        <span class="text-base sm:text-lg font-black text-emerald-600 dark:text-emerald-400">Hasta 8.00% ANUAL</span>
                    </div>
                </div>

                <!-- SECCIÓN SUPERIOR: SIMULADOR Y DÉBITO AUTOMÁTICO -->
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-stretch">
                    
                    <!-- IZQUIERDA: SIMULADOR DE METAS FINANCIERAS -->
                    <div class="lg:col-span-7 bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 shadow-sm dark:shadow-xl flex flex-col justify-between gap-6">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 rounded-xl bg-emerald-500/20 border border-emerald-400/30 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-lg">
                                <i class="fa-solid fa-calculator"></i>
                            </div>
                            <div>
                                <h2 class="text-lg font-bold text-slate-900 dark:text-white">Simulador de Metas Financieras</h2>
                                <p class="text-xs text-slate-500 dark:text-slate-400">Tasas escalonadas según plazo: Hasta el 8% Anual</p>
                            </div>
                        </div>

                        <!-- INPUTS CON FORMATO DINÁMICO DE COMAS -->
                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                            <div class="flex flex-col gap-1.5">
                                <label class="text-[10px] font-bold text-slate-600 dark:text-slate-300 uppercase">META DE AHORRO</label>
                                <asp:DropDownList ID="ddlMetaSim" runat="server" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2.5 text-xs font-bold text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition">
                                    <asp:ListItem Text="🎯 Fondo de Emergencia" Value="Fondo de Emergencia" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="✈️ Vacaciones / Viajes" Value="Vacaciones"></asp:ListItem>
                                    <asp:ListItem Text="🎓 Educación / Estudios" Value="Educación"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="flex flex-col gap-1.5">
                                <label class="text-[10px] font-bold text-slate-600 dark:text-slate-300 uppercase">CUOTA MENSUAL</label>
                                <div class="relative flex items-center">
                                    <span class="absolute left-3.5 text-slate-500 dark:text-slate-300 font-bold text-xs">$</span>
                                    <asp:TextBox ID="txtCuotaMensualSim" runat="server" autocomplete="off" Text="50" oninput="formatearYCalcularMonto(this)" CssClass="w-full bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl pl-7 pr-3 py-2.5 text-xs font-bold text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition" placeholder="50"></asp:TextBox>
                                </div>
                            </div>

                            <div class="flex flex-col gap-1.5">
                                <label class="text-[10px] font-bold text-slate-600 dark:text-slate-300 uppercase">PLAZO / TASA ANUAL</label>
                                <asp:DropDownList ID="ddlPlazoSim" runat="server" onchange="calcularSimuladorAhorroProgramado()" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2.5 text-xs font-bold text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition">
                                    <asp:ListItem Text="6 Meses (Tasa 1.5%)" Value="6"></asp:ListItem>
                                    <asp:ListItem Text="12 Meses (Tasa 3.0%)" Value="12" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="18 Meses (Tasa 5.0%)" Value="18"></asp:ListItem>
                                    <asp:ListItem Text="24 Meses (Tasa 6.5%)" Value="24"></asp:ListItem>
                                    <asp:ListItem Text="36 Meses (Tasa 8.0%)" Value="36"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <div class="bg-slate-100 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 grid grid-cols-1 sm:grid-cols-3 gap-4 text-center items-center shadow-inner">
                            <div class="flex flex-col">
                                <span class="text-[10px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">TOTAL ACUMULADO</span>
                                <span id="lblTotalAcumulado" class="text-2xl font-extrabold text-emerald-600 dark:text-emerald-400 mt-1">$609.84</span>
                            </div>

                            <div class="flex flex-col sm:border-x border-slate-300 dark:border-slate-800 px-2">
                                <span class="text-[10px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">INTERESES ABONADOS (<span id="lblTasaInfo">3.0% EA</span>)</span>
                                <span id="lblInteresesAbonados" class="text-2xl font-extrabold text-slate-900 dark:text-white mt-1">$9.84</span>
                            </div>

                            <div class="flex flex-col">
                                <span class="text-[10px] font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">TUS APORTES TOTALES</span>
                                <span id="lblAportesTotales" class="text-2xl font-extrabold text-slate-900 dark:text-white mt-1">$600.00</span>
                            </div>
                        </div>

                        <p class="text-[10px] text-slate-500 dark:text-slate-400 italic text-center">
                            * Proyección basada en capitalización mensual a una Tasa Efectiva Anual (EA) según el plazo elegido (1.5% a 8.0%).
                        </p>
                    </div>

                    <!-- DERECHA: DÉBITO AUTOMÁTICO -->
                    <div class="lg:col-span-5 bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 shadow-sm dark:shadow-xl flex flex-col justify-between gap-5">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 rounded-xl bg-blue-500/20 border border-blue-400/30 flex items-center justify-center text-blue-600 dark:text-blue-400 text-lg">
                                <i class="fa-solid fa-calendar-check"></i>
                            </div>
                            <div>
                                <h2 class="text-lg font-bold text-slate-900 dark:text-white">Débito Automático</h2>
                                <p class="text-xs text-slate-500 dark:text-slate-400">Retención directa sin complicaciones</p>
                            </div>
                        </div>

                        <p class="text-xs text-slate-600 dark:text-slate-300 leading-relaxed">
                            Configura la fecha del mes en que deseas que se realice el débito automático desde tu **Cuenta de Ahorro Principal**:
                        </p>

                        <div class="grid grid-cols-3 gap-2.5 text-center">
                            <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl p-3 flex flex-col items-center justify-center">
                                <span class="text-[9px] font-bold text-slate-500 dark:text-slate-400 uppercase">OPCIÓN 1</span>
                                <span class="text-sm font-extrabold text-emerald-600 dark:text-emerald-400 mt-0.5">Día 1</span>
                                <span class="text-[9px] text-slate-500 dark:text-slate-400 mt-0.5">Inicio de Mes</span>
                            </div>

                            <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl p-3 flex flex-col items-center justify-center">
                                <span class="text-[9px] font-bold text-slate-500 dark:text-slate-400 uppercase">OPCIÓN 2</span>
                                <span class="text-sm font-extrabold text-emerald-600 dark:text-emerald-400 mt-0.5">Día 15</span>
                                <span class="text-[9px] text-slate-500 dark:text-slate-400 mt-0.5">Quincena</span>
                            </div>

                            <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl p-3 flex flex-col items-center justify-center">
                                <span class="text-[9px] font-bold text-slate-500 dark:text-slate-400 uppercase">OPCIÓN 3</span>
                                <span class="text-sm font-extrabold text-emerald-600 dark:text-emerald-400 mt-0.5">Día 30</span>
                                <span class="text-[9px] text-slate-500 dark:text-slate-400 mt-0.5">Fin de Mes</span>
                            </div>
                        </div>

                        <div class="space-y-1.5 text-xs text-slate-600 dark:text-slate-300 pt-1">
                            <div class="flex items-center gap-2"><i class="fa-solid fa-check text-emerald-600 dark:text-emerald-400"></i> Sin cobros de comisión por transferencia interna.</div>
                            <div class="flex items-center gap-2"><i class="fa-solid fa-check text-emerald-600 dark:text-emerald-400"></i> Notificación inmediata por SMS o correo al realizar la retención.</div>
                        </div>
                    </div>

                </div>

                <!-- SECCIÓN INFERIOR: FORMULARIO DE CONTRATACIÓN DE PLAN -->
                <section class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 sm:p-8 shadow-sm dark:shadow-2xl relative overflow-hidden">
                    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-2">
                        <div>
                            <span class="text-[10px] font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-widest block">CONTRATACIÓN EN LÍNEA</span>
                            <h2 class="text-2xl font-extrabold text-slate-900 dark:text-white mt-0.5 flex items-center gap-2">
                                <i class="fa-solid fa-file-contract text-emerald-600 dark:text-emerald-400"></i> Formulario de Contratación de Plan
                            </h2>
                        </div>
                        <div class="flex items-center gap-2 bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 px-3.5 py-1.5 rounded-xl text-xs font-bold text-slate-700 dark:text-slate-300">
                            <i class="fa-solid fa-shield-halved text-emerald-600 dark:text-emerald-400 text-sm"></i> Contrato Ligado a Socio Activo
                        </div>
                    </div>

                    <p class="text-xs text-slate-600 dark:text-slate-300 mb-6">
                        Completa el registro formal de tu plan de ahorro ligado a tu sesión de socio activo.
                    </p>

                    <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-xl border flex items-center gap-3 text-xs font-bold">
                        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-4">
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Nombre Completo <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtNombre" runat="server" autocomplete="off" attr-autocomplete="new-password" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="Leonardo Vasquez"></asp:TextBox>
                        </div>

                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Documento de Identidad (DUI) <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtDUI" runat="server" autocomplete="off" attr-autocomplete="new-password" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="00000000-0"></asp:TextBox>
                        </div>

                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Teléfono de Contacto <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtTelefono" runat="server" autocomplete="off" attr-autocomplete="new-password" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="7777-8888"></asp:TextBox>
                        </div>

                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Correo Electrónico <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtCorreo" runat="server" TextMode="Email" autocomplete="off" attr-autocomplete="new-password" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="correo@ejemplo.com"></asp:TextBox>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end mb-2">
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Meta Seleccionada <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                            <asp:DropDownList ID="ddlMetaForm" runat="server" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition">
                                <asp:ListItem Text="Fondo de Emergencia" Value="Fondo de Emergencia" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Vacaciones / Viajes" Value="Vacaciones"></asp:ListItem>
                                <asp:ListItem Text="Educación / Estudios" Value="Educación"></asp:ListItem>
                                <asp:ListItem Text="Pie para Vivienda" Value="Vivienda"></asp:ListItem>
                                <asp:ListItem Text="Compra de Vehículo" Value="Vehículo"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Cuota Mensual ($10 a $500) <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtCuotaMensualForm" runat="server" autocomplete="off" attr-autocomplete="new-password" oninput="formatearYCalcularMonto(this)" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="50"></asp:TextBox>
                        </div>

                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Plazo en Meses / Tasa <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                            <asp:DropDownList ID="ddlPlazoForm" runat="server" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition">
                                <asp:ListItem Text="6 Meses (Tasa 1.5% EA)" Value="6"></asp:ListItem>
                                <asp:ListItem Text="12 Meses (Tasa 3.0% EA)" Value="12" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="18 Meses (Tasa 5.0% EA)" Value="18"></asp:ListItem>
                                <asp:ListItem Text="24 Meses (Tasa 6.5% EA)" Value="24"></asp:ListItem>
                                <asp:ListItem Text="36 Meses (Tasa 8.0% EA)" Value="36"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Día de Débito Automático <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                            <asp:DropDownList ID="ddlDiaDebito" runat="server" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition">
                                <asp:ListItem Text="Día 1 del mes" Value="1" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="Día 15 del mes" Value="15"></asp:ListItem>
                                <asp:ListItem Text="Día 30 del mes" Value="30"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="mt-4 flex justify-end">
                        <asp:Button ID="btnContratarPlan" runat="server" Text="Contratar Plan de Ahorro Programado" OnClick="btnContratarPlan_Click" CssClass="bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs px-6 py-3 rounded-xl shadow-lg shadow-emerald-950 transition cursor-pointer" />
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

        function formatearYCalcularMonto(input) {
            if (!input) return;
            let valorLimpio = input.value.replace(/[^0-9]/g, '');
            if (valorLimpio !== "") {
                input.value = parseInt(valorLimpio, 10).toLocaleString('en-US');
            } else {
                input.value = "";
            }
            calcularSimuladorAhorroProgramado();
        }

        function obtenerNumeroSinComas(valor) {
            if (!valor) return 0;
            let numLimpio = valor.toString().replace(/,/g, '');
            return parseFloat(numLimpio) || 0;
        }

        function obtenerTasaPorPlazo(meses) {
            switch (parseInt(meses)) {
                case 6: return 0.015;
                case 12: return 0.030;
                case 18: return 0.050;
                case 24: return 0.065;
                case 36: return 0.080;
                default: return 0.030;
            }
        }

        function calcularSimuladorAhorroProgramado() {
            const txtCuota = document.getElementById('<%= txtCuotaMensualSim.ClientID %>');
            const ddlPlazo = document.getElementById('<%= ddlPlazoSim.ClientID %>');

            if (!txtCuota || !ddlPlazo) return;

            const cuotaMensual = obtenerNumeroSinComas(txtCuota.value);
            const meses = parseInt(ddlPlazo.value) || 12;
            const tasaAnual = obtenerTasaPorPlazo(meses);
            const tasaMensual = tasaAnual / 12;

            let balanceAcumulado = 0;
            for (let m = 1; m <= meses; m++) {
                balanceAcumulado = (balanceAcumulado + cuotaMensual) * (1 + tasaMensual);
            }

            const aportesTotales = cuotaMensual * meses;
            const interesesAbonados = balanceAcumulado - aportesTotales;

            document.getElementById('lblTasaInfo').innerText = (tasaAnual * 100).toFixed(1) + '% EA';
            document.getElementById('lblTotalAcumulado').innerText = '$' + balanceAcumulado.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblInteresesAbonados').innerText = '$' + interesesAbonados.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblAportesTotales').innerText = '$' + aportesTotales.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        document.addEventListener('DOMContentLoaded', function () {
            const isDark = document.documentElement.classList.contains('dark');
            updateThemeIcons(isDark);

            const txtCuotaSim = document.getElementById('<%= txtCuotaMensualSim.ClientID %>');
            const txtCuotaForm = document.getElementById('<%= txtCuotaMensualForm.ClientID %>');

            if (txtCuotaSim) formatearYCalcularMonto(txtCuotaSim);
            if (txtCuotaForm && txtCuotaForm.value) formatearYCalcularMonto(txtCuotaForm);

            calcularSimuladorAhorroProgramado();
        });
    </script>
</body>
</html>