<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Contacto.aspx.cs" Inherits="CoopFacil.Pages.Contacto" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Contacto - CoopFacil</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="bg-[#0B1A30] text-white font-sans antialiased min-h-screen flex flex-col justify-between">
    <form id="form1" runat="server" class="min-h-screen flex flex-col justify-between">
        
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
                <a href="Servicios.aspx" class="text-slate-300 hover:text-emerald-400 transition">Servicios</a>
                <a href="Transparencia.aspx" class="text-slate-300 hover:text-emerald-400 transition">Transparencia</a>
                <a href="Contacto.aspx" class="text-emerald-400 font-bold border-b-2 border-emerald-400 pb-1">Contacto</a>
            </nav>

            <!-- CONTROLES DE SESIÓN (DERECHA) -->
            <div class="flex items-center gap-3">
                <!-- BOTÓN CUANDO NO HAY SESIÓN -->
                <asp:HyperLink ID="lnkIniciarSesion" runat="server" NavigateUrl="../Default.aspx" CssClass="bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs sm:text-sm px-5 py-2.5 rounded-lg transition flex items-center gap-2 shadow-lg shadow-blue-900/40">
                    <i class="fa-solid fa-right-to-bracket"></i> Iniciar Sesión
                </asp:HyperLink>

                <!-- BOTONES CUANDO HAY SESIÓN ACTIVA -->
                <asp:LinkButton ID="btnPortalSocio" runat="server" OnClick="btnPortalSocio_Click" CssClass="bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs sm:text-sm px-5 py-2.5 rounded-lg transition flex items-center gap-2 shadow-lg shadow-emerald-900/40">
                    <i class="fa-solid fa-user-check"></i> Portal Socio
                </asp:LinkButton>

                <asp:LinkButton ID="btnCerrarSesion" runat="server" OnClick="btnCerrarSesion_Click" CssClass="bg-[#0F233D] hover:bg-slate-700 border border-slate-600 text-white font-bold text-xs sm:text-sm px-4 py-2.5 rounded-lg transition flex items-center gap-2">
                    <i class="fa-solid fa-right-from-bracket"></i> Cerrar Sesión
                </asp:LinkButton>
            </div>

        </header>

        <!-- CONTENIDO PRINCIPAL: CONTACTO -->
        <main class="max-w-7xl mx-auto px-6 sm:px-10 py-12 flex-grow w-full flex items-center">
            
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 lg:gap-12 w-full items-start">
                
                <!-- COLUMNA IZQUIERDA: INFORMACIÓN DE CONTACTO -->
                <div class="lg:col-span-5 flex flex-col justify-center">
                    
                    <span class="text-xs font-bold uppercase tracking-wider text-emerald-400 flex items-center gap-2 mb-3">
                        <span class="w-5 h-[2px] bg-emerald-400 inline-block"></span> ESTAMOS PARA SERVIRLE
                    </span>

                    <h1 class="text-3xl sm:text-4xl lg:text-5xl font-extrabold text-white tracking-tight leading-tight mb-4">
                        Atención personalizada cuando la necesite
                    </h1>

                    <p class="text-slate-300 text-sm sm:text-base leading-relaxed mb-8">
                        Nuestro equipo de asesores especializados está disponible por múltiples canales para resolver sus dudas, gestionar sus solicitudes y acompañarle en sus decisiones financieras.
                    </p>

                    <!-- TARJETAS DE CANALES DE ATENCIÓN CON COLORIMETRÍA UNIFICADA -->
                    <div class="flex flex-col gap-3.5">
                        
                        <!-- Canal 1: Teléfono -->
                        <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 flex items-center gap-4 shadow-lg hover:border-emerald-500/50 transition">
                            <div class="w-10 h-10 rounded-lg bg-emerald-600/20 border border-emerald-500/30 flex items-center justify-center text-emerald-400 flex-shrink-0">
                                <i class="fa-solid fa-phone"></i>
                            </div>
                            <div class="flex flex-col">
                                <span class="text-[11px] font-semibold text-slate-400 leading-none mb-1">
                                    Centro de Atención Telefónica
                                </span>
                                <span class="text-sm font-bold text-white tracking-wide">
                                    1800-COOP-UNIDA (2667-8643)
                                </span>
                            </div>
                        </div>

                        <!-- Canal 2: WhatsApp -->
                        <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 flex items-center gap-4 shadow-lg hover:border-emerald-500/50 transition">
                            <div class="w-10 h-10 rounded-lg bg-emerald-600/20 border border-emerald-500/30 flex items-center justify-center text-emerald-400 flex-shrink-0">
                                <i class="fa-brands fa-whatsapp text-lg"></i>
                            </div>
                            <div class="flex flex-col">
                                <span class="text-[11px] font-semibold text-slate-400 leading-none mb-1">
                                    Contacto en linea (24/7)
                                </span>
                                <span class="text-sm font-bold text-white tracking-wide">
                                    +502 5555-1234
                                </span>
                            </div>
                        </div>

                        <!-- Canal 3: Correo Electrónico -->
                        <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 flex items-center gap-4 shadow-lg hover:border-emerald-500/50 transition">
                            <div class="w-10 h-10 rounded-lg bg-emerald-600/20 border border-emerald-500/30 flex items-center justify-center text-emerald-400 flex-shrink-0">
                                <i class="fa-solid fa-envelope"></i>
                            </div>
                            <div class="flex flex-col">
                                <span class="text-[11px] font-semibold text-slate-400 leading-none mb-1">
                                    Correo Electrónico
                                </span>
                                <span class="text-sm font-bold text-white tracking-wide">
                                    atencion.coopfacil@gmail.com
                                </span>
                            </div>
                        </div>

                        <!-- Canal 4: Sede Central -->
                        <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 flex items-center gap-4 shadow-lg hover:border-emerald-500/50 transition">
                            <div class="w-10 h-10 rounded-lg bg-emerald-600/20 border border-emerald-500/30 flex items-center justify-center text-emerald-400 flex-shrink-0">
                                <i class="fa-solid fa-location-dot"></i>
                            </div>
                            <div class="flex flex-col">
                                <span class="text-[11px] font-semibold text-slate-400 leading-none mb-1">
                                    Sede Central
                                </span>
                                <span class="text-xs sm:text-sm font-bold text-white leading-tight">
                                    57 Avenida Norte y Av. Roosevelt, San Salvador - Lun-Vie 8am-6pm
                                </span>
                            </div>
                        </div>

                    </div>

                </div>

                <!-- COLUMNA DERECHA: FORMULARIO DE CONTACTO -->
                <div class="lg:col-span-7 bg-[#0F233D] border border-slate-700/80 rounded-2xl p-6 sm:p-8 shadow-2xl">
                    
                    <h2 class="text-xl sm:text-2xl font-bold text-white mb-1">
                        Envíenos un mensaje
                    </h2>
                    <p class="text-xs sm:text-sm text-slate-400 mb-6">
                        Respuesta garantizada en menos de 4 horas hábiles
                    </p>

                    <!-- ALERTA DE ÉXITO -->
                    <asp:Panel ID="pnlMensajeExito" runat="server" Visible="false" CssClass="mb-5 p-4 bg-emerald-500/20 border border-emerald-500/40 rounded-xl flex items-center gap-3 text-emerald-300 text-xs sm:text-sm font-medium">
                        <i class="fa-solid fa-circle-check text-lg text-emerald-400"></i>
                        <span>¡Gracias por contactarnos! Su mensaje ha sido enviado correctamente. Nos comunicaremos pronto.</span>
                    </asp:Panel>

                    <div class="flex flex-col gap-5">
                        
                        <!-- Campo: Nombre Completo -->
                        <div>
                            <label class="block text-xs font-semibold text-slate-300 mb-1.5">Nombre completo</label>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="w-full bg-[#0B1A30] border border-slate-700/90 rounded-lg px-4 py-3 text-sm text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" Placeholder="Su nombre"></asp:TextBox>
                        </div>

                        <!-- Fila doble: Correo Electrónico y Teléfono -->
                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                            <div>
                                <label class="block text-xs font-semibold text-slate-300 mb-1.5">Correo electrónico</label>
                                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="w-full bg-[#0B1A30] border border-slate-700/90 rounded-lg px-4 py-3 text-sm text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" Placeholder="correo@ejemplo.com"></asp:TextBox>
                            </div>
                            <div>
                                <label class="block text-xs font-semibold text-slate-300 mb-1.5">Teléfono</label>
                                <asp:TextBox ID="txtTelefono" runat="server" CssClass="w-full bg-[#0B1A30] border border-slate-700/90 rounded-lg px-4 py-3 text-sm text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition" Placeholder="+502 ____-____"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Campo: Tipo de consulta -->
                        <div>
                            <label class="block text-xs font-semibold text-slate-300 mb-1.5">Tipo de consulta</label>
                            <div class="relative">
                                <asp:DropDownList ID="ddlTipoConsulta" runat="server" CssClass="w-full bg-[#0B1A30] border border-slate-700/90 rounded-lg px-4 py-3 text-sm text-white focus:outline-none focus:border-emerald-500 transition appearance-none cursor-pointer pr-10">
                                    <asp:ListItem Value="servicios">Consulta sobre servicios</asp:ListItem>
                                    <asp:ListItem Value="creditos">Solicitud de créditos o préstamos</asp:ListItem>
                                    <asp:ListItem Value="ahorros">Cuentas de ahorro e inversión</asp:ListItem>
                                    <asp:ListItem Value="soporte">Soporte del Portal Socio</asp:ListItem>
                                    <asp:ListItem Value="otros">Otros asuntos</asp:ListItem>
                                </asp:DropDownList>
                                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-3 text-slate-400">
                                    <i class="fa-solid fa-chevron-down text-xs"></i>
                                </div>
                            </div>
                        </div>

                        <!-- Campo: Mensaje -->
                        <div>
                            <label class="block text-xs font-semibold text-slate-300 mb-1.5">Mensaje</label>
                            <asp:TextBox ID="txtMensaje" runat="server" TextMode="MultiLine" Rows="5" CssClass="w-full bg-[#0B1A30] border border-slate-700/90 rounded-lg p-4 text-sm text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 transition resize-y" Placeholder="Describa su consulta con el mayor detalle posible..."></asp:TextBox>
                        </div>

                        <!-- Botón Enviar Mensaje (Verde Esmeralda Corporativo) -->
                        <div class="pt-1">
                            <asp:Button ID="btnEnviarMensaje" runat="server" Text="Enviar Mensaje →" OnClick="btnEnviarMensaje_Click" CssClass="w-full bg-emerald-600 hover:bg-emerald-500 text-white font-bold py-3.5 px-6 rounded-lg transition shadow-lg shadow-emerald-950/50 cursor-pointer text-sm tracking-wide" />
                        </div>

                    </div>

                </div>

            </div>

        </main>

        <!-- FOOTER SIMPLE -->
        <footer class="border-t border-slate-800 py-6 text-center text-xs text-slate-500">
            <p>© <%= DateTime.Now.Year %> CoopFacil R.L. - Todos los derechos reservados.</p>
        </footer>

    </form>
</body>
</html>