<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreditoVehicular.aspx.cs" Inherits="CoopFacil.Pages.CreditoVehicular" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" class="dark">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Crédito Vehicular - CoopFacil</title>
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
            <main class="max-w-7xl mx-auto px-6 py-10 flex flex-col gap-10 flex-grow w-full">
                
                <!-- ÁREA DEL CRÉDITO (TITULAR Y CONDICIONES) -->
                <div class="flex flex-col gap-3">
                    <a href="Servicios.aspx" class="text-xs font-bold text-emerald-600 dark:text-emerald-400 hover:underline flex items-center gap-2 w-fit">
                        <i class="fa-solid fa-arrow-left"></i> Volver al Portafolio de Servicios
                    </a>
                    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 mt-2">
                        <div>
                            <span class="text-xs font-bold uppercase tracking-wider text-emerald-600 dark:text-emerald-400">FINANCIAMIENTO AUTOMOTRIZ</span>
                            <h1 class="text-3xl sm:text-4xl font-extrabold text-slate-900 dark:text-white tracking-tight flex items-center gap-3 mt-1">
                                <i class="fa-solid fa-car text-emerald-600 dark:text-emerald-400"></i> Crédito Vehicular
                            </h1>
                        </div>
                        <div class="bg-white dark:bg-[#0F233D] border border-emerald-500/40 px-4 py-2 rounded-xl flex items-center gap-3 shadow-sm dark:shadow-lg">
                            <span class="text-xs text-slate-600 dark:text-slate-300 font-medium">Tasa Preferencial Auto:</span>
                            <span class="text-lg font-black text-emerald-600 dark:text-emerald-400">10% ANUAL</span>
                        </div>
                    </div>
                    <p class="text-sm sm:text-base text-slate-600 dark:text-slate-300 leading-relaxed max-w-3xl">
                        Adquiere tu vehículo nuevo o usado con garantía prendaria. Financiamos el 100% del precio comercial con plazos de 12 a 72 meses y cuota fija garantizada.
                    </p>
                </div>

                <!-- BLOQUE SUPERIOR: COTIZADOR VEHICULAR (IZQ) Y DESGLOSE DE CUOTA (DER) -->
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                    
                    <!-- IZQUIERDA: COTIZADOR VEHICULAR (SIN PRIMA + TABLA RESUMIDA) -->
                    <div class="lg:col-span-6 bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 shadow-sm dark:shadow-xl flex flex-col gap-6">
                        <div class="flex items-center gap-3 border-b border-slate-200 dark:border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-emerald-500/20 border border-emerald-400/30 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-xl">
                                <i class="fa-solid fa-calculator"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-slate-900 dark:text-white">Cotizador Vehicular</h2>
                                <p class="text-xs text-slate-500 dark:text-slate-400">Calcula tu cuota a plazos flexibles de 12 a 72 meses (10% ANUAL)</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                            <!-- ESTADO DEL VEHÍCULO -->
                            <div class="flex flex-col gap-2">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300 uppercase">Estado del Vehículo <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                                <asp:DropDownList ID="ddlEstadoVehiculo" runat="server" onchange="calcularCotizadorVehicular()" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2.5 text-xs font-bold text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition">
                                    <asp:ListItem Text="✨ Vehículo Nuevo" Value="Nuevo" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="🚗 Vehículo Usado" Value="Usado"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <!-- PLAZO EN MESES -->
                            <div class="flex flex-col gap-2">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300 uppercase">Plazo en Meses <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                                <asp:DropDownList ID="ddlPlazoMeses" runat="server" onchange="sincronizarPlazoFormulario(this.value); calcularCotizadorVehicular();" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2.5 text-xs font-bold text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition">
                                    <asp:ListItem Text="12 Meses (1 Año)" Value="12"></asp:ListItem>
                                    <asp:ListItem Text="24 Meses (2 Años)" Value="24"></asp:ListItem>
                                    <asp:ListItem Text="36 Meses (3 Años)" Value="36"></asp:ListItem>
                                    <asp:ListItem Text="48 Meses (4 Años)" Value="48" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="60 Meses (5 Años)" Value="60"></asp:ListItem>
                                    <asp:ListItem Text="72 Meses (6 Años)" Value="72"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <!-- PRECIO COMERCIAL DEL VEHÍCULO -->
                        <div class="flex flex-col gap-2">
                            <label class="text-xs font-bold text-slate-700 dark:text-slate-300 uppercase">Precio Comercial del Vehículo ($ USD)</label>
                            <div class="relative">
                                <span class="absolute left-3.5 top-2.5 text-slate-500 dark:text-slate-400 font-bold">$</span>
                                <asp:TextBox ID="txtPrecioComercial" runat="server" TextMode="Number" Text="18000" min="3000" step="any" oninput="sincronizarMontoFormulario(this.value); calcularCotizadorVehicular();" CssClass="w-full bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl pl-8 pr-3 py-2.5 text-xs font-bold text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition" placeholder="18000"></asp:TextBox>
                            </div>
                        </div>

                        <!-- MONTO TOTAL A FINANCIAR (IGUAL AL PRECIO COMERCIAL) -->
                        <div class="bg-slate-100 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex justify-between items-center text-xs">
                            <span class="text-slate-500 dark:text-slate-400 font-bold uppercase">Monto Total a Financiar:</span>
                            <span id="lblMontoFinanciar" class="text-lg font-black text-emerald-600 dark:text-emerald-400">$18,000.00</span>
                        </div>

                        <!-- TABLA RESUMIDA DE LOS PRIMEROS MESES -->
                        <div class="flex flex-col gap-2">
                            <span class="text-xs font-bold text-slate-700 dark:text-slate-300 uppercase flex items-center gap-2">
                                <i class="fa-solid fa-table-list text-emerald-600 dark:text-emerald-400"></i> Tabla Resumida de los Primeros Meses
                            </span>
                            <div class="overflow-x-auto rounded-xl border border-slate-200 dark:border-slate-800">
                                <table class="w-full text-left text-[11px] text-slate-700 dark:text-slate-300">
                                    <thead class="bg-slate-100 dark:bg-[#0B1A30] text-emerald-600 dark:text-emerald-400 font-bold uppercase border-b border-slate-200 dark:border-slate-800">
                                        <tr>
                                            <th class="py-2 px-3">Mes</th>
                                            <th class="py-2 px-3">Cuota Base</th>
                                            <th class="py-2 px-3">Interés</th>
                                            <th class="py-2 px-3">Capital</th>
                                            <th class="py-2 px-3 text-right">Saldo Restante</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tblAmortizacionBody" class="divide-y divide-slate-200 dark:divide-slate-800/60 font-medium">
                                        <!-- Generado dinámicamente -->
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <span class="text-[11px] text-slate-500 dark:text-slate-400 italic text-center">
                            * Cálculo estimado sobre sistema de cuota nivelada a Tasa del 10.00% ANUAL.
                        </span>
                    </div>

                    <!-- DERECHA: DESGLOSE DE CUOTA ESTIMADA -->
                    <div class="lg:col-span-6 bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 shadow-sm dark:shadow-xl flex flex-col gap-6">
                        <div class="flex items-center gap-3 border-b border-slate-200 dark:border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-blue-500/20 border border-blue-400/30 flex items-center justify-center text-blue-600 dark:text-blue-400 text-xl">
                                <i class="fa-solid fa-chart-pie"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-slate-900 dark:text-white">Desglose de Cuota Estimada</h2>
                                <p class="text-xs text-slate-500 dark:text-slate-400">Incluye capital, intereses y estimación de seguros obligatorios</p>
                            </div>
                        </div>

                        <!-- CUOTA TOTAL DESTACADA -->
                        <div class="bg-slate-100 dark:bg-[#0B1A30] border border-emerald-500/40 rounded-xl p-5 text-center flex flex-col items-center justify-center shadow-inner">
                            <span class="text-xs font-bold text-slate-500 dark:text-slate-400 uppercase tracking-wider">Cuota Mensual Estimada</span>
                            <span id="lblCuotaTotal" class="text-3xl font-black text-emerald-600 dark:text-emerald-400 mt-1">$471.44</span>
                            <span id="lblTasaAplicada" class="text-[10px] text-slate-500 dark:text-slate-400 mt-1">* Tasa del 10.00% ANUAL garantizada</span>
                        </div>

                        <!-- BARRA VISUAL DE DISTRIBUCIÓN -->
                        <div class="space-y-4">
                            <span class="text-xs font-bold text-slate-700 dark:text-slate-300 uppercase block border-b border-slate-200 dark:border-slate-800 pb-2">Distribución de la Cuota (Mes 1):</span>

                            <div class="w-full bg-slate-100 dark:bg-[#0B1A30] h-3 rounded-full overflow-hidden flex border border-slate-200 dark:border-slate-800 p-0.5">
                                <div id="barCapital" class="bg-emerald-500 h-full rounded-l-full transition-all duration-300" style="width: 65%;"></div>
                                <div id="barInteres" class="bg-blue-500 h-full transition-all duration-300" style="width: 32%;"></div>
                                <div id="barSegVida" class="bg-purple-500 h-full transition-all duration-300" style="width: 1%;"></div>
                                <div id="barSegDanos" class="bg-amber-500 h-full rounded-r-full transition-all duration-300" style="width: 2%;"></div>
                            </div>

                            <!-- FILAS DE DESGLOSE INDIVIDUAL -->
                            <div class="space-y-2 text-xs">
                                
                                <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-3 flex items-center justify-between">
                                    <div class="flex items-center gap-2.5">
                                        <div class="w-7 h-7 rounded-lg bg-emerald-500/20 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-xs">
                                            <i class="fa-solid fa-building-columns"></i>
                                        </div>
                                        <span class="font-bold text-slate-900 dark:text-white">Abono Directo a Capital:</span>
                                    </div>
                                    <div class="flex items-center gap-3">
                                        <span id="lblPctCapital" class="text-[10px] text-emerald-600 dark:text-emerald-400 font-semibold">65.1%</span>
                                        <span id="lblDesgloseCapital" class="font-extrabold text-emerald-600 dark:text-emerald-400">$307.04</span>
                                    </div>
                                </div>

                                <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-3 flex items-center justify-between">
                                    <div class="flex items-center gap-2.5">
                                        <div class="w-7 h-7 rounded-lg bg-blue-500/20 text-blue-600 dark:text-blue-400 flex items-center justify-center text-xs">
                                            <i class="fa-solid fa-percent"></i>
                                        </div>
                                        <span class="font-bold text-slate-900 dark:text-white">Intereses Financieros (10% ANUAL):</span>
                                    </div>
                                    <div class="flex items-center gap-3">
                                        <span id="lblPctInteres" class="text-[10px] text-blue-600 dark:text-blue-400 font-semibold">31.8%</span>
                                        <span id="lblDesgloseInteres" class="font-extrabold text-blue-600 dark:text-blue-400">$150.00</span>
                                    </div>
                                </div>

                                <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-3 flex items-center justify-between">
                                    <div class="flex items-center gap-2.5">
                                        <div class="w-7 h-7 rounded-lg bg-emerald-500/20 text-emerald-600 dark:text-emerald-300 flex items-center justify-center text-xs">
                                            <i class="fa-solid fa-chart-line"></i>
                                        </div>
                                        <span class="font-bold text-slate-900 dark:text-white">Porcentaje de Financiamiento:</span>
                                    </div>
                                    <div class="flex items-center gap-3">
                                        <span id="lblPctFinanciado" class="font-extrabold text-emerald-600 dark:text-emerald-400">100.0%</span>
                                    </div>
                                </div>

                                <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-3 flex items-center justify-between">
                                    <div class="flex items-center gap-2.5">
                                        <div class="w-7 h-7 rounded-lg bg-purple-500/20 text-purple-600 dark:text-purple-400 flex items-center justify-center text-xs">
                                            <i class="fa-solid fa-heart-pulse"></i>
                                        </div>
                                        <span class="font-bold text-slate-900 dark:text-white">Seguro de Vida Colectivo:</span>
                                    </div>
                                    <div class="flex items-center gap-3">
                                        <span id="lblPctSegVida" class="text-[10px] text-purple-600 dark:text-purple-400 font-semibold">1.1%</span>
                                        <span id="lblSeguroVida" class="font-extrabold text-purple-600 dark:text-purple-300">$5.40</span>
                                    </div>
                                </div>

                                <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-3 flex items-center justify-between">
                                    <div class="flex items-center gap-2.5">
                                        <div class="w-7 h-7 rounded-lg bg-amber-500/20 text-amber-600 dark:text-amber-400 flex items-center justify-center text-xs">
                                            <i class="fa-solid fa-shield-halved"></i>
                                        </div>
                                        <span class="font-bold text-slate-900 dark:text-white">Seguro de Daños / Vehicular:</span>
                                    </div>
                                    <div class="flex items-center gap-3">
                                        <span id="lblPctSegDanos" class="text-[10px] text-amber-600 dark:text-amber-400 font-semibold">1.9%</span>
                                        <span id="lblSeguroDanos" class="font-extrabold text-amber-600 dark:text-amber-300">$9.00</span>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <span class="text-[11px] text-slate-500 dark:text-slate-400 italic text-center mt-1">
                            * Proyección orientativa sujeta a aprobación de crédito e inspección prendaria del vehículo.
                        </span>
                    </div>

                </div>

                <!-- SECCIÓN REQUISITOS -->
                <section class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/80 rounded-2xl p-6 sm:p-8 shadow-sm dark:shadow-xl flex flex-col gap-6">
                    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 border-b border-slate-200 dark:border-slate-800 pb-4">
                        <div class="flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-blue-500/20 border border-blue-400/30 flex items-center justify-center text-blue-600 dark:text-blue-400 text-xl">
                                <i class="fa-solid fa-folder-open"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-slate-900 dark:text-white">Requisitos para Solicitud de Crédito Vehicular</h2>
                                <p class="text-xs text-slate-500 dark:text-slate-400">Documentación y referencias obligatorias previas a la aprobación prendaria</p>
                            </div>
                        </div>
                        <span class="text-xs font-bold text-emerald-600 dark:text-emerald-400 bg-slate-50 dark:bg-[#0B1A30] border border-emerald-500/30 px-3.5 py-1.5 rounded-xl">
                            <i class="fa-solid fa-check-double"></i> Verificación Digital y Vehicular
                        </span>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                        
                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex items-center justify-between gap-3 hover:border-emerald-500/50 transition">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-xl bg-emerald-500/20 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-base flex-shrink-0">
                                    <i class="fa-solid fa-id-card"></i>
                                </div>
                                <div class="flex flex-col">
                                    <span class="text-xs font-bold text-slate-900 dark:text-white">1. DUI Vigente</span>
                                    <span class="text-[11px] text-slate-500 dark:text-slate-400 mt-0.5">Ambos lados legibles</span>
                                </div>
                            </div>
                            <i class="fa-solid fa-circle-check text-emerald-600 dark:text-emerald-400 text-lg flex-shrink-0"></i>
                        </div>

                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex items-center justify-between gap-3 hover:border-emerald-500/50 transition">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-xl bg-emerald-500/20 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-base flex-shrink-0">
                                    <i class="fa-solid fa-file-invoice-dollar"></i>
                                </div>
                                <div class="flex flex-col">
                                    <span class="text-xs font-bold text-slate-900 dark:text-white">2. Constancia de Sueldo</span>
                                    <span class="text-[11px] text-slate-500 dark:text-slate-400 mt-0.5">Emisión reciente firmada</span>
                                </div>
                            </div>
                            <i class="fa-solid fa-circle-check text-emerald-600 dark:text-emerald-400 text-lg flex-shrink-0"></i>
                        </div>

                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex items-center justify-between gap-3 hover:border-emerald-500/50 transition">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-xl bg-emerald-500/20 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-base flex-shrink-0">
                                    <i class="fa-solid fa-receipt"></i>
                                </div>
                                <div class="flex flex-col">
                                    <span class="text-xs font-bold text-slate-900 dark:text-white">3. Recibo Agua / Luz</span>
                                    <span class="text-[11px] text-slate-500 dark:text-slate-400 mt-0.5">Comprobante de domicilio</span>
                                </div>
                            </div>
                            <i class="fa-solid fa-circle-check text-emerald-600 dark:text-emerald-400 text-lg flex-shrink-0"></i>
                        </div>

                        <div class="bg-slate-50 dark:bg-[#0B1A30] border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex items-center justify-between gap-3 hover:border-emerald-500/50 transition">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-xl bg-emerald-500/20 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-base flex-shrink-0">
                                    <i class="fa-solid fa-users"></i>
                                </div>
                                <div class="flex flex-col">
                                    <span class="text-xs font-bold text-slate-900 dark:text-white">4. Recomendaciones</span>
                                    <span class="text-[11px] text-slate-500 dark:text-slate-400 mt-0.5">4 contactos (2 fam / 2 pers)</span>
                                </div>
                            </div>
                            <i class="fa-solid fa-circle-check text-emerald-600 dark:text-emerald-400 text-lg flex-shrink-0"></i>
                        </div>

                    </div>

                    <div class="bg-blue-50 dark:bg-blue-950/40 border border-blue-200 dark:border-blue-500/30 rounded-xl p-3.5 text-xs text-blue-800 dark:text-blue-200 flex items-center gap-3">
                        <i class="fa-solid fa-circle-info text-blue-600 dark:text-blue-400 text-base"></i>
                        <span>Las 4 recomendaciones se utilizarán para comunicación directa únicamente en caso de atrasos en el pago de cuotas o localización de respaldo.</span>
                    </div>
                </section>

                <!-- SECCIÓN FORMULARIO DE SOLICITUD DE CRÉDITO VEHICULAR -->
                <section class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-emerald-500/40 rounded-2xl p-6 sm:p-8 shadow-sm dark:shadow-2xl relative overflow-hidden flex flex-col gap-8">
                    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 border-b border-slate-200 dark:border-slate-800 pb-6">
                        <div>
                            <span class="text-xs font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-widest block">EVALUACIÓN EN TIEMPO REAL</span>
                            <h2 class="text-2xl font-extrabold text-slate-900 dark:text-white mt-1 flex items-center gap-2">
                                <i class="fa-solid fa-file-signature text-emerald-600 dark:text-emerald-400"></i> Formulario de Solicitud y Pre-Aprobación Vehicular
                            </h2>
                            <p class="text-xs sm:text-sm text-slate-600 dark:text-slate-300 mt-1">
                                Ingresa tus datos financieros, detalles de la unidad, referencias de localización y proforma para obtener tu dictamen.
                            </p>
                        </div>
                        <div class="hidden sm:flex items-center gap-2 bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 px-3.5 py-2 rounded-xl text-xs font-bold text-slate-700 dark:text-slate-300">
                            <i class="fa-solid fa-shield-halved text-emerald-600 dark:text-emerald-400 text-sm"></i> Garantía Prendaria Registrada
                        </div>
                    </div>

                    <!-- MENSAJE DE FEEDBACK -->
                    <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="p-4 rounded-xl border flex items-center gap-3 text-sm font-bold">
                        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
                    </asp:Panel>

                    <!-- BLOQUE 1: DATOS PERSONALES Y FINANCIEROS -->
                    <div class="flex flex-col gap-4">
                        <span class="text-xs font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-wider flex items-center gap-2 border-b border-slate-200 dark:border-slate-800 pb-2">
                            <i class="fa-solid fa-user"></i> 1. Información Personal, Financiera y del Vehículo
                        </span>

                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
                            
                            <!-- NOMBRE COMPLETO (SOLO LETRAS) -->
                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Nombre Completo <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                                <asp:TextBox ID="txtNombre" runat="server" oninput="filtrarSoloLetras(this)" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="Ej. Carlos Alberto Mendoza"></asp:TextBox>
                            </div>

                            <!-- DUI (SOLO NÚMEROS Y MÁSCARA 00000000-0) -->
                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Documento de Identidad (DUI) <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                                <asp:TextBox ID="txtDUI" runat="server" maxlength="10" oninput="formatearDUI(this)" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="00000000-0"></asp:TextBox>
                            </div>

                            <!-- TELÉFONO (SOLO NÚMEROS Y MÁSCARA 0000-0000) -->
                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Teléfono de Contacto <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                                <asp:TextBox ID="txtTelefono" runat="server" maxlength="9" oninput="formatearTelefono(this)" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="7777-8888"></asp:TextBox>
                            </div>

                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Correo Electrónico <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                                <asp:TextBox ID="txtCorreo" runat="server" TextMode="Email" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="correo@ejemplo.com"></asp:TextBox>
                            </div>

                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Ingresos Mensuales Netos ($) <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                                <asp:TextBox ID="txtIngresos" runat="server" TextMode="Number" step="any" min="1" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition" placeholder="Ej. 1200.00"></asp:TextBox>
                            </div>

                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Marca, Modelo y Año <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                                <asp:TextBox ID="txtMarcaModelo" runat="server" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="Ej. Toyota Corolla 2024"></asp:TextBox>
                            </div>

                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Concesionario / Vendedor <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                                <asp:TextBox ID="txtConcesionario" runat="server" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="Ej. Excel Automotriz / Particular"></asp:TextBox>
                            </div>

                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Monto del Crédito ($) <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                                <asp:TextBox ID="txtMontoSolicitado" runat="server" TextMode="Number" Text="18000" min="3000" step="any" oninput="sincronizarMontoSimulador(this.value); calcularCotizadorVehicular();" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition" placeholder="18000"></asp:TextBox>
                            </div>

                            <div class="flex flex-col gap-1.5">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Plazo Deseado <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                                <asp:DropDownList ID="ddlPlazoSolicitado" runat="server" onchange="sincronizarPlazoSimulador(this.value); calcularCotizadorVehicular();" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500 transition">
                                    <asp:ListItem Text="12 Meses (1 Año)" Value="12"></asp:ListItem>
                                    <asp:ListItem Text="24 Meses (2 Años)" Value="24"></asp:ListItem>
                                    <asp:ListItem Text="36 Meses (3 Años)" Value="36"></asp:ListItem>
                                    <asp:ListItem Text="48 Meses (4 Años)" Value="48" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="60 Meses (5 Años)" Value="60"></asp:ListItem>
                                    <asp:ListItem Text="72 Meses (6 Años)" Value="72"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                        </div>
                    </div>

                    <!-- BLOQUE 2: RECOMENDACIONES DE LOCALIZACIÓN (2 PERSONALES Y 2 FAMILIARES) -->
                    <div class="flex flex-col gap-4 pt-2">
                        <div class="flex items-center justify-between border-b border-slate-200 dark:border-slate-800 pb-2">
                            <span class="text-xs font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-wider flex items-center gap-2">
                                <i class="fa-solid fa-users"></i> 2. Recomendaciones de Localización (2 Personales y 2 Familiares)
                            </span>
                            <span class="text-[10px] text-slate-500 dark:text-slate-400 italic">* Para localización en caso de mora</span>
                        </div>

                        <!-- 2 PERSONALES -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-5 bg-slate-50 dark:bg-[#0B1A30]/60 p-4 rounded-xl border border-slate-200 dark:border-slate-800">
                            
                            <!-- Personal 1 -->
                            <div class="flex flex-col gap-2">
                                <span class="text-[11px] font-bold text-blue-600 dark:text-blue-400 uppercase">Referencia Personal 1 <span class="text-emerald-600 dark:text-emerald-400">*</span></span>
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
                                    <asp:TextBox ID="txtRefPers1Nombre" runat="server" oninput="filtrarSoloLetras(this)" CssClass="bg-white dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="Nombre completo"></asp:TextBox>
                                    <asp:TextBox ID="txtRefPers1Tel" runat="server" maxlength="9" oninput="formatearTelefono(this)" CssClass="bg-white dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="7000-0000"></asp:TextBox>
                                </div>
                            </div>

                            <!-- Personal 2 -->
                            <div class="flex flex-col gap-2">
                                <span class="text-[11px] font-bold text-blue-600 dark:text-blue-400 uppercase">Referencia Personal 2 <span class="text-emerald-600 dark:text-emerald-400">*</span></span>
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
                                    <asp:TextBox ID="txtRefPers2Nombre" runat="server" oninput="filtrarSoloLetras(this)" CssClass="bg-white dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="Nombre completo"></asp:TextBox>
                                    <asp:TextBox ID="txtRefPers2Tel" runat="server" maxlength="9" oninput="formatearTelefono(this)" CssClass="bg-white dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="7000-0000"></asp:TextBox>
                                </div>
                            </div>

                        </div>

                        <!-- 2 FAMILIARES -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-5 bg-slate-50 dark:bg-[#0B1A30]/60 p-4 rounded-xl border border-slate-200 dark:border-slate-800">
                            
                            <!-- Familiar 1 -->
                            <div class="flex flex-col gap-2">
                                <span class="text-[11px] font-bold text-emerald-600 dark:text-emerald-400 uppercase">Referencia Familiar 1 <span class="text-emerald-600 dark:text-emerald-400">*</span></span>
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
                                    <asp:TextBox ID="txtRefFam1Nombre" runat="server" oninput="filtrarSoloLetras(this)" CssClass="bg-white dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="Nombre completo"></asp:TextBox>
                                    <asp:TextBox ID="txtRefFam1Tel" runat="server" maxlength="9" oninput="formatearTelefono(this)" CssClass="bg-white dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="7000-0000"></asp:TextBox>
                                </div>
                            </div>

                            <!-- Familiar 2 -->
                            <div class="flex flex-col gap-2">
                                <span class="text-[11px] font-bold text-emerald-600 dark:text-emerald-400 uppercase">Referencia Familiar 2 <span class="text-emerald-600 dark:text-emerald-400">*</span></span>
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
                                    <asp:TextBox ID="txtRefFam2Nombre" runat="server" oninput="filtrarSoloLetras(this)" CssClass="bg-white dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="Nombre completo"></asp:TextBox>
                                    <asp:TextBox ID="txtRefFam2Tel" runat="server" maxlength="9" oninput="formatearTelefono(this)" CssClass="bg-white dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="7000-0000"></asp:TextBox>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- BLOQUE 3: ADJUNTAR COMPROBANTES CON BOTÓN "QUITAR" -->
                    <div class="flex flex-col gap-4 pt-2">
                        <span class="text-xs font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-wider flex items-center gap-2 border-b border-slate-200 dark:border-slate-800 pb-2">
                            <i class="fa-solid fa-file-arrow-up"></i> 3. Adjuntar Comprobantes y Proforma (Agua/Luz / Constancia / Cotización)
                        </span>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
                            
                            <!-- COMPROBANTE 1 -->
                            <div class="flex flex-col gap-2 bg-slate-50 dark:bg-[#0B1A30]/60 p-4 rounded-xl border border-slate-200 dark:border-slate-800">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Recibo de Agua / Luz o DUI <span class="text-slate-500 dark:text-slate-400 font-normal">(PDF, JPG)</span></label>
                                
                                <div class="flex items-center gap-2">
                                    <asp:FileUpload ID="fileReciboDUI" runat="server" onchange="actualizarEstadoArchivo(this, 'btnQuitarRecibo', 'infoRecibo')" CssClass="bg-white dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-700 dark:text-slate-300 file:mr-2 file:py-1 file:px-2.5 file:rounded-lg file:border-0 file:text-xs file:font-bold file:bg-emerald-600 file:text-white hover:file:bg-emerald-500 transition cursor-pointer flex-grow" />
                                    
                                    <button type="button" id="btnQuitarRecibo" onclick="limpiarArchivo('<%= fileReciboDUI.ClientID %>', 'btnQuitarRecibo', 'infoRecibo')" class="hidden bg-red-600/20 hover:bg-red-600 border border-red-500 text-red-600 dark:text-red-300 hover:text-white px-3 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1">
                                        <i class="fa-solid fa-trash-can"></i> Quitar
                                    </button>
                                </div>

                                <span id="infoRecibo" class="text-[10px] text-slate-500 dark:text-slate-400 italic">No se ha seleccionado archivo</span>
                            </div>

                            <!-- COMPROBANTE 2 -->
                            <div class="flex flex-col gap-2 bg-slate-50 dark:bg-[#0B1A30]/60 p-4 rounded-xl border border-slate-200 dark:border-slate-800">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Constancia de Sueldo <span class="text-slate-500 dark:text-slate-400 font-normal">(PDF, JPG)</span></label>
                                
                                <div class="flex items-center gap-2">
                                    <asp:FileUpload ID="fileConstancia" runat="server" onchange="actualizarEstadoArchivo(this, 'btnQuitarConstancia', 'infoConstancia')" CssClass="bg-white dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-700 dark:text-slate-300 file:mr-2 file:py-1 file:px-2.5 file:rounded-lg file:border-0 file:text-xs file:font-bold file:bg-emerald-600 file:text-white hover:file:bg-emerald-500 transition cursor-pointer flex-grow" />
                                    
                                    <button type="button" id="btnQuitarConstancia" onclick="limpiarArchivo('<%= fileConstancia.ClientID %>', 'btnQuitarConstancia', 'infoConstancia')" class="hidden bg-red-600/20 hover:bg-red-600 border border-red-500 text-red-600 dark:text-red-300 hover:text-white px-3 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1">
                                        <i class="fa-solid fa-trash-can"></i> Quitar
                                    </button>
                                </div>

                                <span id="infoConstancia" class="text-[10px] text-slate-500 dark:text-slate-400 italic">No se ha seleccionado archivo</span>
                            </div>

                            <!-- COMPROBANTE 3 -->
                            <div class="flex flex-col gap-2 bg-slate-50 dark:bg-[#0B1A30]/60 p-4 rounded-xl border border-slate-200 dark:border-slate-800">
                                <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Proforma / Cotización Auto <span class="text-slate-500 dark:text-slate-400 font-normal">(PDF, JPG)</span></label>
                                
                                <div class="flex items-center gap-2">
                                    <asp:FileUpload ID="fileProforma" runat="server" onchange="actualizarEstadoArchivo(this, 'btnQuitarProforma', 'infoProforma')" CssClass="bg-white dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-700 dark:text-slate-300 file:mr-2 file:py-1 file:px-2.5 file:rounded-lg file:border-0 file:text-xs file:font-bold file:bg-emerald-600 file:text-white hover:file:bg-emerald-500 transition cursor-pointer flex-grow" />
                                    
                                    <button type="button" id="btnQuitarProforma" onclick="limpiarArchivo('<%= fileProforma.ClientID %>', 'btnQuitarProforma', 'infoProforma')" class="hidden bg-red-600/20 hover:bg-red-600 border border-red-500 text-red-600 dark:text-red-300 hover:text-white px-3 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1">
                                        <i class="fa-solid fa-trash-can"></i> Quitar
                                    </button>
                                </div>

                                <span id="infoProforma" class="text-[10px] text-slate-500 dark:text-slate-400 italic">No se ha seleccionado archivo</span>
                            </div>

                        </div>
                    </div>

                    <div class="mt-2 flex justify-end">
                        <asp:Button ID="btnSolicitarCredito" runat="server" Text="Evaluar y Solicitar Crédito Vehicular" OnClick="btnSolicitarCredito_Click" CssClass="w-full sm:w-auto bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs px-8 py-3.5 rounded-xl shadow-lg shadow-emerald-950 transition cursor-pointer" />
                    </div>
                </section>

            </main>
        </div>

        <footer class="bg-white dark:bg-[#0F233D] border-t border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400 text-xs text-center py-6 mt-auto transition-colors duration-300">
            <p>© <%= DateTime.Now.Year %> CoopFacil. Todos los derechos reservados.</p>
        </footer>

    </form>

    <!-- SCRIPTS DE COTIZADOR, RESTRICCIONES Y CONTROL DE ARCHIVOS -->
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

        // 1. RESTRICCIÓN: Solo letras, espacios y tildes/ñ
        function filtrarSoloLetras(input) {
            if (!input) return;
            input.value = input.value.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]/g, '');
        }

        // 2. MÁSCARA DUI: Solo números con guion automático (00000000-0)
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

        // 3. MÁSCARA TELÉFONO: Solo números con guion en la mitad (0000-0000)
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

        // 4. ARCHIVOS ADJUNTOS: Estado y visibilidad del botón Quitar
        function actualizarEstadoArchivo(input, btnId, infoId) {
            const btnQuitar = document.getElementById(btnId);
            const infoText = document.getElementById(infoId);

            if (input.files && input.files.length > 0) {
                const nombreArchivo = input.files[0].name;
                if (btnQuitar) btnQuitar.classList.remove('hidden');
                if (infoText) {
                    infoText.innerText = '✓ Archivo listo: ' + nombreArchivo;
                    infoText.className = 'text-[10px] text-emerald-600 dark:text-emerald-400 font-bold';
                }
            } else {
                limpiarArchivo(input.id, btnId, infoId);
            }
        }

        // 5. ARCHIVOS ADJUNTOS: Limpieza de selección
        function limpiarArchivo(fileControlId, btnId, infoId) {
            const fileInput = document.getElementById(fileControlId);
            const btnQuitar = document.getElementById(btnId);
            const infoText = document.getElementById(infoId);

            if (fileInput) fileInput.value = '';
            if (btnQuitar) btnQuitar.classList.add('hidden');
            if (infoText) {
                infoText.innerText = 'No se ha seleccionado archivo';
                infoText.className = 'text-[10px] text-slate-500 dark:text-slate-400 italic';
            }
        }

        // CÁLCULO DEL COTIZADOR VEHICULAR A TASA 10% ANUAL (PRECIO COMERCIAL = MONTO FINANCIADO)
        function calcularCotizadorVehicular() {
            const txtPrecioControl = document.getElementById('<%= txtPrecioComercial.ClientID %>');
            const ddlPlazoControl = document.getElementById('<%= ddlPlazoMeses.ClientID %>');
            const ddlEstadoControl = document.getElementById('<%= ddlEstadoVehiculo.ClientID %>');

            if (!txtPrecioControl || !ddlPlazoControl) return;

            const precio = parseFloat(txtPrecioControl.value) || 0;
            const plazoMeses = parseInt(ddlPlazoControl.value) || 48;
            const estadoVehiculo = ddlEstadoControl ? ddlEstadoControl.value : "Nuevo";

            if (precio <= 0 || plazoMeses <= 0) {
                document.getElementById('lblMontoFinanciar').innerText = '$0.00';
                document.getElementById('lblCuotaTotal').innerText = '$0.00';
                document.getElementById('lblDesgloseCapital').innerText = '$0.00';
                document.getElementById('lblDesgloseInteres').innerText = '$0.00';
                document.getElementById('lblSeguroVida').innerText = '$0.00';
                document.getElementById('lblSeguroDanos').innerText = '$0.00';
                document.getElementById('tblAmortizacionBody').innerHTML = '';
                return;
            }

            const montoFinanciar = precio; // Precio Comercial es igual al Monto Total a Financiar
            const tasaAnual = 0.10; // Tasa del 10% ANUAL
            const tasaMensual = tasaAnual / 12;

            // Fórmula de cuota nivelada PMT
            const factor = Math.pow(1 + tasaMensual, plazoMeses);
            const cuotaBase = montoFinanciar * (tasaMensual * factor) / (factor - 1);

            // Estimaciones de seguros para auto
            const seguroVida = montoFinanciar * 0.0003; // 0.03% mensual
            const seguroDanos = montoFinanciar * 0.0005; // 0.05% mensual
            const cuotaTotal = cuotaBase + seguroVida + seguroDanos;

            // Desglose del primer mes
            const interesMes1 = montoFinanciar * tasaMensual;
            const capitalMes1 = cuotaBase - interesMes1;

            // Porcentajes para la barra visual
            const pctCapital = (capitalMes1 / cuotaTotal) * 100;
            const pctInteres = (interesMes1 / cuotaTotal) * 100;
            const pctSegVida = (seguroVida / cuotaTotal) * 100;
            const pctSegDanos = (seguroDanos / cuotaTotal) * 100;

            document.getElementById('lblMontoFinanciar').innerText = '$' + montoFinanciar.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblCuotaTotal').innerText = '$' + cuotaTotal.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

            document.getElementById('lblDesgloseCapital').innerText = '$' + capitalMes1.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblDesgloseInteres').innerText = '$' + interesMes1.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblSeguroVida').innerText = '$' + seguroVida.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblSeguroDanos').innerText = '$' + seguroDanos.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

            document.getElementById('lblPctCapital').innerText = pctCapital.toFixed(1) + '%';
            document.getElementById('lblPctInteres').innerText = pctInteres.toFixed(1) + '%';
            document.getElementById('lblPctSegVida').innerText = pctSegVida.toFixed(1) + '%';
            document.getElementById('lblPctSegDanos').innerText = pctSegDanos.toFixed(1) + '%';

            document.getElementById('barCapital').style.width = pctCapital.toFixed(1) + '%';
            document.getElementById('barInteres').style.width = pctInteres.toFixed(1) + '%';
            document.getElementById('barSegVida').style.width = pctSegVida.toFixed(1) + '%';
            document.getElementById('barSegDanos').style.width = pctSegDanos.toFixed(1) + '%';

            document.getElementById('lblTasaAplicada').innerText = `* Tasa del 10.00% ANUAL para vehículo ${estadoVehiculo.toLowerCase()}`;

            // TABLA RESUMIDA DE LOS PRIMEROS MESES
            let saldo = montoFinanciar;
            let tbodyHtml = '';
            const mesesMostrar = Math.min(plazoMeses, 4);

            for (let m = 1; m <= mesesMostrar; m++) {
                const interesMes = saldo * tasaMensual;
                const capitalMes = cuotaBase - interesMes;
                saldo -= capitalMes;

                tbodyHtml += `
                    <tr>
                        <td class="py-2 px-3 font-bold text-slate-900 dark:text-white">Mes ${m}</td>
                        <td class="py-2 px-3 text-emerald-600 dark:text-emerald-400 font-bold">$${cuotaBase.toFixed(2)}</td>
                        <td class="py-2 px-3 text-slate-700 dark:text-slate-300">$${interesMes.toFixed(2)}</td>
                        <td class="py-2 px-3 text-slate-700 dark:text-slate-300">$${capitalMes.toFixed(2)}</td>
                        <td class="py-2 px-3 text-right text-slate-900 dark:text-slate-300 font-bold">$${Math.max(saldo, 0).toFixed(2)}</td>
                    </tr>
                `;
            }

            if (plazoMeses > 4) {
                tbodyHtml += `
                    <tr class="bg-slate-100 dark:bg-[#0F233D]/60 italic text-slate-500 dark:text-slate-400">
                        <td colspan="5" class="py-1.5 px-3 text-center text-[10px]">... (${plazoMeses - 4} meses restantes con la misma cuota base de $${cuotaBase.toFixed(2)}) ...</td>
                    </tr>
                `;
            }

            document.getElementById('tblAmortizacionBody').innerHTML = tbodyHtml;
        }

        function sincronizarMontoFormulario(val) {
            const txtMontoForm = document.getElementById('<%= txtMontoSolicitado.ClientID %>');
            if (txtMontoForm) txtMontoForm.value = val;
        }

        function sincronizarMontoSimulador(val) {
            const txtPrecioSim = document.getElementById('<%= txtPrecioComercial.ClientID %>');
            if (txtPrecioSim) txtPrecioSim.value = val;
        }

        function sincronizarPlazoFormulario(val) {
            const ddlPlazoForm = document.getElementById('<%= ddlPlazoSolicitado.ClientID %>');
            if (ddlPlazoForm) ddlPlazoForm.value = val;
        }

        function sincronizarPlazoSimulador(val) {
    const ddlPlazoSim = document.getElementById('<%= ddlPlazoMeses.ClientID %>');
    if (ddlPlazoSim) ddlPlazoSim.value = val;
}

document.addEventListener('DOMContentLoaded', function () {
    const isDark = document.documentElement.classList.contains('dark');
    updateThemeIcons(isDark);

    calcularCotizadorVehicular();
});
</script>
</body>
</html>