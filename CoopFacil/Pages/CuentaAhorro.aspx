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
                            <span class="text-xs font-bold uppercase tracking-wider text-emerald-400">PRODUCTO PRINCIPAL DE AHORRO</span>
                            <h1 class="text-3xl sm:text-4xl font-extrabold text-white tracking-tight flex items-center gap-3 mt-1">
                                <i class="fa-solid fa-wallet text-emerald-400"></i> Cuenta de Ahorro
                            </h1>
                        </div>
                        <div class="bg-[#0F233D] border border-emerald-500/40 px-4 py-2 rounded-xl flex items-center gap-3 shadow-lg">
                            <span class="text-xs text-slate-300 font-medium">Tasa Preferencial Rendimiento:</span>
                            <span class="text-lg font-black text-emerald-400">4.75% EA</span>
                        </div>
                    </div>
                    <p class="text-sm sm:text-base text-slate-300 leading-relaxed max-w-3xl">
                        Diseñada para captar fondos iniciales y fomentar el hábito del ahorro a la vista. Disfruta de rendimiento inmediato sobre tu saldo disponible, sin comisiones de mantenimiento y acceso total las 24 horas del día.
                    </p>
                </div>

                <!-- SECCIÓN 1: CALCULADORA Y BENEFICIOS -->
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                    
                    <!-- CALCULADORA DE RENDIMIENTO -->
                    <div class="lg:col-span-7 bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-6">
                        <div class="flex items-center gap-3 border-b border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-emerald-500/20 border border-emerald-400/30 flex items-center justify-center text-emerald-400 text-xl">
                                <i class="fa-solid fa-calculator"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-white">Calculadora de Rendimiento de Ahorro</h2>
                                <p class="text-xs text-slate-400">Proyección estimada de tus ganancias a 12 meses (Tasa 4.75% EA)</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                            <div class="flex flex-col gap-2">
                                <label class="text-xs font-bold text-slate-300 uppercase">Monto Inicial Depositar ($)</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-2.5 text-slate-400 font-bold">$</span>
                                    <input type="number" id="txtMontoInicial" value="500" min="5" step="10" oninput="calcularRendimiento()" class="w-full bg-[#0B1A30] border border-slate-700 rounded-xl pl-8 pr-4 py-2.5 text-sm font-bold text-white focus:outline-none focus:border-emerald-500 transition" />
                                </div>
                            </div>

                            <div class="flex flex-col gap-2">
                                <label class="text-xs font-bold text-slate-300 uppercase">Aporte Mensual Estimado ($)</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-2.5 text-slate-400 font-bold">$</span>
                                    <input type="number" id="txtAporteMensual" value="50" min="0" step="5" oninput="calcularRendimiento()" class="w-full bg-[#0B1A30] border border-slate-700 rounded-xl pl-8 pr-4 py-2.5 text-sm font-bold text-white focus:outline-none focus:border-emerald-500 transition" />
                                </div>
                            </div>
                        </div>

                        <div class="bg-[#0B1A30] border border-emerald-500/30 rounded-xl p-5 grid grid-cols-1 sm:grid-cols-3 gap-4 text-center shadow-inner mt-2">
                            <div class="flex flex-col">
                                <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Total Ahorrado (1 Año)</span>
                                <span id="lblTotalAhorrado" class="text-2xl font-black text-emerald-400 mt-1">$1,133.39</span>
                            </div>
                            <div class="flex flex-col border-t sm:border-t-0 sm:border-l border-slate-800 pt-3 sm:pt-0">
                                <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Ganancia en Intereses</span>
                                <span id="lblIntereses" class="text-2xl font-black text-white mt-1">$33.39</span>
                            </div>
                            <div class="flex flex-col border-t sm:border-t-0 sm:border-l border-slate-800 pt-3 sm:pt-0">
                                <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Tus Aportes Totales</span>
                                <span id="lblTotalDepositado" class="text-2xl font-black text-slate-300 mt-1">$1,100.00</span>
                            </div>
                        </div>

                        <span class="text-[11px] text-slate-400 italic text-center">
                            * Cálculo proyectado a 12 meses con capitalización mensual a una Tasa Efectiva Anual del 4.75%.
                        </span>
                    </div>

                    <!-- TABLA DE BENEFICIOS Y TARIFAS -->
                    <div class="lg:col-span-5 bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-4">
                        <div class="flex items-center gap-3 border-b border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-blue-500/20 border border-blue-400/30 flex items-center justify-center text-blue-400 text-xl">
                                <i class="fa-solid fa-list-check"></i>
                            </div>
                            <div>
                                <h2 class="text-xl font-bold text-white">Beneficios & Tarifas</h2>
                                <p class="text-xs text-slate-400">Condiciones transparentes</p>
                            </div>
                        </div>

                        <div class="overflow-x-auto">
                            <table class="w-full text-left text-xs text-slate-300">
                                <thead>
                                    <tr class="border-b border-slate-800 text-emerald-400 font-bold uppercase">
                                        <th class="py-2.5">Característica / Servicio</th>
                                        <th class="py-2.5 text-right">Condición</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-800/60 font-medium">
                                    <tr>
                                        <td class="py-3 flex items-center gap-2"><i class="fa-solid fa-check text-emerald-400"></i> Cuota de manejo mensual</td>
                                        <td class="py-3 text-right font-bold text-emerald-400">$0.00 (Gratis)</td>
                                    </tr>
                                    <tr>
                                        <td class="py-3"><i class="fa-solid fa-check text-emerald-400"></i> Tarjeta Débito incluida</td>
                                        <td class="py-3 text-right font-bold text-white">Sin costo de emisión</td>
                                    </tr>
                                    <tr>
                                        <td class="py-3"><i class="fa-solid fa-check text-emerald-400"></i> Banca en Línea y App 24/7</td>
                                        <td class="py-3 text-right font-bold text-white">Acceso ilimitado</td>
                                    </tr>
                                    <tr>
                                        <td class="py-3"><i class="fa-solid fa-check text-emerald-400"></i> Notificaciones de movimientos</td>
                                        <td class="py-3 text-right font-bold text-white">SMS / Correo Gratis</td>
                                    </tr>
                                    <tr>
                                        <td class="py-3"><i class="fa-solid fa-check text-emerald-400"></i> Monto Mínimo de Apertura</td>
                                        <td class="py-3 text-right font-bold text-emerald-400">$5.00 USD</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>

                <!-- SECCIÓN 2: FORMULARIO DE PRE-APERTURA -->
                <section class="bg-[#0F233D] border-2 border-emerald-500/40 rounded-2xl p-6 sm:p-8 shadow-2xl relative overflow-hidden">
                    <div class="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 border-b border-slate-800 pb-6 mb-6">
                        <div>
                            <span class="text-xs font-bold text-emerald-400 uppercase tracking-widest block">SOLICITUD RÁPIDA</span>
                            <h2 class="text-2xl font-extrabold text-white mt-1 flex items-center gap-2">
                                <i class="fa-solid fa-file-signature text-emerald-400"></i> Formulario de Pre-Apertura
                            </h2>
                            <p class="text-xs sm:text-sm text-slate-300 mt-1">
                                Ingresa tus datos para agilizar el trámite. Te contactaremos para entregarte tu tarjeta de débito.
                            </p>
                        </div>
                        <div class="hidden sm:flex items-center gap-2 bg-[#0B1A30] border border-slate-700 px-3.5 py-2 rounded-xl text-xs font-bold text-slate-300">
                            <i class="fa-solid fa-shield-halved text-emerald-400 text-sm"></i> Proceso 100% Seguro
                        </div>
                    </div>

                    <!-- MENSAJE DE FEEDBACK -->
                    <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-xl border flex items-center gap-3 text-sm font-bold">
                        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
                        
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

                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-300">Agencia Preferida <span class="text-emerald-400">*</span></label>
                            <asp:DropDownList ID="ddlAgencia" runat="server" CssClass="bg-[#0B1A30] border border-slate-700 rounded-xl px-4 py-2.5 text-xs text-white focus:outline-none focus:border-emerald-500 transition">
                                <asp:ListItem Text="-- Selecciona una agencia --" Value=""></asp:ListItem>
                                <asp:ListItem Text="Agencia Central - San Salvador" Value="Agencia Central"></asp:ListItem>
                                <asp:ListItem Text="Agencia Escalón" Value="Agencia Escalón"></asp:ListItem>
                                <asp:ListItem Text="Agencia Santa Ana" Value="Agencia Santa Ana"></asp:ListItem>
                                <asp:ListItem Text="Agencia San Miguel" Value="Agencia San Miguel"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="flex flex-col justify-end">
                            <asp:Button ID="btnSolicitarApertura" runat="server" Text="Enviar Solicitud de Pre-Apertura" OnClick="btnSolicitarApertura_Click" CssClass="w-full bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs py-3 rounded-xl shadow-lg shadow-emerald-950 transition cursor-pointer" />
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
        function calcularRendimiento() {
            const montoInicial = parseFloat(document.getElementById('txtMontoInicial').value) || 0;
            const aporteMensual = parseFloat(document.getElementById('txtAporteMensual').value) || 0;
            const tasaAnual = 0.0475;
            const tasaMensual = tasaAnual / 12;

            let saldo = montoInicial;
            let totalDepositado = montoInicial;

            for (let i = 1; i <= 12; i++) {
                saldo += aporteMensual;
                totalDepositado += aporteMensual;
                saldo += (saldo * tasaMensual);
            }

            const interesesGenerados = saldo - totalDepositado;

            document.getElementById('lblTotalAhorrado').innerText = '$' + saldo.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblIntereses').innerText = '$' + interesesGenerados.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
            document.getElementById('lblTotalDepositado').innerText = '$' + totalDepositado.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        document.addEventListener('DOMContentLoaded', function () {
            calcularRendimiento();
        });
    </script>
</body>
</html>