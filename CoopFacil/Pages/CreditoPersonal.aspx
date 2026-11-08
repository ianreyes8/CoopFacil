<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreditoPersonal.aspx.cs" Inherits="CoopFacil.Pages.CreditoPersonal" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" class="dark">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Crédito Personal - CoopFacil</title>
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
    <form id="form1" runat="server" enctype="multipart/form-data" autocomplete="off" class="min-h-screen flex flex-col justify-between">
        
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

            <!-- CONTENIDO PRINCIPAL -->
            <main class="max-w-7xl mx-auto px-6 py-10 flex flex-col gap-10 flex-grow w-full">
                
                <!-- TITULAR Y NAVEGACIÓN ATRÁS -->
                <div class="flex flex-col gap-3">
                    <a href="Servicios.aspx" class="text-xs font-bold text-blue-600 dark:text-blue-400 hover:underline flex items-center gap-2 w-fit">
                        <i class="fa-solid fa-arrow-left"></i> Volver al Portafolio de Servicios
                    </a>
                    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 mt-2">
                        <div>
                            <span class="text-xs font-bold uppercase tracking-wider text-blue-600 dark:text-blue-400">FINANCIAMIENTO DE LIBRE INVERSIÓN</span>
                            <h1 class="text-3xl sm:text-4xl font-extrabold text-slate-900 dark:text-white tracking-tight flex items-center gap-3 mt-1">
                                <i class="fa-solid fa-hand-holding-dollar text-blue-600 dark:text-blue-400"></i> Crédito Personal CoopFácil
                            </h1>
                        </div>
                        <div class="bg-white dark:bg-[#0F233D] border border-blue-500/40 px-4 py-2 rounded-xl flex items-center gap-3 shadow-sm dark:shadow-lg">
                            <span class="text-xs text-slate-600 dark:text-slate-300 font-medium">Tasa Preferencial:</span>
                            <span class="text-lg font-black text-blue-600 dark:text-blue-400">10.00% ANUAL</span>
                        </div>
                    </div>
                    <p class="text-sm sm:text-base text-slate-600 dark:text-slate-300 leading-relaxed max-w-3xl">
                        Haz realidad tus proyectos personales, consolida deudas o atiende imprevistos con cuotas fijas ajustadas a tus posibilidades, respuesta ágil e intereses sobre saldo insoluto.
                    </p>
                </div>

                <!-- SIMULADOR INTERACTIVO Y DESGLOSE DE CUOTA ESTIMADA -->
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                    
                    <!-- PANEL IZQUIERDO: SIMULADOR DE CUOTA -->
                    <div class="lg:col-span-7 bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 sm:p-8 shadow-sm dark:shadow-xl flex flex-col gap-6">
                        
                        <div class="flex items-center justify-between border-b border-slate-200 dark:border-slate-800 pb-4">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-xl bg-blue-500/20 border border-blue-400/40 flex items-center justify-center text-blue-600 dark:text-blue-400 text-xl">
                                    <i class="fa-solid fa-calculator"></i>
                                </div>
                                <div>
                                    <h2 class="text-xl font-bold text-slate-900 dark:text-white">Simulador de Crédito</h2>
                                    <p class="text-xs text-slate-500 dark:text-slate-400">Calcula tu cuota a Tasa del 10.00% ANUAL</p>
                                </div>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                            
                            <div class="flex flex-col gap-2">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">MONTO DESEADO ($ USD)</label>
                                <div class="relative">
                                    <span class="absolute left-3 top-3 text-slate-400 font-bold">$</span>
                                    <input type="text" id="simMonto" value="5,000" autocomplete="off" oninput="formatearMontoInput(this); calcularCredito();" class="w-full bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl pl-8 pr-4 py-2.5 text-sm font-bold text-slate-900 dark:text-white focus:outline-none focus:border-blue-500 transition" />
                                </div>
                            </div>

                            <div class="flex flex-col gap-2">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">PLAZO EN MESES</label>
                                <select id="simPlazo" onchange="calcularCredito()" class="w-full bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-sm font-bold text-slate-900 dark:text-white focus:outline-none focus:border-blue-500 transition">
                                    <option value="12">12 Meses (1 Año)</option>
                                    <option value="24">24 Meses (2 Años)</option>
                                    <option value="36" selected="selected">36 Meses (3 Años)</option>
                                    <option value="48">48 Meses (4 Años)</option>
                                    <option value="60">60 Meses (5 Años)</option>
                                    <option value="72">72 Meses (6 Años)</option>
                                    <option value="84">84 Meses (7 Años)</option>
                                    <option value="120">120 Meses (10 Años)</option>
                                </select>
                            </div>

                        </div>

                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex justify-between items-center">
                            <span class="text-xs font-bold text-slate-500 dark:text-slate-400">MONTO SOLICITADO:</span>
                            <span id="lblMontoTexto" class="text-lg font-black text-blue-600 dark:text-blue-400">$5,000.00</span>
                        </div>

                        <!-- TABLA DE AMORTIZACIÓN RESUMIDA -->
                        <div class="flex flex-col gap-3">
                            <h3 class="text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider flex items-center gap-2">
                                <i class="fa-solid fa-table text-blue-600 dark:text-blue-400"></i> Tabla de Amortización Inicial
                            </h3>

                            <div class="overflow-x-auto rounded-xl border border-slate-200 dark:border-slate-800">
                                <table class="w-full text-left text-xs">
                                    <thead class="bg-blue-600/10 dark:bg-blue-950/40 text-blue-600 dark:text-blue-400 font-bold border-b border-slate-200 dark:border-slate-800">
                                        <tr>
                                            <th class="p-3">MES</th>
                                            <th class="p-3">CUOTA BASE</th>
                                            <th class="p-3">INTERÉS</th>
                                            <th class="p-3">CAPITAL</th>
                                            <th class="p-3">SALDO RESTANTE</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tblAmortizacion" class="divide-y divide-slate-200 dark:divide-slate-800 font-medium text-slate-600 dark:text-slate-300">
                                        <!-- Generado dinámicamente -->
                                    </tbody>
                                </table>
                            </div>
                            <span id="lblMensajeTabla" class="text-[10px] text-slate-400 dark:text-slate-500 text-center italic"></span>
                        </div>

                    </div>

                    <!-- PANEL DERECHO: DESGLOSE DE CUOTA ESTIMADA -->
                    <div class="lg:col-span-5 flex flex-col gap-6">
                        
                        <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 sm:p-8 shadow-sm dark:shadow-xl flex flex-col gap-6">
                            
                            <div class="flex items-center gap-3 border-b border-slate-200 dark:border-slate-800 pb-4">
                                <div class="w-10 h-10 rounded-xl bg-blue-500/20 border border-blue-400/40 flex items-center justify-center text-blue-600 dark:text-blue-400 text-xl">
                                    <i class="fa-solid fa-chart-pie"></i>
                                </div>
                                <div>
                                    <h3 class="text-lg font-bold text-slate-900 dark:text-white">Desglose de Cuota Estimada</h3>
                                    <p class="text-xs text-slate-500 dark:text-slate-400">Incluye capital e intereses sobre saldo insoluto</p>
                                </div>
                            </div>

                            <div class="bg-slate-50 dark:bg-[#0B1A30] border border-blue-500/30 rounded-xl p-6 flex flex-col items-center justify-center text-center shadow-inner">
                                <span class="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider mb-1">CUOTA TOTAL MENSUAL ESTIMADA</span>
                                <div id="lblCuotaEstimada" class="text-4xl font-black text-blue-600 dark:text-blue-400">$161.34</div>
                                <span class="text-[10px] text-slate-400 dark:text-slate-500 mt-1">* Cuota fija estimada durante todo el plazo</span>
                            </div>

                            <div class="flex flex-col gap-3">
                                <span class="text-xs font-bold text-slate-700 dark:text-slate-300 uppercase tracking-wider">DISTRIBUCIÓN DE LA CUOTA (MES 1):</span>
                                
                                <div class="h-2 rounded-full overflow-hidden flex bg-slate-200 dark:bg-slate-800">
                                    <div id="barCapital" class="bg-emerald-500 transition-all duration-300" style="width: 74.2%;"></div>
                                    <div id="barInteres" class="bg-blue-500 transition-all duration-300" style="width: 25.8%;"></div>
                                </div>
                            </div>

                            <div class="flex flex-col gap-3">
                                
                                <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex items-center justify-between">
                                    <div class="flex items-center gap-3">
                                        <div class="w-8 h-8 rounded-lg bg-emerald-500/10 border border-emerald-500/20 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-sm">
                                            <i class="fa-solid fa-landmark"></i>
                                        </div>
                                        <span class="text-xs font-bold text-slate-800 dark:text-white">Abono Directo a Capital:</span>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <span id="lblCapitalPct" class="text-[11px] font-bold text-slate-400">74.2%</span>
                                        <span id="lblAbonoCapital" class="text-xs font-black text-emerald-600 dark:text-emerald-400">$119.67</span>
                                    </div>
                                </div>

                                <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex items-center justify-between">
                                    <div class="flex items-center gap-3">
                                        <div class="w-8 h-8 rounded-lg bg-blue-500/10 border border-blue-500/20 text-blue-600 dark:text-blue-400 flex items-center justify-center text-sm">
                                            <i class="fa-solid fa-percent"></i>
                                        </div>
                                        <span class="text-xs font-bold text-slate-800 dark:text-white">Intereses Financieros (10% ANUAL):</span>
                                    </div>
                                    <div class="flex items-center gap-2">
                                        <span id="lblInteresPct" class="text-[11px] font-bold text-slate-400">25.8%</span>
                                        <span id="lblInteresMes" class="text-xs font-black text-blue-600 dark:text-blue-400">$41.67</span>
                                    </div>
                                </div>

                            </div>

                            <span class="text-[11px] text-slate-400 dark:text-slate-500 italic text-center">
                                * Proyección orientativa sujeta a aprobación de crédito y evaluación de capacidad financiera.
                            </span>

                        </div>

                    </div>

                </div>

                <!-- SECCIÓN DE REQUISITOS -->
                <section class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 sm:p-8 shadow-sm dark:shadow-xl flex flex-col gap-6">
                    
                    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-blue-500/20 border border-blue-400/40 flex items-center justify-center text-blue-600 dark:text-blue-400 text-xl">
                                <i class="fa-solid fa-folder-closed"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-extrabold text-slate-900 dark:text-white">Requisitos para Solicitud de Crédito Personal</h2>
                                <p class="text-xs text-slate-500 dark:text-slate-400">Documentación y referencias obligatorias previas al estudio y desembolso</p>
                            </div>
                        </div>
                        <span class="hidden sm:flex items-center gap-1.5 bg-emerald-500/10 border border-emerald-500/30 text-emerald-600 dark:text-emerald-400 text-xs font-bold px-3 py-1.5 rounded-xl">
                            <i class="fa-solid fa-circle-check"></i> Verificación Digital y Legal
                        </span>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                        
                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <div class="w-9 h-9 rounded-lg bg-emerald-500/10 border border-emerald-500/20 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-base">
                                    <i class="fa-solid fa-id-card"></i>
                                </div>
                                <div class="flex flex-col">
                                    <span class="text-xs font-bold text-slate-900 dark:text-white">1. DUI Vigente</span>
                                    <span class="text-[11px] text-slate-500 dark:text-slate-400">Ambos lados legibles</span>
                                </div>
                            </div>
                            <i class="fa-solid fa-circle-check text-emerald-600 dark:text-emerald-400 text-sm"></i>
                        </div>

                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <div class="w-9 h-9 rounded-lg bg-emerald-500/10 border border-emerald-500/20 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-base">
                                    <i class="fa-solid fa-file-invoice-dollar"></i>
                                </div>
                                <div class="flex flex-col">
                                    <span class="text-xs font-bold text-slate-900 dark:text-white">2. Constancia de Sueldo</span>
                                    <span class="text-[11px] text-slate-500 dark:text-slate-400">Emisión reciente firmada</span>
                                </div>
                            </div>
                            <i class="fa-solid fa-circle-check text-emerald-600 dark:text-emerald-400 text-sm"></i>
                        </div>

                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <div class="w-9 h-9 rounded-lg bg-emerald-500/10 border border-emerald-500/20 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-base">
                                    <i class="fa-solid fa-receipt"></i>
                                </div>
                                <div class="flex flex-col">
                                    <span class="text-xs font-bold text-slate-900 dark:text-white">3. Recibo Agua / Luz</span>
                                    <span class="text-[11px] text-slate-500 dark:text-slate-400">Comprobante de domicilio</span>
                                </div>
                            </div>
                            <i class="fa-solid fa-circle-check text-emerald-600 dark:text-emerald-400 text-sm"></i>
                        </div>

                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <div class="w-9 h-9 rounded-lg bg-emerald-500/10 border border-emerald-500/20 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-base">
                                    <i class="fa-solid fa-users"></i>
                                </div>
                                <div class="flex flex-col">
                                    <span class="text-xs font-bold text-slate-900 dark:text-white">4. Recomendaciones</span>
                                    <span class="text-[11px] text-slate-500 dark:text-slate-400">4 contactos (2 fam / 2 pers)</span>
                                </div>
                            </div>
                            <i class="fa-solid fa-circle-check text-emerald-600 dark:text-emerald-400 text-sm"></i>
                        </div>

                    </div>

                    <div class="bg-blue-500/10 border border-blue-500/30 rounded-xl p-3.5 flex items-center gap-3 text-xs text-blue-700 dark:text-blue-300 font-medium">
                        <i class="fa-solid fa-circle-info text-base text-blue-500"></i>
                        <span>Las 4 recomendaciones se utilizarán para comunicación directa únicamente en caso de atrasos en el pago de cuotas o localización de respaldo.</span>
                    </div>

                </section>

                <!-- SECCIÓN GUÍA DEL PROCESO DE CRÉDITO PERSONAL -->
                <section class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 sm:p-8 shadow-sm dark:shadow-xl flex flex-col gap-6">
                    
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-xl bg-emerald-500/20 border border-emerald-400/40 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-xl">
                            <i class="fa-solid fa-diagram-project"></i>
                        </div>
                        <div>
                            <h2 class="text-xl font-extrabold text-slate-900 dark:text-white">Guía del Proceso de Crédito Personal</h2>
                            <p class="text-xs text-slate-500 dark:text-slate-400">Flujograma transparente desde la pre-calificación hasta el desembolso de fondos</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                        
                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-5 flex flex-col gap-2">
                            <div class="flex items-center justify-between">
                                <div class="w-7 h-7 rounded-lg bg-emerald-500/20 text-emerald-600 dark:text-emerald-400 font-bold text-xs flex items-center justify-center">1</div>
                                <i class="fa-solid fa-calculator text-slate-400 text-sm"></i>
                            </div>
                            <h3 class="text-sm font-bold text-slate-900 dark:text-white mt-1">1. Pre-Calificación</h3>
                            <p class="text-xs text-slate-500 dark:text-slate-400 leading-relaxed">
                                Simula tu cuota e ingresa la pre-solicitud en línea para verificar tu capacidad crediticia.
                            </p>
                        </div>

                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-5 flex flex-col gap-2">
                            <div class="flex items-center justify-between">
                                <div class="w-7 h-7 rounded-lg bg-emerald-500/20 text-emerald-600 dark:text-emerald-400 font-bold text-xs flex items-center justify-center">2</div>
                                <i class="fa-solid fa-magnifying-glass text-slate-400 text-sm"></i>
                            </div>
                            <h3 class="text-sm font-bold text-slate-900 dark:text-white mt-1">2. Evaluación Crediticia</h3>
                            <p class="text-xs text-slate-500 dark:text-slate-400 leading-relaxed">
                                Revisión formal de constancia de sueldo, récord crediticio y referencias personales.
                            </p>
                        </div>

                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-5 flex flex-col gap-2">
                            <div class="flex items-center justify-between">
                                <div class="w-7 h-7 rounded-lg bg-emerald-500/20 text-emerald-600 dark:text-emerald-400 font-bold text-xs flex items-center justify-center">3</div>
                                <i class="fa-solid fa-file-signature text-slate-400 text-sm"></i>
                            </div>
                            <h3 class="text-sm font-bold text-slate-900 dark:text-white mt-1">3. Análisis y Aprobación</h3>
                            <p class="text-xs text-slate-500 dark:text-slate-400 leading-relaxed">
                                Emisión de la resolución favorable de crédito y elaboración del contrato mutuo.
                            </p>
                        </div>

                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-5 flex flex-col gap-2">
                            <div class="flex items-center justify-between">
                                <div class="w-7 h-7 rounded-lg bg-emerald-500/20 text-emerald-600 dark:text-emerald-400 font-bold text-xs flex items-center justify-center">4</div>
                                <i class="fa-solid fa-hand-holding-dollar text-slate-400 text-sm"></i>
                            </div>
                            <h3 class="text-sm font-bold text-slate-900 dark:text-white mt-1">4. Firma y Desembolso</h3>
                            <p class="text-xs text-slate-500 dark:text-slate-400 leading-relaxed">
                                Firma presencial o digital del documento y abono inmediato a tu cuenta CoopFácil.
                            </p>
                        </div>

                    </div>

                </section>

                <!-- FORMULARIO DE SOLICITUD EN LÍNEA -->
                <section class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-blue-500/40 rounded-2xl p-6 sm:p-8 shadow-sm dark:shadow-xl flex flex-col gap-6">
                    
                    <div class="flex items-center gap-3 border-b border-slate-200 dark:border-slate-800 pb-4">
                        <div class="w-10 h-10 rounded-xl bg-blue-500/20 border border-blue-400/30 flex items-center justify-center text-blue-600 dark:text-blue-400 text-xl">
                            <i class="fa-solid fa-file-signature"></i>
                        </div>
                        <div>
                            <span class="text-xs font-bold uppercase tracking-wider text-blue-600 dark:text-blue-400">SOLICITUD EN LÍNEA</span>
                            <h2 class="text-xl sm:text-2xl font-extrabold text-slate-900 dark:text-white">Formulario de Pre-Aprobación de Crédito Personal</h2>
                        </div>
                    </div>

                    <asp:Panel ID="pnlMensajeSolicitud" runat="server" Visible="false" CssClass="mb-2 p-4 rounded-xl border flex items-center gap-3 text-xs font-bold">
                        <asp:Literal ID="litMensajeSolicitud" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="flex flex-col gap-6">
                        
                        <!-- BLOQUE 1: DATOS PERSONALES Y FINANCIEROS -->
                        <div class="flex flex-col gap-4">
                            <h3 class="text-xs font-bold uppercase tracking-wider text-emerald-600 dark:text-emerald-400 border-b border-slate-200 dark:border-slate-800 pb-2 flex items-center gap-2">
                                <i class="fa-solid fa-user-gear text-sm"></i> 1. Datos Personales y Financieros del Solicitante
                            </h3>

                            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                                
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Nombre Completo <span class="text-blue-600 dark:text-blue-400">*</span></label>
                                    <asp:TextBox ID="txtNombre" runat="server" autocomplete="off" AutoCompleteType="Disabled" oninput="filtrarSoloLetras(this)" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition font-medium" placeholder="Ej. Leonardo Vásquez"></asp:TextBox>
                                </div>

                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-bold text-slate-700 dark:text-slate-300">DUI <span class="text-blue-600 dark:text-blue-400">*</span></label>
                                    <asp:TextBox ID="txtDUI" runat="server" maxlength="10" autocomplete="off" AutoCompleteType="Disabled" oninput="formatearDUI(this)" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition font-medium" placeholder="00000000-0"></asp:TextBox>
                                </div>

                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Teléfono <span class="text-blue-600 dark:text-blue-400">*</span></label>
                                    <asp:TextBox ID="txtTelefono" runat="server" maxlength="9" autocomplete="off" AutoCompleteType="Disabled" oninput="formatearTelefono(this)" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition font-medium" placeholder="7777-8888"></asp:TextBox>
                                </div>

                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Correo Electrónico <span class="text-blue-600 dark:text-blue-400">*</span></label>
                                    <asp:TextBox ID="txtCorreo" runat="server" TextMode="Email" autocomplete="off" AutoCompleteType="Disabled" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition font-medium" placeholder="correo@ejemplo.com"></asp:TextBox>
                                </div>

                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                                
                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Ingresos Mensuales Netos ($) <span class="text-blue-600 dark:text-blue-400">*</span></label>
                                    <asp:TextBox ID="txtIngresos" runat="server" TextMode="Number" step="0.01" min="408.80" autocomplete="off" AutoCompleteType="Disabled" onkeydown="if(event.key==='-') event.preventDefault();" onblur="validarMinimoIngreso(this)" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition font-medium" placeholder="Ej. 800.00"></asp:TextBox>
                                </div>

                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Monto Solicitado ($) <span class="text-blue-600 dark:text-blue-400">*</span></label>
                                    <asp:TextBox ID="txtMontoSolicitado" runat="server" TextMode="Number" step="100" autocomplete="off" AutoCompleteType="Disabled" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition font-medium" placeholder="5000"></asp:TextBox>
                                </div>

                                <div class="flex flex-col gap-1.5">
                                    <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Plazo Deseado <span class="text-blue-600 dark:text-blue-400">*</span></label>
                                    <asp:DropDownList ID="ddlPlazo" runat="server" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-blue-500 transition font-medium">
                                        <asp:ListItem Text="12 Meses (1 Año)" Value="12"></asp:ListItem>
                                        <asp:ListItem Text="24 Meses (2 Años)" Value="24"></asp:ListItem>
                                        <asp:ListItem Text="36 Meses (3 Años)" Value="36" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="48 Meses (4 Años)" Value="48"></asp:ListItem>
                                        <asp:ListItem Text="60 Meses (5 Años)" Value="60"></asp:ListItem>
                                        <asp:ListItem Text="72 Meses (6 Años)" Value="72"></asp:ListItem>
                                        <asp:ListItem Text="84 Meses (7 Años)" Value="84"></asp:ListItem>
                                        <asp:ListItem Text="120 Meses (10 Años)" Value="120"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                            </div>
                        </div>

                        <!-- BLOQUE 2: RECOMENDACIONES DE LOCALIZACIÓN -->
                        <div class="flex flex-col gap-4">
                            <div class="flex items-center justify-between border-b border-slate-200 dark:border-slate-800 pb-2">
                                <h3 class="text-xs font-bold uppercase tracking-wider text-emerald-600 dark:text-emerald-400 flex items-center gap-2">
                                    <i class="fa-solid fa-users text-sm"></i> 2. Recomendaciones de Localización (2 Personales y 2 Familiares)
                                </h3>
                                <span class="text-[10px] text-slate-500 dark:text-slate-400 italic">* Para localización en caso de mora</span>
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                
                                <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex flex-col gap-3">
                                    <span class="text-xs font-bold text-blue-600 dark:text-blue-400 uppercase tracking-wider">REFERENCIA PERSONAL 1 *</span>
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                        <asp:TextBox ID="txtRefPersonal1Nombre" runat="server" autocomplete="off" AutoCompleteType="Disabled" oninput="filtrarSoloLetras(this)" CssClass="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition" placeholder="Nombre completo"></asp:TextBox>
                                        <asp:TextBox ID="txtRefPersonal1Tel" runat="server" maxlength="9" autocomplete="off" AutoCompleteType="Disabled" oninput="formatearTelefono(this)" CssClass="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition" placeholder="7000-0000"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex flex-col gap-3">
                                    <span class="text-xs font-bold text-blue-600 dark:text-blue-400 uppercase tracking-wider">REFERENCIA PERSONAL 2 *</span>
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                        <asp:TextBox ID="txtRefPersonal2Nombre" runat="server" autocomplete="off" AutoCompleteType="Disabled" oninput="filtrarSoloLetras(this)" CssClass="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition" placeholder="Nombre completo"></asp:TextBox>
                                        <asp:TextBox ID="txtRefPersonal2Tel" runat="server" maxlength="9" autocomplete="off" AutoCompleteType="Disabled" oninput="formatearTelefono(this)" CssClass="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition" placeholder="7000-0000"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex flex-col gap-3">
                                    <span class="text-xs font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-wider">REFERENCIA FAMILIAR 1 *</span>
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                        <asp:TextBox ID="txtRefFamiliar1Nombre" runat="server" autocomplete="off" AutoCompleteType="Disabled" oninput="filtrarSoloLetras(this)" CssClass="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition" placeholder="Nombre completo"></asp:TextBox>
                                        <asp:TextBox ID="txtRefFamiliar1Tel" runat="server" maxlength="9" autocomplete="off" AutoCompleteType="Disabled" oninput="formatearTelefono(this)" CssClass="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition" placeholder="7000-0000"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex flex-col gap-3">
                                    <span class="text-xs font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-wider">REFERENCIA FAMILIAR 2 *</span>
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                                        <asp:TextBox ID="txtRefFamiliar2Nombre" runat="server" autocomplete="off" AutoCompleteType="Disabled" oninput="filtrarSoloLetras(this)" CssClass="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition" placeholder="Nombre completo"></asp:TextBox>
                                        <asp:TextBox ID="txtRefFamiliar2Tel" runat="server" maxlength="9" autocomplete="off" AutoCompleteType="Disabled" oninput="formatearTelefono(this)" CssClass="bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition" placeholder="7000-0000"></asp:TextBox>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <!-- BLOQUE 3: ADJUNTAR COMPROBANTES CON BOTÓN DE QUITAR -->
                        <div class="flex flex-col gap-4">
                            <div class="flex items-center justify-between border-b border-slate-200 dark:border-slate-800 pb-2">
                                <h3 class="text-xs font-bold uppercase tracking-wider text-emerald-600 dark:text-emerald-400 flex items-center gap-2">
                                    <i class="fa-solid fa-paperclip text-sm"></i> 3. Adjuntar Comprobantes y Documentación (Agua/Luz / Constancia)
                                </h3>
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                
                                <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-5 flex flex-col justify-between gap-3">
                                    <div class="flex flex-col gap-2">
                                        <label class="text-xs font-bold text-slate-900 dark:text-white flex items-center gap-2">
                                            <i class="fa-solid fa-file-invoice text-emerald-600 dark:text-emerald-400"></i> Recibo de Agua / Luz o DUI <span class="text-blue-600 dark:text-blue-400">*</span>
                                        </label>
                                        <asp:FileUpload ID="fulRecibo" runat="server" onchange="verificarArchivo(this, 'btnQuitarRecibo', 'lblStatusRecibo')" CssClass="block w-full text-xs text-slate-500 dark:text-slate-400 file:mr-4 file:py-2.5 file:px-4 file:rounded-xl file:border-0 file:text-xs file:font-bold file:bg-emerald-600 file:text-white hover:file:bg-emerald-500 cursor-pointer transition" />
                                        <span id="lblStatusRecibo" class="hidden text-[11px] font-bold text-emerald-600 dark:text-emerald-400 mt-1"></span>
                                        <button type="button" id="btnQuitarRecibo" onclick="limpiarFileUpload('<%= fulRecibo.ClientID %>', 'btnQuitarRecibo', 'lblStatusRecibo')" class="hidden mt-1 w-full bg-red-500/10 hover:bg-red-500/20 text-red-600 dark:text-red-400 border border-red-500/30 font-bold px-3 py-2 rounded-xl text-xs transition flex items-center justify-center gap-1.5" title="Quitar archivo seleccionado">
                                            <i class="fa-solid fa-trash-can"></i> Quitar Archivo
                                        </button>
                                    </div>
                                    <span class="text-[10px] text-slate-400 dark:text-slate-500">Formatos recomendados: .pdf, .jpg, .png (Máx. 5MB)</span>
                                </div>

                                <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-5 flex flex-col justify-between gap-3">
                                    <div class="flex flex-col gap-2">
                                        <label class="text-xs font-bold text-slate-900 dark:text-white flex items-center gap-2">
                                            <i class="fa-solid fa-file-signature text-emerald-600 dark:text-emerald-400"></i> Constancia de Sueldo <span class="text-blue-600 dark:text-blue-400">*</span>
                                        </label>
                                        <asp:FileUpload ID="fulConstancia" runat="server" onchange="verificarArchivo(this, 'btnQuitarConstancia', 'lblStatusConstancia')" CssClass="block w-full text-xs text-slate-500 dark:text-slate-400 file:mr-4 file:py-2.5 file:px-4 file:rounded-xl file:border-0 file:text-xs file:font-bold file:bg-emerald-600 file:text-white hover:file:bg-emerald-500 cursor-pointer transition" />
                                        <span id="lblStatusConstancia" class="hidden text-[11px] font-bold text-emerald-600 dark:text-emerald-400 mt-1"></span>
                                        <button type="button" id="btnQuitarConstancia" onclick="limpiarFileUpload('<%= fulConstancia.ClientID %>', 'btnQuitarConstancia', 'lblStatusConstancia')" class="hidden mt-1 w-full bg-red-500/10 hover:bg-red-500/20 text-red-600 dark:text-red-400 border border-red-500/30 font-bold px-3 py-2 rounded-xl text-xs transition flex items-center justify-center gap-1.5" title="Quitar archivo seleccionado">
                                            <i class="fa-solid fa-trash-can"></i> Quitar Archivo
                                        </button>
                                    </div>
                                    <span class="text-[10px] text-slate-400 dark:text-slate-500">Formatos recomendados: .pdf, .jpg, .png (Máx. 5MB)</span>
                                </div>

                            </div>
                        </div>

                        <!-- BOTÓN DE ENVÍO -->
                        <asp:Button ID="btnEnviarSolicitud" runat="server" Text="Enviar Solicitud de Crédito Personal" OnClick="btnEnviarSolicitud_Click" CssClass="mt-2 w-full bg-blue-600 hover:bg-blue-500 text-white font-bold text-sm py-3.5 rounded-xl shadow-lg shadow-blue-900/30 transition cursor-pointer" />

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

        function filtrarSoloLetras(input) {
            if (!input) return;
            input.value = input.value.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]/g, '');
        }

        function formatearTelefono(input) {
            if (!input) return;
            let val = input.value.replace(/\D/g, '');
            if (val.length > 8) val = val.substring(0, 8);
            if (val.length > 4) {
                input.value = val.substring(0, 4) + '-' + val.substring(4, 8);
            } else {
                input.value = val;
            }
        }

        function formatearDUI(input) {
            if (!input) return;
            let val = input.value.replace(/\D/g, '');
            if (val.length > 9) val = val.substring(0, 9);
            if (val.length > 8) {
                input.value = val.substring(0, 8) + '-' + val.substring(8, 9);
            } else {
                input.value = val;
            }
        }

        function formatearMontoInput(input) {
            if (!input) return;
            let valorLimpio = input.value.replace(/[^0-9]/g, '');
            if (valorLimpio === '') {
                input.value = '';
                return;
            }
            let numero = parseInt(valorLimpio, 10);
            input.value = numero.toLocaleString('en-US');
        }

        function validarMinimoIngreso(input) {
            if (!input || input.value === '') return;
            let val = parseFloat(input.value);
            if (isNaN(val) || val < 408.80) {
                alert('El ingreso mensual neto no puede ser negativo ni menor al salario mínimo vigente de El Salvador ($408.80 USD).');
                input.value = '408.80';
            }
        }

        function verificarArchivo(input, idBtnQuitar, idStatus) {
            const btn = document.getElementById(idBtnQuitar);
            const lbl = document.getElementById(idStatus);
            if (input.files && input.files.length > 0) {
                const file = input.files[0];
                if (btn) btn.classList.remove('hidden');
                if (lbl) {
                    lbl.innerText = '✓ Archivo listo: ' + file.name;
                    lbl.classList.remove('hidden');
                }
            } else {
                if (btn) btn.classList.add('hidden');
                if (lbl) {
                    lbl.innerText = '';
                    lbl.classList.add('hidden');
                }
            }
        }

        function limpiarFileUpload(idFileUpload, idBtnQuitar, idStatus) {
            const input = document.getElementById(idFileUpload);
            if (input) input.value = '';
            const btn = document.getElementById(idBtnQuitar);
            if (btn) btn.classList.add('hidden');
            const lbl = document.getElementById(idStatus);
            if (lbl) {
                lbl.innerText = '';
                lbl.classList.add('hidden');
            }
        }

        function calcularCredito() {
            const rawVal = document.getElementById('simMonto').value.replace(/,/g, '');
            const monto = parseFloat(rawVal) || 5000;
            const plazo = parseInt(document.getElementById('simPlazo').value) || 36;

            const tasaAnual = 0.10; // 10% ANUAL
            const tasaMensual = tasaAnual / 12.0;

            const cuotaBase = (monto * tasaMensual) / (1 - Math.pow(1 + tasaMensual, -plazo));
            const cuotaTotal = cuotaBase;

            const interesMes1 = monto * tasaMensual;
            const capitalMes1 = cuotaBase - interesMes1;

            const pctCapital = ((capitalMes1 / cuotaTotal) * 100).toFixed(1);
            const pctInteres = ((interesMes1 / cuotaTotal) * 100).toFixed(1);

            document.getElementById('lblMontoTexto').innerText = '$' + monto.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblCuotaEstimada').innerText = '$' + cuotaTotal.toFixed(2);

            document.getElementById('lblAbonoCapital').innerText = '$' + capitalMes1.toFixed(2);
            document.getElementById('lblCapitalPct').innerText = pctCapital + '%';

            document.getElementById('lblInteresMes').innerText = '$' + interesMes1.toFixed(2);
            document.getElementById('lblInteresPct').innerText = pctInteres + '%';

            document.getElementById('barCapital').style.width = pctCapital + '%';
            document.getElementById('barInteres').style.width = pctInteres + '%';

            const txtMontoForm = document.getElementById('<%= txtMontoSolicitado.ClientID %>');
            const ddlPlazoForm = document.getElementById('<%= ddlPlazo.ClientID %>');
            if (txtMontoForm) txtMontoForm.value = monto;
            if (ddlPlazoForm) ddlPlazoForm.value = plazo;

            let htmlTabla = '';
            let saldo = monto;

            for (let i = 1; i <= Math.min(4, plazo); i++) {
                let interes = saldo * tasaMensual;
                let capital = cuotaBase - interes;
                saldo -= capital;

                htmlTabla += `
                    <tr>
                        <td class="p-3 font-bold text-blue-600 dark:text-blue-400">Mes ${i}</td>
                        <td class="p-3">$${cuotaBase.toFixed(2)}</td>
                        <td class="p-3">$${interes.toFixed(2)}</td>
                        <td class="p-3">$${capital.toFixed(2)}</td>
                        <td class="p-3 font-bold">$${Math.max(0, saldo).toFixed(2)}</td>
                    </tr>`;
            }

            document.getElementById('tblAmortizacion').innerHTML = htmlTabla;
            document.getElementById('lblMensajeTabla').innerText = `... (${plazo - Math.min(4, plazo)} meses restantes con la misma cuota base de $${cuotaBase.toFixed(2)}) ...`;
        }

        document.addEventListener('DOMContentLoaded', function () {
            const isDark = document.documentElement.classList.contains('dark');
            updateThemeIcons(isDark);

            calcularCredito();
        });
    </script>
</body>
</html>