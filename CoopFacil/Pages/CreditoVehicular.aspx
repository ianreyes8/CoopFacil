<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreditoVehicular.aspx.cs" Inherits="CoopFacil.Pages.CreditoVehicular" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Crédito Vehicular - CoopFacil</title>
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
                            <span class="text-xs font-bold uppercase tracking-wider text-emerald-400">FINANCIAMIENTO AUTOMOTRIZ</span>
                            <h1 class="text-3xl sm:text-4xl font-extrabold text-white tracking-tight flex items-center gap-3 mt-1">
                                <i class="fa-solid fa-car text-emerald-400"></i> Crédito Vehicular
                            </h1>
                        </div>
                        <div class="bg-[#0F233D] border border-emerald-500/40 px-4 py-2 rounded-xl flex items-center gap-3 shadow-lg">
                            <span class="text-xs text-slate-300 font-medium">Tasa Preferencial Auto:</span>
                            <span class="text-lg font-black text-emerald-400">Desde 9.80% EA</span>
                        </div>
                    </div>
                    <p class="text-sm sm:text-base text-slate-300 leading-relaxed max-w-3xl">
                        Adquiere tu vehículo nuevo o usado con garantía prendaria. Financiamos hasta el 80% para autos nuevos y el 70% para autos usados con plazos de 12 a 72 meses y cuota fija garantizada.
                    </p>
                </div>

                <!-- SECCIÓN 1: COTIZADOR VEHICULAR Y RESULTADOS DE FINANCIAMIENTO -->
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                    
                    <!-- COTIZADOR VEHICULAR (INPUTS) -->
                    <div class="lg:col-span-7 bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-6">
                        <div class="flex items-center gap-3 border-b border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-emerald-500/20 border border-emerald-400/30 flex items-center justify-center text-emerald-400 text-xl">
                                <i class="fa-solid fa-calculator"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-white">Cotizador Vehicular</h2>
                                <p class="text-xs text-slate-400">Calcula tu cuota a plazos flexibles de 12 a 72 meses</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                            
                            <!-- ESTADO DEL VEHÍCULO -->
                            <div class="flex flex-col gap-2">
                                <label class="text-xs font-bold text-slate-300 uppercase">Estado del Vehículo <span class="text-emerald-400">*</span></label>
                                <asp:DropDownList ID="ddlEstadoVehiculo" runat="server" onchange="actualizarReglasEstado(); calcularCotizadorVehicular();" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-3 py-2.5 text-xs font-bold text-white focus:outline-none focus:border-emerald-500 transition">
                                    <asp:ListItem Text="✨ Vehículo Nuevo (Financia hasta 80%)" Value="Nuevo" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="🚗 Vehículo Usado (Financia hasta 70%)" Value="Usado"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <!-- PLAZO DE FINANCIAMIENTO (CORREGIDO A ASP:LISTITEM) -->
                            <div class="flex flex-col gap-2">
                                <label class="text-xs font-bold text-slate-300 uppercase">Plazo en Meses <span class="text-emerald-400">*</span></label>
                                <asp:DropDownList ID="ddlPlazoMeses" runat="server" onchange="calcularCotizadorVehicular()" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-3 py-2.5 text-xs font-bold text-white focus:outline-none focus:border-emerald-500 transition">
                                    <asp:ListItem Text="12 Meses (1 Año)" Value="12"></asp:ListItem>
                                    <asp:ListItem Text="24 Meses (2 Años)" Value="24"></asp:ListItem>
                                    <asp:ListItem Text="36 Meses (3 Años)" Value="36"></asp:ListItem>
                                    <asp:ListItem Text="48 Meses (4 Años)" Value="48" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="60 Meses (5 Años)" Value="60"></asp:ListItem>
                                    <asp:ListItem Text="72 Meses (6 Años)" Value="72"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <!-- PRECIO COMERCIAL DEL VEHÍCULO -->
                            <div class="flex flex-col gap-2">
                                <label class="text-xs font-bold text-slate-300 uppercase">Precio Comercial ($ USD)</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-2.5 text-slate-400 font-bold">$</span>
                                    <asp:TextBox ID="txtPrecioComercial" runat="server" TextMode="Number" Text="18000" min="3000" step="any" oninput="sincronizarMontoFormulario(); calcularCotizadorVehicular();" CssClass="w-full bg-[#0B1A30] border border-slate-700 rounded-xl pl-8 pr-3 py-2.5 text-xs font-bold text-white focus:outline-none focus:border-emerald-500 transition" placeholder="18000"></asp:TextBox>
                                </div>
                            </div>

                            <!-- PRIMA INICIAL -->
                            <div class="flex flex-col gap-2">
                                <div class="flex justify-between items-center">
                                    <label class="text-xs font-bold text-slate-300 uppercase">Prima Inicial ($ USD)</label>
                                    <span id="lblSugeridoPrima" class="text-[10px] font-bold text-emerald-400">Mín. 20% ($3,600)</span>
                                </div>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-2.5 text-slate-400 font-bold">$</span>
                                    <asp:TextBox ID="txtPrimaInicial" runat="server" TextMode="Number" Text="3600" min="0" step="any" oninput="calcularCotizadorVehicular();" CssClass="w-full bg-[#0B1A30] border border-slate-700 rounded-xl pl-8 pr-3 py-2.5 text-xs font-bold text-white focus:outline-none focus:border-emerald-500 transition" placeholder="3600"></asp:TextBox>
                                </div>
                            </div>

                        </div>

                        <!-- ALERTA DE COBERTURA Y PORCENTAJE -->
                        <div id="divAvisoPrima" class="hidden bg-amber-950/40 border border-amber-500/40 rounded-xl p-3 text-xs text-amber-200 flex items-center gap-2">
                            <i class="fa-solid fa-triangle-exclamation text-amber-400 text-sm"></i>
                            <span id="lblAvisoPrimaTexto">La prima ingresada es menor al mínimo requerido para este tipo de vehículo.</span>
                        </div>

                        <!-- RESUMEN DE MONTO A FINANCIAR -->
                        <div class="bg-[#0B1A30] border border-slate-800 rounded-xl p-4 flex justify-between items-center text-xs">
                            <span class="text-slate-400 font-medium">Monto Total a Financiar (Crédito):</span>
                            <span id="lblMontoFinanciar" class="text-base font-extrabold text-emerald-400">$14,400.00</span>
                        </div>
                    </div>

                    <!-- RESULTADOS DE CUOTA Y CONDICIONES -->
                    <div class="lg:col-span-5 bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-5">
                        <div class="flex items-center gap-3 border-b border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-blue-500/20 border border-blue-400/30 flex items-center justify-center text-blue-400 text-xl">
                                <i class="fa-solid fa-file-invoice-dollar"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-white">Resumen de Cuota Fija</h2>
                                <p class="text-xs text-slate-400">Garantía prendaria sobre la unidad</p>
                            </div>
                        </div>

                        <!-- CUOTA MENSUAL DESTACADA -->
                        <div class="bg-[#0B1A30] border border-emerald-500/40 rounded-xl p-5 text-center flex flex-col items-center justify-center shadow-inner">
                            <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Cuota Mensual Estimada</span>
                            <span id="lblCuotaMensual" class="text-3xl font-black text-emerald-400 mt-1">$364.21</span>
                            <span id="lblTasaAplicada" class="text-[10px] text-slate-400 mt-1">* Tasa del 9.80% EA para vehículo nuevo</span>
                        </div>

                        <div class="space-y-2.5 text-xs text-slate-300">
                            <div class="flex justify-between items-center py-2 border-b border-slate-800">
                                <span class="flex items-center gap-2"><i class="fa-solid fa-coins text-emerald-400"></i> Total de Intereses Estimados:</span>
                                <span id="lblTotalIntereses" class="font-bold text-white">$3,082.08</span>
                            </div>

                            <div class="flex justify-between items-center py-2 border-b border-slate-800">
                                <span class="flex items-center gap-2"><i class="fa-solid fa-percent text-blue-400"></i> Porcentaje de Financiamiento:</span>
                                <span id="lblPctFinanciado" class="font-bold text-emerald-400">80.0%</span>
                            </div>

                            <div class="flex justify-between items-center py-2 border-b border-slate-800">
                                <span class="flex items-center gap-2"><i class="fa-solid fa-shield-cat text-amber-400"></i> Seguro Colectivo / Deuda:</span>
                                <span class="font-bold text-slate-200">Incluido en Cuota</span>
                            </div>
                        </div>

                        <ul class="text-xs text-slate-300 space-y-1.5 pt-1">
                            <li class="flex items-center gap-2"><i class="fa-solid fa-check text-emerald-400"></i> Sin cobro por estudio o análisis de crédito.</li>
                            <li class="flex items-center gap-2"><i class="fa-solid fa-check text-emerald-400"></i> Pagos anticipados a capital sin penalización.</li>
                        </ul>
                    </div>

                </div>

                <!-- SECCIÓN 2: SOLICITUD DE CRÉDITO Y ADJUNTO DE PROFORMA -->
                <section class="bg-[#0F233D] border-2 border-emerald-500/40 rounded-2xl p-6 sm:p-8 shadow-2xl relative overflow-hidden">
                    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 border-b border-slate-800 pb-6 mb-6">
                        <div>
                            <span class="text-xs font-bold text-emerald-400 uppercase tracking-widest block">REGISTRO DE EVALUACIÓN</span>
                            <h2 class="text-2xl font-extrabold text-white mt-1 flex items-center gap-2">
                                <i class="fa-solid fa-file-signature text-emerald-400"></i> Solicitud de Crédito Vehicular
                            </h2>
                            <p class="text-xs sm:text-sm text-slate-300 mt-1">
                                Envía tus datos directos al Departamento de Riesgos para la revisión e inspección de la unidad.
                            </p>
                        </div>
                        <div class="hidden sm:flex items-center gap-2 bg-[#0B1A30] border border-slate-700 px-3.5 py-2 rounded-xl text-xs font-bold text-slate-300">
                            <i class="fa-solid fa-shield-halved text-emerald-400 text-sm"></i> Garantía Prendaria Registrada
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

                        <!-- MARCA Y MODELO DEL VEHÍCULO -->
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Marca, Modelo y Año <span class="text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtMarcaModelo" runat="server" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="Ej. Toyota Corolla 2024"></asp:TextBox>
                        </div>

                        <!-- CONCESIONARIO / VENDEDOR -->
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Concesionario / Vendedor <span class="text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtConcesionario" runat="server" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="Ej. Excel Automotriz / Particular"></asp:TextBox>
                        </div>

                        <!-- ADJUNTO DE PROFORMA O COTIZACIÓN (OPCIONAL) -->
                        <div class="flex flex-col gap-1.5 lg:col-span-2">
                            <label class="text-xs font-bold text-slate-300">Adjunto de Proforma / Cotización <span class="text-slate-400 font-normal">(Opcional: .pdf, .jpg, .png)</span></label>
                            <asp:FileUpload ID="fileProforma" runat="server" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-3 py-2 text-xs text-slate-300 file:mr-3 file:py-1 file:px-3 file:rounded-lg file:border-0 file:text-xs file:font-bold file:bg-emerald-600 file:text-white hover:file:bg-emerald-500 transition cursor-pointer" />
                        </div>

                    </div>

                    <div class="mt-6 flex justify-end">
                        <asp:Button ID="btnSolicitarCredito" runat="server" Text="Enviar Solicitud al Departamento de Riesgos" OnClick="btnSolicitarCredito_Click" CssClass="w-full sm:w-auto bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs px-8 py-3.5 rounded-xl shadow-lg shadow-emerald-950 transition cursor-pointer" />
                    </div>
                </section>

            </main>
        </div>

        <footer class="bg-[#0F233D] border-t-2 border-slate-700/80 text-slate-400 text-xs text-center py-6 mt-auto">
            <p>© 2026 CoopFacil. Todos los derechos reservados.</p>
        </footer>

    </form>

    <script>
        function actualizarReglasEstado() {
            const estadoSelect = document.getElementById('<%= ddlEstadoVehiculo.ClientID %>');
            const txtPrecio = document.getElementById('<%= txtPrecioComercial.ClientID %>');
            const txtPrima = document.getElementById('<%= txtPrimaInicial.ClientID %>');
            const lblSugerido = document.getElementById('lblSugeridoPrima');

            if (!estadoSelect || !txtPrecio || !txtPrima) return;

            const estado = estadoSelect.value;
            const precio = parseFloat(txtPrecio.value) || 0;

            if (estado === 'Nuevo') {
                const primaMin = precio * 0.20;
                if (lblSugerido) lblSugerido.innerText = 'Mín. 20% ($' + primaMin.toFixed(2) + ')';
            } else {
                const primaMin = precio * 0.30;
                if (lblSugerido) lblSugerido.innerText = 'Mín. 30% ($' + primaMin.toFixed(2) + ')';
            }
        }

        function calcularCotizadorVehicular() {
            const estadoSelect = document.getElementById('<%= ddlEstadoVehiculo.ClientID %>');
            const txtPrecio = document.getElementById('<%= txtPrecioComercial.ClientID %>');
            const txtPrima = document.getElementById('<%= txtPrimaInicial.ClientID %>');
            const ddlPlazo = document.getElementById('<%= ddlPlazoMeses.ClientID %>');

            if (!estadoSelect || !txtPrecio || !txtPrima || !ddlPlazo) return;

            const estado = estadoSelect.value;
            const precio = parseFloat(txtPrecio.value) || 0;
            const prima = parseFloat(txtPrima.value) || 0;
            const plazo = parseInt(ddlPlazo.value) || 48;

            const pctMaxFinanciar = (estado === 'Nuevo') ? 0.80 : 0.70;
            const primaMinima = precio * (1.0 - pctMaxFinanciar);

            const divAviso = document.getElementById('divAvisoPrima');
            const lblAvisoTexto = document.getElementById('lblAvisoPrimaTexto');

            if (precio > 0 && prima < primaMinima) {
                if (divAviso) divAviso.classList.remove('hidden');
                if (lblAvisoTexto) {
                    lblAvisoTexto.innerHTML = `Para un vehículo <strong>${estado}</strong>, la prima mínima recomendada es de <strong>$${primaMinima.toFixed(2)}</strong> (${((1 - pctMaxFinanciar) * 100).toFixed(0)}%).`;
                }
            } else {
                if (divAviso) divAviso.classList.add('hidden');
            }

            const montoFinanciar = Math.max(precio - prima, 0);
            const tasaAnual = (estado === 'Nuevo') ? 0.098 : 0.115; // 9.8% EA Nuevo / 11.5% EA Usado
            const tasaMensual = tasaAnual / 12;

            let cuota = 0;
            let totalIntereses = 0;

            if (montoFinanciar > 0 && plazo > 0) {
                // Cálculo de cuota nivelada PMT con Math.pow (JavaScript)
                const factor = Math.pow(1 + tasaMensual, plazo);
                cuota = montoFinanciar * (tasaMensual * factor) / (factor - 1);
                const totalPagar = cuota * plazo;
                totalIntereses = totalPagar - montoFinanciar;
            }

            const pctFinanciado = (precio > 0) ? (montoFinanciar / precio) * 100 : 0;

            document.getElementById('lblMontoFinanciar').innerText = '$' + montoFinanciar.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblCuotaMensual').innerText = '$' + cuota.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblTotalIntereses').innerText = '$' + totalIntereses.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblPctFinanciado').innerText = pctFinanciado.toFixed(1) + '%';
            document.getElementById('lblTasaAplicada').innerText = `* Tasa del ${(tasaAnual * 100).toFixed(1)}% EA para vehículo ${estado.toLowerCase()}`;

            actualizarReglasEstado();
        }

        function sincronizarMontoFormulario() {
            actualizarReglasEstado();
        }

        document.addEventListener('DOMContentLoaded', function () {
            calcularCotizadorVehicular();
        });
    </script>
</body>
</html>