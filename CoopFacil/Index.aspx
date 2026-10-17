<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="CoopFacil.Index" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Inicio - CoopFacil</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="bg-[#0B1A30] text-white font-sans antialiased min-h-screen p-6 sm:p-10 flex flex-col justify-between relative">
    <form id="form1" runat="server" class="max-w-7xl mx-auto w-full flex flex-col gap-8 flex-grow">
        
        <!-- BIENVENIDA ESQUINA SUPERIOR IZQUIERDA -->
        <div class="absolute top-6 left-6 z-40">
            <asp:Panel ID="pnlBienvenida" runat="server" Visible="false" CssClass="flex items-center gap-2.5 bg-[#0F233D] border border-emerald-500/40 px-4 py-2 rounded-xl shadow-lg">
                <i class="fa-solid fa-circle-user text-emerald-400 text-lg"></i>
                <span class="text-sm font-bold text-white">
                    Bienvenido <asp:Literal ID="litBienvenida" runat="server"></asp:Literal>
                </span>
            </asp:Panel>
        </div>

        <!-- BOTONES DE NAVEGACIÓN Y SESIÓN (ESQUINA SUPERIOR DERECHA) -->
        <div class="absolute top-6 right-6 flex items-center gap-3 z-40">
            <asp:HyperLink ID="lnkIniciarSesion" runat="server" NavigateUrl="Default.aspx" CssClass="bg-blue-600 hover:bg-blue-500 text-white font-bold text-sm px-5 py-2.5 rounded-lg transition flex items-center gap-2 shadow-lg shadow-blue-900/40">
                <i class="fa-solid fa-right-to-bracket"></i> Iniciar Sesión
            </asp:HyperLink>

            <asp:LinkButton ID="btnPortalSocio" runat="server" OnClick="btnPortalSocio_Click" CssClass="bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-sm px-5 py-2.5 rounded-lg transition flex items-center gap-2 shadow-lg shadow-emerald-900/40">
                <i class="fa-solid fa-user-check"></i> Portal Socio
            </asp:LinkButton>

            <asp:LinkButton ID="btnCerrarSesion" runat="server" OnClick="btnCerrarSesion_Click" CssClass="bg-[#0F233D] hover:bg-slate-700 border border-slate-600 text-white font-bold text-sm px-5 py-2.5 rounded-lg transition flex items-center gap-2">
                <i class="fa-solid fa-right-from-bracket"></i> Cerrar Sesión
            </asp:LinkButton>
        </div>

        <!-- ENCABEZADO PRINCIPAL Y SLOGAN -->
        <div class="grid grid-cols-1 md:grid-cols-12 gap-6 items-stretch mt-12 md:mt-6">
            <div class="md:col-span-4 bg-[#0F233D] border-2 border-slate-700/80 rounded-2xl p-6 flex flex-col items-center justify-center text-center shadow-xl min-h-[180px]">
                <div class="flex items-center justify-center gap-1 mb-3">
                    <div class="relative flex items-center justify-center">
                        <i class="fa-solid fa-user text-4xl text-blue-500"></i>
                        <i class="fa-solid fa-user text-4xl text-emerald-500 -ml-2"></i>
                        <i class="fa-solid fa-arrow-up-right-dots text-2xl text-emerald-400 absolute -top-3 -right-4"></i>
                    </div>
                </div>
                <h2 class="text-3xl font-extrabold tracking-tight">
                    <span class="text-blue-500">Coop</span><span class="text-emerald-500">Facil</span>
                </h2>
                <p class="text-sm text-slate-400 font-medium mt-1">Cooperativa Financiera</p>
            </div>

            <div class="md:col-span-8 flex flex-col gap-4 justify-between">
                <div class="bg-[#0F233D] border-2 border-slate-700/80 rounded-xl p-6 flex items-center justify-center shadow-md min-h-[85px]">
                    <h3 class="text-xl sm:text-2xl font-bold text-white text-center">"Finanzas que construyen comunidad desde 1987"</h3>
                </div>

                <div class="bg-[#0F233D] border-2 border-slate-700/80 rounded-xl p-6 shadow-md flex-grow flex items-center">
                    <p class="text-base text-slate-300 leading-relaxed text-center w-full">
                        Somos una institución financiera comprometida con el desarrollo social y económico de nuestros socios. Brindamos servicios integrales de ahorro, crédito e inversión con total transparencia y respaldo.
                    </p>
                </div>
            </div>
        </div>

        <!-- MENÚ DE MÓDULOS PÚBLICOS (REDISTRIBUIDO: 2 ARRIBA Y 2 ABAJO EQUITATIVAMENTE) -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 flex-grow items-stretch my-auto w-full">
            <a href="Pages/QuienesSomos.aspx" class="bg-[#0F233D] hover:bg-[#132c4d] border-2 border-slate-700 hover:border-blue-500 rounded-2xl p-10 flex flex-col items-center justify-center text-center transition group shadow-xl min-h-[180px]">
                <i class="fa-solid fa-users text-5xl text-blue-500 group-hover:scale-110 transition mb-4"></i>
                <span class="text-2xl font-bold text-white transition">Quiénes somos</span>
            </a>

            <a href="Pages/Servicios.aspx" class="bg-[#0F233D] hover:bg-[#132c4d] border-2 border-slate-700 hover:border-emerald-500 rounded-2xl p-10 flex flex-col items-center justify-center text-center transition group shadow-xl min-h-[180px]">
                <i class="fa-solid fa-hand-holding-dollar text-5xl text-emerald-500 group-hover:scale-110 transition mb-4"></i>
                <span class="text-2xl font-bold text-white transition">Servicios</span>
            </a>

            <a href="Pages/Transparencia.aspx" class="bg-[#0F233D] hover:bg-[#132c4d] border-2 border-slate-700 hover:border-blue-500 rounded-2xl p-10 flex flex-col items-center justify-center text-center transition group shadow-xl min-h-[180px]">
                <i class="fa-solid fa-scale-balanced text-5xl text-blue-500 group-hover:scale-110 transition mb-4"></i>
                <span class="text-2xl font-bold text-white transition">Transparencia</span>
            </a>

            <a href="Pages/Contacto.aspx" class="bg-[#0F233D] hover:bg-[#132c4d] border-2 border-slate-700 hover:border-blue-500 rounded-2xl p-10 flex flex-col items-center justify-center text-center transition group shadow-xl min-h-[180px]">
                <i class="fa-solid fa-envelope-open-text text-5xl text-blue-500 group-hover:scale-110 transition mb-4"></i>
                <span class="text-2xl font-bold text-white transition">Contacto</span>
            </a>
        </div>

        <!-- MODAL DEL PORTAL SOCIO -->
        <div id="modalPortalSocio" class="fixed inset-0 z-50 flex items-center justify-center hidden p-4 bg-[#0B1A30]/80 backdrop-blur-sm">
            <div class="bg-white text-slate-800 rounded-2xl max-w-4xl w-full p-8 shadow-2xl relative max-h-[95vh] overflow-y-auto">
                
                <!-- Botón de Cerrar Modal -->
                <button type="button" onclick="toggleModal(false)" class="absolute top-6 right-6 text-slate-400 hover:text-slate-700 transition text-2xl">
                    <i class="fa-solid fa-xmark"></i>
                </button>

                <!-- Encabezado Socio -->
                <div class="flex items-center gap-4 mb-8">
                    <div class="w-14 h-14 rounded-full bg-[#0B1A30] text-amber-400 font-bold flex items-center justify-center text-xl shadow-md">
                        <asp:Literal ID="litIniciales" runat="server">--</asp:Literal>
                    </div>
                    <div>
                        <p class="text-sm text-slate-500 font-medium">Bienvenido de vuelta</p>
                        <h3 class="text-2xl font-bold text-[#0B1A30]">
                            <asp:Literal ID="litNombreSocio" runat="server">Usuario</asp:Literal> 
                            · <span class="font-normal text-slate-600"><asp:Literal ID="litNumeroSocio" runat="server">Socio #000000</asp:Literal></span>
                        </h3>
                    </div>
                </div>

                <!-- Tarjetas de Saldos -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                    <div class="bg-[#0B1A30] text-white p-6 rounded-xl shadow-lg">
                        <p class="text-sm text-slate-300">Saldo disponible</p>
                        <p class="text-3xl font-bold text-amber-400 my-2"><asp:Literal ID="litSaldo" runat="server">$0.00</asp:Literal></p>
                        <p class="text-xs text-slate-400">Ahorros Principal *4521</p>
                    </div>

                    <div class="border border-slate-200 p-6 rounded-xl bg-white shadow-sm">
                        <p class="text-sm text-slate-500">CDT Activo</p>
                        <p class="text-3xl font-bold text-emerald-600 my-2"><asp:Literal ID="litCDT" runat="server">$0.00</asp:Literal></p>
                        <p class="text-xs text-slate-500">Vence: 12 Feb 2026 · 7.1% EA</p>
                    </div>

                    <div class="border border-slate-200 p-6 rounded-xl bg-white shadow-sm">
                        <p class="text-sm text-slate-500">Préstamo vigente</p>
                        <p class="text-3xl font-bold text-red-600 my-2"><asp:Literal ID="litPrestamo" runat="server">$0.00</asp:Literal></p>
                        <p class="text-xs text-slate-500">Próx. cuota: 30 Oct · $347</p>
                    </div>
                </div>

                <!-- Historial de Movimientos -->
                <h4 class="font-bold text-[#0B1A30] text-lg mb-4">Últimos movimientos</h4>

                <!-- Panel Vacío para Usuarios Nuevos -->
                <asp:Panel ID="pnlSinMovimientos" runat="server" Visible="false" CssClass="bg-slate-50 border border-dashed border-slate-300 rounded-xl p-8 text-center my-4">
                    <i class="fa-solid fa-receipt text-3xl text-slate-400 mb-2"></i>
                    <p class="text-slate-600 font-semibold text-base">Aún no cuentas con movimientos registrados.</p>
                    <p class="text-xs text-slate-400 mt-1">Tus depósitos, transferencias y pagos aparecerán reflejados aquí automáticamente.</p>
                </asp:Panel>

                <!-- Tabla Dinámica con Historial -->
                <div class="overflow-x-auto mb-8">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="text-xs text-slate-500 border-b border-slate-200 uppercase tracking-wider">
                                <th class="py-3 font-semibold w-28">Fecha</th>
                                <th class="py-3 font-semibold">Descripción</th>
                                <th class="py-3 font-semibold text-right w-32">Monto</th>
                                <th class="py-3 font-semibold text-right w-32">Saldo</th>
                                <th class="py-3 font-semibold text-center w-32">Estado</th>
                            </tr>
                        </thead>
                        <tbody class="text-sm text-slate-700">
                            <asp:Repeater ID="rptMovimientos" runat="server">
                                <ItemTemplate>
                                    <tr class="border-b border-slate-100 hover:bg-slate-50 transition">
                                        <td class="py-4"><%# Eval("Fecha") %></td>
                                        <td class="py-4"><%# Eval("Descripcion") %></td>
                                        <td class="py-4 text-right font-semibold <%# Convert.ToBoolean(Eval("EsPositivo")) ? "text-emerald-600" : "text-slate-900" %>"><%# Eval("MontoFormatted") %></td>
                                        <td class="py-4 text-right"><%# Eval("SaldoFormatted") %></td>
                                        <td class="py-4 text-center">
                                            <span class="<%# Eval("Estado").ToString() == "Completado" ? "bg-emerald-50 text-emerald-600 border-emerald-200" : "bg-amber-50 text-amber-600 border-amber-200" %> text-[11px] font-bold px-3 py-1 rounded-full border flex items-center justify-center gap-1.5 w-max mx-auto">
                                                <span class="w-1.5 h-1.5 rounded-full <%# Eval("Estado").ToString() == "Completado" ? "bg-emerald-500" : "bg-amber-500" %>"></span> <%# Eval("Estado") %>
                                            </span>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>

                <div class="flex justify-start">
                    <button type="button" class="bg-[#1A7F54] hover:bg-emerald-700 text-white font-bold py-3 px-6 rounded-lg text-sm transition flex items-center justify-center gap-2 shadow-lg shadow-emerald-900/20">
                        <i class="fa-solid fa-file-lines"></i> Descargar Estado de Cuenta Completo
                    </button>
                </div>
            </div>
        </div>

    </form>

    <script type="text/javascript">
        function toggleModal(show) {
            var modal = document.getElementById('modalPortalSocio');
            if (show) {
                modal.classList.remove('hidden');
            } else {
                modal.classList.add('hidden');
            }
        }
    </script>
</body>
</html>