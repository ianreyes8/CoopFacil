 <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreditoHipotecario.aspx.cs" Inherits="CoopFacil.Pages.CreditoHipotecario" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Crédito Hipotecario - CoopFacil</title>
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
                    <asp:LinkButton ID="btnPortalSocio" runat="server" OnClick="btnPortalSocio_Click" Visible="false" CssClass="bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs sm:text-sm px-5 py-2.5 rounded-lg transition flex items-center gap-2 shadow-lg shadow-emerald-900/40">
                        <i class="fa-solid fa-user-check"></i> Portal Socio
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnCerrarSesion" runat="server" OnClick="btnCerrarSesion_Click" Visible="false" CssClass="bg-[#0F233D] hover:bg-slate-700 border border-slate-600 text-white font-bold text-xs sm:text-sm px-4 py-2.5 rounded-lg transition flex items-center gap-2">
                        <i class="fa-solid fa-right-from-bracket"></i> Cerrar Sesión
                    </asp:LinkButton>
                </div>

            </header>

            <!-- CONTENIDO PRINCIPAL -->
            <main class="max-w-7xl mx-auto px-6 py-10 flex flex-col gap-10 flex-grow w-full">
                
                <!-- REGRESO A SERVICIOS Y TITULAR -->
                <div class="flex flex-col gap-3">
                    <a href="Servicios.aspx" class="text-xs font-bold text-emerald-400 hover:underline flex items-center gap-2 w-fit">
                        <i class="fa-solid fa-arrow-left"></i> Volver al Portafolio de Servicios
                    </a>
                    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 mt-2">
                        <div>
                            <span class="text-xs font-bold uppercase tracking-wider text-emerald-400">CRÉDITO DE VIVIENDA Y REMODELACIÓN</span>
                            <h1 class="text-3xl sm:text-4xl font-extrabold text-white tracking-tight flex items-center gap-3 mt-1">
                                <i class="fa-solid fa-house-chimney text-emerald-400"></i> Crédito Hipotecario
                            </h1>
                        </div>
                        <div class="bg-[#0F233D] border border-emerald-500/40 px-4 py-2 rounded-xl flex items-center gap-3 shadow-lg">
                            <span class="text-xs text-slate-300 font-medium">Tasa Preferencial Vivienda:</span>
                            <span class="text-lg font-black text-emerald-400">7.50% EA</span>
                        </div>
                    </div>
                    <p class="text-sm sm:text-base text-slate-300 leading-relaxed max-w-3xl">
                        Financiamiento a largo plazo para compra de vivienda nueva o usada, construcción en terreno propio o remodelación. Obtén cuotas accesibles, plazos de hasta 20 años y asesoría personalizada de principio a fin.
                    </p>
                </div>

                <!-- SECCIÓN 1: SIMULADOR HIPOTECARIO Y RESULTADOS DETALLADOS -->
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                    
                    <!-- CALCULADORA HIPOTECARIA (INPUTS) -->
                    <div class="lg:col-span-6 bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-6">
                        <div class="flex items-center gap-3 border-b border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-emerald-500/20 border border-emerald-400/30 flex items-center justify-center text-emerald-400 text-xl">
                                <i class="fa-solid fa-calculator"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-white">Simulador Hipotecario</h2>
                                <p class="text-xs text-slate-400">Calcula tu cuota con financiamiento hasta 20 años (7.5% EA)</p>
                            </div>
                        </div>

                        <!-- VALOR TOTAL DE LA PROPIEDAD -->
                        <div class="flex flex-col gap-2">
                            <label class="text-xs font-bold text-slate-300 uppercase">Valor Total del Inmueble ($ USD)</label>
                            <div class="relative">
                                <span class="absolute left-3.5 top-2.5 text-slate-400 font-bold">$</span>
                                <input type="number" id="simValorPropiedad" value="100000" min="10000" step="any" oninput="calcularSimuladorHipotecario()" class="w-full bg-[#0B1A30] border border-slate-700 rounded-xl pl-8 pr-3 py-2.5 text-xs font-bold text-white focus:outline-none focus:border-emerald-500 transition" />
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                            <!-- PORCENTAJE DE PRIMA / ENGANCHE (MÍNIMO 10%) -->
                            <div class="flex flex-col gap-2">
                                <label class="text-xs font-bold text-slate-300 uppercase">Prima del valor otorgado (Mín. 10%)</label>
                                <div class="relative">
                                    <input type="number" id="simPrimaPct" value="10" min="10" max="80" step="1" oninput="calcularSimuladorHipotecario()" class="w-full bg-[#0B1A30] border border-slate-700 rounded-xl pl-4 pr-8 py-2.5 text-xs font-bold text-white focus:outline-none focus:border-emerald-500 transition" />
                                    <span class="absolute right-3.5 top-2.5 text-slate-400 font-bold">%</span>
                                </div>
                            </div>

                            <!-- PLAZO EN AÑOS (HASTA 20 AÑOS) -->
                            <div class="flex flex-col gap-2">
                                <label class="text-xs font-bold text-slate-300 uppercase">Plazo de Financiamiento</label>
                                <select id="simPlazoAnios" onchange="calcularSimuladorHipotecario()" class="w-full bg-[#0B1A30] border border-slate-700 rounded-xl px-3 py-2.5 text-xs font-bold text-white focus:outline-none focus:border-emerald-500 transition">
                                    <option value="5">5 Años (60 Meses)</option>
                                    <option value="10">10 Años (120 Meses)</option>
                                    <option value="15">15 Años (180 Meses)</option>
                                    <option value="20" selected="selected">20 Años (240 Meses)</option>
                                </select>
                            </div>
                        </div>

                        <div class="bg-[#0B1A30] border border-slate-800 rounded-xl p-4 flex justify-between items-center text-xs">
                            <span class="text-slate-400 font-medium">Monto Total a Financiar:</span>
                            <span id="lblMontoFinanciar" class="text-base font-extrabold text-emerald-400">$90,000.00</span>
                        </div>
                    </div>

                    <!-- RESULTADOS DETALLADOS Y SEGUROS -->
                    <div class="lg:col-span-6 bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-5">
                        <div class="flex items-center gap-3 border-b border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-blue-500/20 border border-blue-400/30 flex items-center justify-center text-blue-400 text-xl">
                                <i class="fa-solid fa-file-invoice-dollar"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-white">Desglose de Cuota Estimada</h2>
                                <p class="text-xs text-slate-400">Incluye capital, intereses y estimación de seguros obligatorios</p>
                            </div>
                        </div>

                        <!-- CUOTA TOTAL DESTACADA -->
                        <div class="bg-[#0B1A30] border border-emerald-500/40 rounded-xl p-5 text-center flex flex-col items-center justify-center shadow-inner">
                            <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Cuota Total Mensual Estimada</span>
                            <span id="lblCuotaTotal" class="text-3xl font-black text-emerald-400 mt-1">$772.03</span>
                            <span class="text-[10px] text-slate-400 mt-1">* Cuota fija durante todo el plazo del crédito</span>
                        </div>

                        <!-- TABLA DE DESGLOSE -->
                        <div class="space-y-2.5 text-xs text-slate-300">
                            <div class="flex justify-between items-center py-2 border-b border-slate-800">
                                <span class="flex items-center gap-2"><i class="fa-solid fa-coins text-emerald-400"></i> Cuota Base (Capital e Intereses):</span>
                                <span id="lblCuotaBase" class="font-bold text-white">$725.03</span>
                            </div>

                            <div class="flex justify-between items-center py-2 border-b border-slate-800">
                                <span class="flex items-center gap-2"><i class="fa-solid fa-heart-pulse text-blue-400"></i> Seguro de Vida Colectivo (Est.):</span>
                                <span id="lblSeguroVida" class="font-bold text-slate-200">$27.00</span>
                            </div>

                            <div class="flex justify-between items-center py-2 border-b border-slate-800">
                                <span class="flex items-center gap-2"><i class="fa-solid fa-shield-halved text-amber-400"></i> Seguro de Daños / Incendio (Est.):</span>
                                <span id="lblSeguroDanos" class="font-bold text-slate-200">$20.00</span>
                            </div>
                        </div>

                        <span class="text-[11px] text-slate-400 italic text-center mt-1">
                            * Proyección orientativa sujeta a aprobación de crédito y avalúo comercial del inmueble.
                        </span>
                    </div>

                </div>

                <!-- SECCIÓN 2: GUÍA DE PASOS DEL PROCESO (FLUJOGRAMA VISUAL) -->
                <section class="bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 sm:p-8 shadow-xl flex flex-col gap-6">
                    <div class="flex items-center gap-3 border-b border-slate-800 pb-4">
                        <div class="w-10 h-10 rounded-xl bg-emerald-500/20 border border-emerald-400/30 flex items-center justify-center text-emerald-400 text-xl">
                            <i class="fa-solid fa-diagram-project"></i>
                        </div>
                        <div>
                            <h2 class="text-xl font-bold text-white">Guía del Proceso de Crédito Hipotecario</h2>
                            <p class="text-xs text-slate-400">Flujograma transparente desde el primer paso hasta la entrega de llaves</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 relative">
                        
                        <!-- PASO 1 -->
                        <div class="bg-[#0B1A30] border border-slate-800 rounded-xl p-5 flex flex-col gap-3 relative group hover:border-emerald-500/50 transition">
                            <div class="flex items-center justify-between">
                                <span class="w-8 h-8 rounded-lg bg-emerald-600/20 text-emerald-400 font-black text-sm flex items-center justify-center border border-emerald-500/30">1</span>
                                <i class="fa-solid fa-calculator text-slate-500 text-lg group-hover:text-emerald-400 transition"></i>
                            </div>
                            <h3 class="text-sm font-bold text-white">1. Pre-Calificación</h3>
                            <p class="text-xs text-slate-400 leading-relaxed">
                                Simula tu crédito e ingresa tu solicitud en línea para verificar tu capacidad de pago y monto máximo pre-aprobado.
                            </p>
                        </div>

                        <!-- PASO 2 -->
                        <div class="bg-[#0B1A30] border border-slate-800 rounded-xl p-5 flex flex-col gap-3 relative group hover:border-emerald-500/50 transition">
                            <div class="flex items-center justify-between">
                                <span class="w-8 h-8 rounded-lg bg-emerald-600/20 text-emerald-400 font-black text-sm flex items-center justify-center border border-emerald-500/30">2</span>
                                <i class="fa-solid fa-magnifying-glass-location text-slate-500 text-lg group-hover:text-emerald-400 transition"></i>
                            </div>
                            <h3 class="text-sm font-bold text-white">2. Avalúo del Inmueble</h3>
                            <p class="text-xs text-slate-400 leading-relaxed">
                                Un perito valuador autorizado por la cooperativa realiza la inspección física y comercial de la propiedad.
                            </p>
                        </div>

                        <!-- PASO 3 -->
                        <div class="bg-[#0B1A30] border border-slate-800 rounded-xl p-5 flex flex-col gap-3 relative group hover:border-emerald-500/50 transition">
                            <div class="flex items-center justify-between">
                                <span class="w-8 h-8 rounded-lg bg-emerald-600/20 text-emerald-400 font-black text-sm flex items-center justify-center border border-emerald-500/30">3</span>
                                <i class="fa-solid fa-file-check text-slate-500 text-lg group-hover:text-emerald-400 transition"></i>
                            </div>
                            <h3 class="text-sm font-bold text-white">3. Análisis Legal y Aprobación</h3>
                            <p class="text-xs text-slate-400 leading-relaxed">
                                Revisión de antecedentes registrales en el CNR y emisión de la carta de aprobación formal por el Comité de Crédito.
                            </p>
                        </div>

                        <!-- PASO 4 -->
                        <div class="bg-[#0B1A30] border border-slate-800 rounded-xl p-5 flex flex-col gap-3 relative group hover:border-emerald-500/50 transition">
                            <div class="flex items-center justify-between">
                                <span class="w-8 h-8 rounded-lg bg-emerald-600/20 text-emerald-400 font-black text-sm flex items-center justify-center border border-emerald-500/30">4</span>
                                <i class="fa-solid fa-key text-slate-500 text-lg group-hover:text-emerald-400 transition"></i>
                            </div>
                            <h3 class="text-sm font-bold text-white">4. Escrituración y Desembolso</h3>
                            <p class="text-xs text-slate-400 leading-relaxed">
                                Firma de escritura pública de compraventa e hipoteca ante notario y transferencia inmediata de fondos.
                            </p>
                        </div>

                    </div>
                </section>

                <!-- SECCIÓN 3: AGENDAMIENTO DE CITA CON ASESOR ESPECIALIZADO -->
                <section class="bg-[#0F233D] border-2 border-emerald-500/40 rounded-2xl p-6 sm:p-8 shadow-2xl relative overflow-hidden">
                    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 border-b border-slate-800 pb-6 mb-6">
                        <div>
                            <span class="text-xs font-bold text-emerald-400 uppercase tracking-widest block">ASESORÍA PERSONALIZADA</span>
                            <h2 class="text-2xl font-extrabold text-white mt-1 flex items-center gap-2">
                                <i class="fa-solid fa-calendar-days text-emerald-400"></i> Agendamiento de Cita con Asesor Especializado
                            </h2>
                            <p class="text-xs sm:text-sm text-slate-300 mt-1">
                                Selecciona el día, la hora y la modalidad de tu preferencia para recibir atención exclusiva sobre tu crédito de vivienda.
                            </p>
                        </div>
                        <div class="hidden sm:flex items-center gap-2 bg-[#0B1A30] border border-slate-700 px-3.5 py-2 rounded-xl text-xs font-bold text-slate-300">
                            <i class="fa-solid fa-user-tie text-emerald-400 text-sm"></i> Especialistas Hipotecarios
                        </div>
                    </div>

                    <!-- MENSAJE DE FEEDBACK -->
                    <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-xl border flex items-center gap-3 text-sm font-bold">
                        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-5">
                        
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Nombre Completo <span class="text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="Ej. Carlos Alberto Mendoza"></asp:TextBox>
                        </div>

                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Documento de Identidad (DUI) <span class="text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtDUI" runat="server" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="00000000-0"></asp:TextBox>
                        </div>

                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Teléfono de Contacto <span class="text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtTelefono" runat="server" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="7777-8888"></asp:TextBox>
                        </div>

                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Correo Electrónico <span class="text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtCorreo" runat="server" TextMode="Email" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="correo@ejemplo.com"></asp:TextBox>
                        </div>

                        <!-- MODALIDAD -->
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Modalidad de Atención <span class="text-emerald-400">*</span></label>
                            <asp:DropDownList ID="ddlModalidad" runat="server" onchange="toggleAgencia(this.value)" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-emerald-500 transition">
                                <asp:ListItem Text="Presencial en Agencia" Value="Presencial"></asp:ListItem>
                                <asp:ListItem Text="Videollamada en Línea" Value="Videollamada"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- AGENCIA (MUESTRA U OCULTA SEGÚN MODALIDAD) -->
                        <div id="divAgencia" class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Agencia Preferida <span class="text-emerald-400">*</span></label>
                            <asp:DropDownList ID="ddlAgencia" runat="server" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-emerald-500 transition">
                                <asp:ListItem Text="Agencia Central - San Salvador" Value="Agencia Central"></asp:ListItem>
                                <asp:ListItem Text="Agencia Escalón" Value="Agencia Escalón"></asp:ListItem>
                                <asp:ListItem Text="Agencia Soyapango" Value="Agencia Soyapango"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- FECHA DE CITA -->
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Fecha de Cita <span class="text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtFechaCita" runat="server" TextMode="Date" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-emerald-500 transition"></asp:TextBox>
                        </div>

                        <!-- HORA DE CITA -->
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Hora de Cita <span class="text-emerald-400">*</span></label>
                            <asp:DropDownList ID="ddlHoraCita" runat="server" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-emerald-500 transition">
                                <asp:ListItem Text="08:00 AM" Value="08:00 AM"></asp:ListItem>
                                <asp:ListItem Text="09:00 AM" Value="09:00 AM"></asp:ListItem>
                                <asp:ListItem Text="10:00 AM" Value="10:00 AM"></asp:ListItem>
                                <asp:ListItem Text="11:00 AM" Value="11:00 AM"></asp:ListItem>
                                <asp:ListItem Text="02:00 PM" Value="02:00 PM"></asp:ListItem>
                                <asp:ListItem Text="03:00 PM" Value="03:00 PM"></asp:ListItem>
                                <asp:ListItem Text="04:00 PM" Value="04:00 PM"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                    </div>

                    <div class="mt-6 flex justify-end">
                        <asp:Button ID="btnAgendarCita" runat="server" Text="Confirmar y Agendar Cita" OnClick="btnAgendarCita_Click" CssClass="w-full sm:w-auto bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs px-8 py-3.5 rounded-xl shadow-lg shadow-emerald-950 transition cursor-pointer" />
                    </div>
                </section>

            </main>
        </div>

        <footer class="bg-[#0F233D] border-t-2 border-slate-700/80 text-slate-400 text-xs text-center py-6 mt-auto">
            <p>© 2026 CoopFacil. Todos los derechos reservados.</p>
        </footer>

    </form>

    <script>
        function calcularSimuladorHipotecario() {
            const valProp = parseFloat(document.getElementById('simValorPropiedad').value) || 0;
            const pctPrima = parseFloat(document.getElementById('simPrimaPct').value) || 10;
            const anios = parseInt(document.getElementById('simPlazoAnios').value) || 20;

            if (valProp <= 0) {
                document.getElementById('lblMontoFinanciar').innerText = '$0.00';
                document.getElementById('lblCuotaTotal').innerText = '$0.00';
                document.getElementById('lblCuotaBase').innerText = '$0.00';
                document.getElementById('lblSeguroVida').innerText = '$0.00';
                document.getElementById('lblSeguroDanos').innerText = '$0.00';
                return;
            }

            const montoPrima = valProp * (pctPrima / 100);
            const montoFinanciar = valProp - montoPrima;
            const plazoMeses = anios * 12;
            const tasaAnual = 0.075; // Tasa del 7.5% EA
            const tasaMensual = tasaAnual / 12;

            // Fórmula de cuota nivelada PMT utilizando Math.pow (JavaScript)
            const factor = Math.pow(1 + tasaMensual, plazoMeses);
            const cuotaBase = montoFinanciar * (tasaMensual * factor) / (factor - 1);

            // Estimaciones de seguros colectivos
            const seguroVida = montoFinanciar * 0.0003; // 0.03% mensual
            const seguroDanos = valProp * 0.0002;       // 0.02% mensual
            const cuotaTotal = cuotaBase + seguroVida + seguroDanos;

            document.getElementById('lblMontoFinanciar').innerText = '$' + montoFinanciar.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblCuotaBase').innerText = '$' + cuotaBase.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblSeguroVida').innerText = '$' + seguroVida.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblSeguroDanos').innerText = '$' + seguroDanos.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblCuotaTotal').innerText = '$' + cuotaTotal.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        function toggleAgencia(modalidad) {
            const divAgencia = document.getElementById('divAgencia');
            if (divAgencia) {
                if (modalidad === 'Videollamada') {
                    divAgencia.style.display = 'none';
                } else {
                    divAgencia.style.display = 'flex';
                }
            }
        }

        document.addEventListener('DOMContentLoaded', function () {
            calcularSimuladorHipotecario();
        });
    </script>
</body>
</html>