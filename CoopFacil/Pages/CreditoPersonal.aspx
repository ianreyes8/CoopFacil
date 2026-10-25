<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreditoPersonal.aspx.cs" Inherits="CoopFacil.Pages.CreditoPersonal" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Crédito Personal - CoopFacil</title>
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
                            <span class="text-xs font-bold uppercase tracking-wider text-emerald-400">FINANCIAMIENTO RÁPIDO</span>
                            <h1 class="text-3xl sm:text-4xl font-extrabold text-white tracking-tight flex items-center gap-3 mt-1">
                                <i class="fa-solid fa-hand-holding-dollar text-emerald-400"></i> Crédito Personal
                            </h1>
                        </div>
                        <div class="bg-[#0F233D] border border-emerald-500/40 px-4 py-2 rounded-xl flex items-center gap-3 shadow-lg">
                            <span class="text-xs text-slate-300 font-medium">Tasa Especial Competitiva:</span>
                            <span class="text-lg font-black text-emerald-400">10% EA</span>
                        </div>
                    </div>
                    <p class="text-sm sm:text-base text-slate-300 leading-relaxed max-w-3xl">
                        Otorga liquidez rápida para libre inversión o consolidación de deudas. Disfruta de cuota fija mensual, plazos extendidos de hasta 10 años (120 meses) y aprobación agilizada directamente desde la plataforma.
                    </p>
                </div>

                <!-- SECCIÓN 1: SIMULADOR DE CUOTA FIJA Y CHECKLIST DE DOCUMENTOS -->
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                    
                    <!-- CALCULADORA / SIMULADOR DE CUOTA FIJA Y TABLA DE AMORTIZACIÓN -->
                    <div class="lg:col-span-7 bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-6">
                        <div class="flex items-center gap-3 border-b border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-emerald-500/20 border border-emerald-400/30 flex items-center justify-center text-emerald-400 text-xl">
                                <i class="fa-solid fa-calculator"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-white">Calculadora de Cuota Fija</h2>
                                <p class="text-xs text-slate-400">Simula tu crédito ($500 a $15,000) a una Tasa del 10% EA</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                            <!-- MONTO SOLICITADO ($500 A $15,000) -->
                            <div class="flex flex-col gap-2">
                                <label class="text-xs font-bold text-slate-300 uppercase">Monto Solicitado ($500 - $15,000)</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-2.5 text-slate-400 font-bold">$</span>
                                    <input type="number" id="simMonto" value="3000" min="500" max="15000" step="any" oninput="sincronizarMontoFormulario(this.value); calcularSimuladorCredito();" class="w-full bg-[#0B1A30] border border-slate-700 rounded-xl pl-8 pr-3 py-2.5 text-xs font-bold text-white focus:outline-none focus:border-emerald-500 transition" />
                                </div>
                            </div>

                            <!-- PLAZO EN MESES (12 A 120) -->
                            <div class="flex flex-col gap-2">
                                <label class="text-xs font-bold text-slate-300 uppercase">Plazo en Meses (12 a 120)</label>
                                <select id="simPlazo" onchange="sincronizarPlazoFormulario(this.value); calcularSimuladorCredito();" class="w-full bg-[#0B1A30] border border-slate-700 rounded-xl px-3 py-2.5 text-xs font-bold text-white focus:outline-none focus:border-emerald-500 transition">
                                    <option value="12">12 Meses (1 Año)</option>
                                    <option value="24" selected="selected">24 Meses (2 Años)</option>
                                    <option value="36">36 Meses (3 Años)</option>
                                    <option value="48">48 Meses (4 Años)</option>
                                    <option value="60">60 Meses (5 Años)</option>
                                    <option value="72">72 Meses (6 Años)</option>
                                    <option value="84">84 Meses (7 Años)</option>
                                    <option value="96">96 Meses (8 Años)</option>
                                    <option value="108">108 Meses (9 Años)</option>
                                    <option value="120">120 Meses (10 Años)</option>
                                </select>
                            </div>
                        </div>

                        <!-- RESULTADO DE CUOTA ESTIMADA -->
                        <div class="bg-[#0B1A30] border border-emerald-500/30 rounded-xl p-5 grid grid-cols-1 sm:grid-cols-3 gap-4 text-center shadow-inner">
                            <div class="flex flex-col">
                                <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Cuota Mensual Fija</span>
                                <span id="lblCuotaEstimada" class="text-2xl font-black text-emerald-400 mt-1">$0.00</span>
                            </div>
                            <div class="flex flex-col border-t sm:border-t-0 sm:border-l border-slate-800 pt-3 sm:pt-0">
                                <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Total de Intereses</span>
                                <span id="lblTotalIntereses" class="text-2xl font-black text-white mt-1">$0.00</span>
                            </div>
                            <div class="flex flex-col border-t sm:border-t-0 sm:border-l border-slate-800 pt-3 sm:pt-0">
                                <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Monto Total a Pagar</span>
                                <span id="lblTotalPagar" class="text-2xl font-black text-slate-300 mt-1">$0.00</span>
                            </div>
                        </div>

                        <!-- TABLA RESUMIDA DE AMORTIZACIÓN BÁSICA -->
                        <div class="flex flex-col gap-2 mt-2">
                            <span class="text-xs font-bold text-slate-300 uppercase flex items-center gap-2">
                                <i class="fa-solid fa-table-list text-emerald-400"></i> Tabla Resumida de Amortización (Primeros Meses)
                            </span>
                            <div class="overflow-x-auto rounded-xl border border-slate-800">
                                <table class="w-full text-left text-[11px] text-slate-300">
                                    <thead class="bg-[#0B1A30] text-emerald-400 font-bold uppercase border-b border-slate-800">
                                        <tr>
                                            <th class="py-2 px-3">Mes</th>
                                            <th class="py-2 px-3">Cuota</th>
                                            <th class="py-2 px-3">Interés</th>
                                            <th class="py-2 px-3">Capital</th>
                                            <th class="py-2 px-3 text-right">Saldo Restante</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tblAmortizacionBody" class="divide-y divide-slate-800/60 font-medium">
                                        <!-- Generado dinámicamente con JavaScript -->
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <span class="text-[11px] text-slate-400 italic text-center">
                            * Cálculo estimado sobre sistema de cuota nivelada a Tasa Efectiva Anual del 10.00%.
                        </span>
                    </div>

                    <!-- CHECKLIST DE DOCUMENTOS REQUERIDOS -->
                    <div class="lg:col-span-5 bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-5">
                        <div class="flex items-center gap-3 border-b border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-blue-500/20 border border-blue-400/30 flex items-center justify-center text-blue-400 text-xl">
                                <i class="fa-solid fa-folder-open"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-white">Checklist de Requisitos</h2>
                                <p class="text-xs text-slate-400">Documentos obligatorios para el desembolso</p>
                            </div>
                        </div>

                        <p class="text-xs text-slate-300 leading-relaxed">
                            Asegúrate de contar con la siguiente documentación legible antes de enviar tu solicitud para acelerar el trámite:
                        </p>

                        <div class="flex flex-col gap-3.5 my-1">
                            <div class="bg-[#0B1A30] border border-slate-700/80 rounded-xl p-3.5 flex items-center justify-between gap-3">
                                <div class="flex items-center gap-3">
                                    <div class="w-8 h-8 rounded-lg bg-emerald-500/20 text-emerald-400 flex items-center justify-center text-sm">
                                        <i class="fa-solid fa-id-card"></i>
                                    </div>
                                    <div class="flex flex-col">
                                        <span class="text-xs font-bold text-white">1. DUI Vigente</span>
                                        <span class="text-[10px] text-slate-400">Ambos lados, legibles y ampliados al 150%</span>
                                    </div>
                                </div>
                                <i class="fa-solid fa-circle-check text-emerald-400 text-lg"></i>
                            </div>

                            <div class="bg-[#0B1A30] border border-slate-700/80 rounded-xl p-3.5 flex items-center justify-between gap-3">
                                <div class="flex items-center gap-3">
                                    <div class="w-8 h-8 rounded-lg bg-emerald-500/20 text-emerald-400 flex items-center justify-center text-sm">
                                        <i class="fa-solid fa-file-invoice-dollar"></i>
                                    </div>
                                    <div class="flex flex-col">
                                        <span class="text-xs font-bold text-white">2. Constancia de Sueldo</span>
                                        <span class="text-[10px] text-slate-400">Emisión reciente (máximo 30 días con firma y sello)</span>
                                    </div>
                                </div>
                                <i class="fa-solid fa-circle-check text-emerald-400 text-lg"></i>
                            </div>

                            <div class="bg-[#0B1A30] border border-slate-700/80 rounded-xl p-3.5 flex items-center justify-between gap-3">
                                <div class="flex items-center gap-3">
                                    <div class="w-8 h-8 rounded-lg bg-emerald-500/20 text-emerald-400 flex items-center justify-center text-sm">
                                        <i class="fa-solid fa-receipt"></i>
                                    </div>
                                    <div class="flex flex-col">
                                        <span class="text-xs font-bold text-white">3. Recibo de Agua o Luz</span>
                                        <span class="text-[10px] text-slate-400">Comprobante de domicilio reciente del titular</span>
                                    </div>
                                </div>
                                <i class="fa-solid fa-circle-check text-emerald-400 text-lg"></i>
                            </div>
                        </div>

                        <div class="bg-blue-950/40 border border-blue-500/30 rounded-xl p-3.5 text-xs text-blue-200 flex items-start gap-2.5">
                            <i class="fa-solid fa-circle-info text-blue-400 text-sm mt-0.5"></i>
                            <span>Podrás presentar estos documentos de manera digital o entregarlos físicamente al momento de la firma.</span>
                        </div>
                    </div>

                </div>

                <!-- SECCIÓN 2: FORMULARIO DE SOLICITUD Y PRE-APROBACIÓN -->
                <section class="bg-[#0F233D] border-2 border-emerald-500/40 rounded-2xl p-6 sm:p-8 shadow-2xl relative overflow-hidden">
                    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 border-b border-slate-800 pb-6 mb-6">
                        <div>
                            <span class="text-xs font-bold text-emerald-400 uppercase tracking-widest block">EVALUACIÓN EN TIEMPO REAL</span>
                            <h2 class="text-2xl font-extrabold text-white mt-1 flex items-center gap-2">
                                <i class="fa-solid fa-file-signature text-emerald-400"></i> Formulario de Solicitud y Pre-Aprobación
                            </h2>
                            <p class="text-xs sm:text-sm text-slate-300 mt-1">
                                Ingresa tus datos financieros para obtener un dictamen preliminar sobre tu capacidad de endeudamiento.
                            </p>
                        </div>
                        <div class="hidden sm:flex items-center gap-2 bg-[#0B1A30] border border-slate-700 px-3.5 py-2 rounded-xl text-xs font-bold text-slate-300">
                            <i class="fa-solid fa-shield-halved text-emerald-400 text-sm"></i> Evaluación de Riesgo Automatizada
                        </div>
                    </div>

                    <!-- MENSAJE DE FEEDBACK Y DICTAMEN PRELIMINAR -->
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

                        <!-- INGRESOS MENSUALES -->
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Ingresos Mensuales Netos ($) <span class="text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtIngresos" runat="server" TextMode="Number" step="any" min="1" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-emerald-500 transition" placeholder="Ej. 850.00"></asp:TextBox>
                        </div>

                        <!-- OCUPACIÓN -->
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Ocupación / Empleo <span class="text-emerald-400">*</span></label>
                            <asp:DropDownList ID="ddlOcupacion" runat="server" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-emerald-500 transition">
                                <asp:ListItem Text="Empleado Sector Privado" Value="Empleado Sector Privado"></asp:ListItem>
                                <asp:ListItem Text="Empleado Sector Público" Value="Empleado Sector Público"></asp:ListItem>
                                <asp:ListItem Text="Profesional Independiente" Value="Profesional Independiente"></asp:ListItem>
                                <asp:ListItem Text="Comerciante / Empresario" Value="Comerciante"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- DESTINO DEL CRÉDITO -->
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Destino del Crédito <span class="text-emerald-400">*</span></label>
                            <asp:DropDownList ID="ddlDestino" runat="server" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-emerald-500 transition">
                                <asp:ListItem Text="Consolidación de Deudas" Value="Consolidación de Deudas"></asp:ListItem>
                                <asp:ListItem Text="Libre Inversión / Personal" Value="Libre Inversión"></asp:ListItem>
                                <asp:ListItem Text="Remodelación de Vivienda" Value="Remodelación de Vivienda"></asp:ListItem>
                                <asp:ListItem Text="Gastos Médicos / Salud" Value="Gastos Médicos"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- ESTADO CIVIL -->
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Estado Civil <span class="text-emerald-400">*</span></label>
                            <asp:DropDownList ID="ddlEstadoCivil" runat="server" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-emerald-500 transition">
                                <asp:ListItem Text="Soltero/a" Value="Soltero/a"></asp:ListItem>
                                <asp:ListItem Text="Casado/a" Value="Casado/a"></asp:ListItem>
                                <asp:ListItem Text="Acompañado/a" Value="Acompañado/a"></asp:ListItem>
                                <asp:ListItem Text="Divorciado/a" Value="Divorciado/a"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <!-- MONTO SOLICITADO FORMULARIO -->
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Monto del Crédito ($) <span class="text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtMontoSolicitado" runat="server" TextMode="Number" Text="3000" min="500" max="15000" step="any" oninput="sincronizarMontoSimulador(this.value); calcularSimuladorCredito();" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-emerald-500 transition" placeholder="3000"></asp:TextBox>
                        </div>

                        <!-- PLAZO FORMULARIO (HASTA 120 MESES) -->
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Plazo Deseado <span class="text-emerald-400">*</span></label>
                            <asp:DropDownList ID="ddlPlazoSolicitado" runat="server" onchange="sincronizarPlazoSimulador(this.value); calcularSimuladorCredito();" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-emerald-500 transition">
                                <asp:ListItem Text="12 Meses (1 Año)" Value="12"></asp:ListItem>
                                <asp:ListItem Text="24 Meses (2 Años)" Value="24" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="36 Meses (3 Años)" Value="36"></asp:ListItem>
                                <asp:ListItem Text="48 Meses (4 Años)" Value="48"></asp:ListItem>
                                <asp:ListItem Text="60 Meses (5 Años)" Value="60"></asp:ListItem>
                                <asp:ListItem Text="72 Meses (6 Años)" Value="72"></asp:ListItem>
                                <asp:ListItem Text="84 Meses (7 Años)" Value="84"></asp:ListItem>
                                <asp:ListItem Text="96 Meses (8 Años)" Value="96"></asp:ListItem>
                                <asp:ListItem Text="108 Meses (9 Años)" Value="108"></asp:ListItem>
                                <asp:ListItem Text="120 Meses (10 Años)" Value="120"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                    </div>

                    <div class="mt-6 flex justify-end">
                        <asp:Button ID="btnSolicitarCredito" runat="server" Text="Evaluar y Solicitar Crédito Personal" OnClick="btnSolicitarCredito_Click" CssClass="w-full sm:w-auto bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs px-8 py-3.5 rounded-xl shadow-lg shadow-emerald-950 transition cursor-pointer" />
                    </div>
                </section>

            </main>
        </div>

        <footer class="bg-[#0F233D] border-t-2 border-slate-700/80 text-slate-400 text-xs text-center py-6 mt-auto">
            <p>© 2026 CoopFacil. Todos los derechos reservados.</p>
        </footer>

    </form>

    <script>
        function calcularSimuladorCredito() {
            const montoInput = document.getElementById('simMonto');
            const plazoInput = document.getElementById('simPlazo');

            if (!montoInput || !plazoInput) return;

            const monto = parseFloat(montoInput.value) || 0;
            const plazo = parseInt(plazoInput.value) || 24;
            const tasaAnual = 0.10; // Tasa del 10% EA
            const tasaMensual = tasaAnual / 12;

            if (monto <= 0 || plazo <= 0) {
                document.getElementById('lblCuotaEstimada').innerText = '$0.00';
                document.getElementById('lblTotalIntereses').innerText = '$0.00';
                document.getElementById('lblTotalPagar').innerText = '$0.00';
                document.getElementById('tblAmortizacionBody').innerHTML = '';
                return;
            }

            // Fórmula de cuota nivelada PMT utilizando Math.pow (JavaScript)
            const factor = Math.pow(1 + tasaMensual, plazo);
            const cuota = monto * (tasaMensual * factor) / (factor - 1);
            const totalPagar = cuota * plazo;
            const totalIntereses = totalPagar - monto;

            document.getElementById('lblCuotaEstimada').innerText = '$' + cuota.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblTotalIntereses').innerText = '$' + totalIntereses.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblTotalPagar').innerText = '$' + totalPagar.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });

            // Generar Tabla Resumida de Amortización Básica (primeros 4 meses)
            let saldo = monto;
            let tbodyHtml = '';
            const mesesMostrar = Math.min(plazo, 4);

            for (let m = 1; m <= mesesMostrar; m++) {
                const interesMes = saldo * tasaMensual;
                const capitalMes = cuota - interesMes;
                saldo -= capitalMes;

                tbodyHtml += `
                    <tr>
                        <td class="py-2 px-3 font-bold text-white">Mes ${m}</td>
                        <td class="py-2 px-3 text-emerald-400 font-bold">$${cuota.toFixed(2)}</td>
                        <td class="py-2 px-3">$${interesMes.toFixed(2)}</td>
                        <td class="py-2 px-3">$${capitalMes.toFixed(2)}</td>
                        <td class="py-2 px-3 text-right text-slate-300 font-bold">$${Math.max(saldo, 0).toFixed(2)}</td>
                    </tr>
                `;
            }

            if (plazo > 4) {
                tbodyHtml += `
                    <tr class="bg-[#0F233D]/60 italic text-slate-400">
                        <td colspan="5" class="py-1.5 px-3 text-center text-[10px]">... (${plazo - 4} meses restantes con la misma cuota fija de $${cuota.toFixed(2)}) ...</td>
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
            const simMonto = document.getElementById('simMonto');
            if (simMonto) simMonto.value = val;
        }

        function sincronizarPlazoFormulario(val) {
            const ddlPlazoForm = document.getElementById('<%= ddlPlazoSolicitado.ClientID %>');
            if (ddlPlazoForm) ddlPlazoForm.value = val;
        }

        function sincronizarPlazoSimulador(val) {
            const simPlazo = document.getElementById('simPlazo');
            if (simPlazo) simPlazo.value = val;
        }

        document.addEventListener('DOMContentLoaded', function () {
            calcularSimuladorCredito();
        });
    </script>
</body>
</html>