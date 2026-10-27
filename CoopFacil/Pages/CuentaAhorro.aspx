<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CuentaAhorro.aspx.cs" Inherits="CoopFacil.Pages.CuentaAhorro" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Cuenta de Ahorro - CoopFacil</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="bg-[#0B1A30] text-white font-sans antialiased min-h-screen flex flex-col justify-between">
    <form id="form1" runat="server" autocomplete="off" class="min-h-screen flex flex-col justify-between">
        
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
                    <asp:HyperLink ID="lnkIniciarSesion" runat="server" NavigateUrl="../Default.aspx" CssClass="bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs sm:text-sm px-5 py-2.5 rounded-lg transition flex items-center gap-2 shadow-lg shadow-blue-900/40">
                        <i class="fa-solid fa-right-to-bracket"></i> Iniciar Sesión
                    </asp:HyperLink>

                    <asp:LinkButton ID="btnCerrarSesion" runat="server" OnClick="btnCerrarSesion_Click" Visible="false" CssClass="bg-[#0F233D] hover:bg-slate-700 border border-slate-600 text-white font-bold text-xs sm:text-sm px-4 py-2.5 rounded-lg transition flex items-center gap-2">
                        <i class="fa-solid fa-right-from-bracket"></i> Cerrar Sesión
                    </asp:LinkButton>
                </div>

            </header>

            <!-- CONTENIDO PRINCIPAL -->
            <main class="max-w-7xl mx-auto px-6 py-8 flex flex-col gap-8 flex-grow w-full">
                
                <!-- ENLACE DE REGRESO -->
                <div>
                    <a href="Servicios.aspx" class="text-xs font-bold text-emerald-400 hover:underline flex items-center gap-2 w-fit">
                        <i class="fa-solid fa-arrow-left"></i> Volver al Portafolio de Servicios
                    </a>
                </div>

                <!-- ENCABEZADO Y BADGE DE TASA -->
                <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
                    <div>
                        <span class="text-[11px] font-bold uppercase tracking-wider text-emerald-400 block mb-1">PRODUCTO PRINCIPAL DE AHORRO</span>
                        <h1 class="text-3xl sm:text-4xl font-extrabold text-white tracking-tight flex items-center gap-3">
                            <div class="w-10 h-10 rounded-xl bg-emerald-500/20 border border-emerald-400/30 flex items-center justify-center text-emerald-400 text-xl shadow-inner">
                                <i class="fa-solid fa-wallet"></i>
                            </div>
                            Cuenta de Ahorro
                        </h1>
                        <p class="text-xs sm:text-sm text-slate-300 leading-relaxed max-w-3xl mt-2">
                            Diseñada para captar fondos iniciales y fomentar el hábito del ahorro a la vista. Disfruta de rendimiento inmediato sobre tu saldo disponible, sin comisiones de mantenimiento y acceso total las 24 horas del día.
                        </p>
                    </div>

                    <div class="bg-[#0F233D] border border-emerald-500/40 px-5 py-2.5 rounded-xl flex items-center gap-2 shadow-lg whitespace-nowrap">
                        <span class="text-xs text-slate-300 font-medium">Tasa Preferencial Rendimiento:</span>
                        <span class="text-base sm:text-lg font-black text-emerald-400">10% ANUAL</span>
                    </div>
                </div>

                <!-- SECCIÓN SUPERIOR: CALCULADORA Y BENEFICIOS/TARIFAS -->
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-stretch">
                    
                    <!-- IZQUIERDA: CALCULADORA DE RENDIMIENTO DE AHORRO -->
                    <div class="lg:col-span-7 bg-[#0F233D] border border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col justify-between gap-6">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 rounded-xl bg-emerald-500/20 border border-emerald-400/30 flex items-center justify-center text-emerald-400 text-lg">
                                <i class="fa-solid fa-calculator"></i>
                            </div>
                            <div>
                                <h2 class="text-lg font-bold text-white">Calculadora de Rendimiento de Ahorro</h2>
                                <p class="text-xs text-slate-400">Proyección estimada de tus ganancias a 12 meses (Tasa 10% anual)</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                            <div class="flex flex-col gap-1.5">
                                <label class="text-[11px] font-bold text-slate-300 uppercase">Monto Inicial Depositar ($)</label>
                                <div class="relative flex items-center">
                                    <span class="absolute left-4 text-slate-300 font-bold text-sm">$</span>
                                    <asp:TextBox ID="txtMontoInicial" runat="server" autocomplete="off" Text="500" oninput="formatearYCalcularMonto(this)" CssClass="w-full bg-[#0B1A30] border border-slate-700 rounded-xl pl-8 pr-4 py-2.5 text-sm font-bold text-white focus:outline-none focus:border-emerald-500 transition" placeholder="500"></asp:TextBox>
                                </div>
                            </div>

                            <div class="flex flex-col gap-1.5">
                                <label class="text-[11px] font-bold text-slate-300 uppercase">Aporte Mensual Estimado ($)</label>
                                <div class="relative flex items-center">
                                    <span class="absolute left-4 text-slate-300 font-bold text-sm">$</span>
                                    <asp:TextBox ID="txtAporteMensual" runat="server" autocomplete="off" Text="50" oninput="formatearYCalcularMonto(this)" CssClass="w-full bg-[#0B1A30] border border-slate-700 rounded-xl pl-8 pr-4 py-2.5 text-sm font-bold text-white focus:outline-none focus:border-emerald-500 transition" placeholder="50"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <div class="bg-[#0B1A30] border border-slate-800 rounded-xl p-4 grid grid-cols-1 sm:grid-cols-3 gap-4 text-center items-center shadow-inner">
                            <div class="flex flex-col">
                                <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">TOTAL AHORRADO (1 AÑO)</span>
                                <span id="lblTotalAhorrado" class="text-2xl font-extrabold text-emerald-400 mt-1">$1,185.87</span>
                            </div>

                            <div class="flex flex-col sm:border-x sm:border-slate-800 px-2">
                                <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">GANANCIA EN INTERESES</span>
                                <span id="lblGananciaIntereses" class="text-2xl font-extrabold text-white mt-1">$85.87</span>
                            </div>

                            <div class="flex flex-col">
                                <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">TUS APORTES TOTALES</span>
                                <span id="lblAportesTotales" class="text-2xl font-extrabold text-white mt-1">$1,100.00</span>
                            </div>
                        </div>

                        <p class="text-[10px] text-slate-400 italic text-center">
                            * Cálculo proyectado a 12 meses con capitalización mensual a una Tasa Efectiva Anual del 10%.
                        </p>
                    </div>

                    <!-- DERECHA: BENEFICIOS & TARIFAS -->
                    <div class="lg:col-span-5 bg-[#0F233D] border border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col justify-between gap-5">
                        <div class="flex items-center gap-3">
                            <div class="w-9 h-9 rounded-xl bg-blue-500/20 border border-blue-400/30 flex items-center justify-center text-blue-400 text-lg">
                                <i class="fa-solid fa-list-check"></i>
                            </div>
                            <div>
                                <h2 class="text-lg font-bold text-white">Beneficios & Tarifas</h2>
                                <p class="text-xs text-slate-400">Condiciones transparentes</p>
                            </div>
                        </div>

                        <div class="space-y-3 text-xs">
                            <div class="flex justify-between items-center text-slate-400 font-bold pb-1 border-b border-slate-800 text-[11px] uppercase tracking-wider">
                                <span>CARACTERÍSTICA / SERVICIO</span>
                                <span>CONDICIÓN</span>
                            </div>

                            <div class="flex justify-between items-center py-1.5 border-b border-slate-800/60">
                                <span class="flex items-center gap-2 text-slate-200"><i class="fa-solid fa-check text-emerald-400"></i> Cuota de manejo mensual</span>
                                <span class="font-bold text-emerald-400">$0.00 (Gratis)</span>
                            </div>

                            <div class="flex justify-between items-center py-1.5 border-b border-slate-800/60">
                                <span class="flex items-center gap-2 text-slate-200"><i class="fa-solid fa-check text-emerald-400"></i> Tarjeta Débito incluida</span>
                                <span class="font-bold text-white">Sin costo de emisión</span>
                            </div>

                            <div class="flex justify-between items-center py-1.5 border-b border-slate-800/60">
                                <span class="flex items-center gap-2 text-slate-200"><i class="fa-solid fa-check text-emerald-400"></i> Banca en Línea y App 24/7</span>
                                <span class="font-bold text-white">Acceso ilimitado</span>
                            </div>

                            <div class="flex justify-between items-center py-1.5 border-b border-slate-800/60">
                                <span class="flex items-center gap-2 text-slate-200"><i class="fa-solid fa-check text-emerald-400"></i> Notificaciones de movimientos</span>
                                <span class="font-bold text-white">SMS / Correo Gratis</span>
                            </div>

                            <div class="flex justify-between items-center py-1.5">
                                <span class="flex items-center gap-2 text-slate-200"><i class="fa-solid fa-check text-emerald-400"></i> Monto Mínimo de Apertura</span>
                                <span class="font-bold text-emerald-400">$5.00 USD</span>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- SECCIÓN INFERIOR: FORMULARIO DE PRE-APERTURA -->
                <section class="bg-[#0F233D] border border-slate-700/80 rounded-2xl p-6 sm:p-8 shadow-2xl relative overflow-hidden">
                    <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 mb-2">
                        <div>
                            <span class="text-[10px] font-bold text-emerald-400 uppercase tracking-widest block">SOLICITUD RÁPIDA</span>
                            <h2 class="text-2xl font-extrabold text-white mt-0.5 flex items-center gap-2">
                                <i class="fa-solid fa-file-signature text-emerald-400"></i> Formulario de Pre-Apertura
                            </h2>
                        </div>
                        <div class="flex items-center gap-2 bg-[#0B1A30] border border-slate-700 px-3.5 py-1.5 rounded-xl text-xs font-bold text-slate-300">
                            <i class="fa-solid fa-shield-halved text-emerald-400 text-sm"></i> Proceso 100% Seguro
                        </div>
                    </div>

                    <p class="text-xs text-slate-300 mb-6">
                        Ingresa tus datos para agilizar el trámite. Te contactaremos para entregarte tu tarjeta de débito.
                    </p>

                    <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-xl border flex items-center gap-3 text-xs font-bold">
                        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="grid grid-cols-1 md:grid-cols-3 gap-5 mb-5">
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Nombre Completo <span class="text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtNombre" runat="server" autocomplete="off" attr-autocomplete="new-password" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="Leonardo Vasquez"></asp:TextBox>
                        </div>

                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Documento de Identidad (DUI) <span class="text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtDUI" runat="server" autocomplete="off" attr-autocomplete="new-password" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="00000000-0"></asp:TextBox>
                        </div>

                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Teléfono de Contacto <span class="text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtTelefono" runat="server" autocomplete="off" attr-autocomplete="new-password" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="7777-8888"></asp:TextBox>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-12 gap-5 items-end">
                        <div class="md:col-span-5 flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Correo Electrónico <span class="text-emerald-400">*</span></label>
                            <asp:TextBox ID="txtCorreo" runat="server" TextMode="Email" autocomplete="off" attr-autocomplete="new-password" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" placeholder="correo@ejemplo.com"></asp:TextBox>
                        </div>

                        <div class="md:col-span-4 flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Agencia Preferida <span class="text-emerald-400">*</span></label>
                            <asp:DropDownList ID="ddlAgencia" runat="server" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-emerald-500 transition">
                                <asp:ListItem Text="Agencia Central - San Salvador" Value="Agencia Central"></asp:ListItem>
                                <asp:ListItem Text="Agencia Escalón" Value="Agencia Escalón"></asp:ListItem>
                                <asp:ListItem Text="Agencia Soyapango" Value="Agencia Soyapango"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="md:col-span-3">
                            <asp:Button ID="btnEnviarPreApertura" runat="server" Text="Enviar Solicitud de Pre-Apertura" OnClick="btnEnviarPreApertura_Click" CssClass="w-full bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs py-3 rounded-xl shadow-lg shadow-emerald-950 transition cursor-pointer" />
                        </div>
                    </div>
                </section>

            </main>
        </div>

        <footer class="bg-[#0F233D] border-t-2 border-slate-700/80 text-slate-400 text-xs text-center py-6 mt-auto">
            <p>© 2026 CoopFacil. Todos los derechos reservados.</p>
        </footer>

    </form>

    <script>
        function formatearYCalcularMonto(input) {
            if (!input) return;
            let valorLimpio = input.value.replace(/[^0-9]/g, '');
            if (valorLimpio !== "") {
                input.value = parseInt(valorLimpio, 10).toLocaleString('en-US');
            } else {
                input.value = "";
            }
            calcularRendimientoAhorro();
        }

        function obtenerNumeroSinComas(valor) {
            if (!valor) return 0;
            let numLimpio = valor.toString().replace(/,/g, '');
            return parseFloat(numLimpio) || 0;
        }

        function calcularRendimientoAhorro() {
            const txtInicial = document.getElementById('<%= txtMontoInicial.ClientID %>');
            const txtAporte = document.getElementById('<%= txtAporteMensual.ClientID %>');

            if (!txtInicial || !txtAporte) return;

            const montoInicial = obtenerNumeroSinComas(txtInicial.value);
            const aporteMensual = obtenerNumeroSinComas(txtAporte.value);

            const tasaAnual = 0.10;
            const tasaMensual = tasaAnual / 12;
            const meses = 12;

            let balanceAcumulado = montoInicial;
            for (let m = 1; m <= meses; m++) {
                balanceAcumulado = (balanceAcumulado * (1 + tasaMensual)) + aporteMensual;
            }

            const aportesTotales = montoInicial + (aporteMensual * meses);
            const gananciaIntereses = balanceAcumulado - aportesTotales;

            document.getElementById('lblTotalAhorrado').innerText = '$' + balanceAcumulado.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblGananciaIntereses').innerText = '$' + gananciaIntereses.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblAportesTotales').innerText = '$' + aportesTotales.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        document.addEventListener('DOMContentLoaded', function () {
            const txtInicial = document.getElementById('<%= txtMontoInicial.ClientID %>');
            const txtAporte = document.getElementById('<%= txtAporteMensual.ClientID %>');

            if (txtInicial) formatearYCalcularMonto(txtInicial);
            if (txtAporte) formatearYCalcularMonto(txtAporte);

            calcularRendimientoAhorro();
        });
</script>
</body>
</html>