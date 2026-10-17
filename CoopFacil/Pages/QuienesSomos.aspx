<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuienesSomos.aspx.cs" Inherits="CoopFacil.Pages.QuienesSomos" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quiénes Somos - CoopFacil</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="bg-[#0B1A30] text-white font-sans antialiased min-h-screen flex flex-col justify-between">
    <form id="form1" runat="server" class="min-h-screen flex flex-col">
        
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
                <a href="QuienesSomos.aspx" class="text-emerald-400 font-bold border-b-2 border-emerald-400 pb-1">Quiénes Somos</a>
                <a href="Servicios.aspx" class="text-slate-300 hover:text-emerald-400 transition">Servicios</a>
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
                <asp:LinkButton ID="btnPortalSocio" runat="server" OnClick="btnPortalSocio_Click" CssClass="bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs sm:text-sm px-5 py-2.5 rounded-lg transition flex items-center gap-2 shadow-lg shadow-emerald-900/40">
                    <i class="fa-solid fa-user-check"></i> Portal Socio
                </asp:LinkButton>

                <asp:LinkButton ID="btnCerrarSesion" runat="server" OnClick="btnCerrarSesion_Click" CssClass="bg-[#0F233D] hover:bg-slate-700 border border-slate-600 text-white font-bold text-xs sm:text-sm px-4 py-2.5 rounded-lg transition flex items-center gap-2">
                    <i class="fa-solid fa-right-from-bracket"></i> Cerrar Sesión
                </asp:LinkButton>
            </div>

        </header>

        <!-- CONTENIDO PRINCIPAL -->
        <main class="max-w-7xl mx-auto px-6 py-10 flex flex-col gap-10 flex-grow w-full">
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                
                <!-- COLUMNA IZQUIERDA -->
                <div class="lg:col-span-7 flex flex-col gap-8">
                    <div class="bg-[#0F233D] border border-slate-700/80 rounded-2xl p-8 shadow-xl flex flex-col gap-4">
                        <span class="text-xs font-bold uppercase tracking-wider text-emerald-400 flex items-center gap-2">
                            <span class="w-4 h-[2px] bg-emerald-400 inline-block"></span> IDENTIDAD COOPERATIVA
                        </span>
                        <h1 class="text-3xl sm:text-4xl font-extrabold text-white tracking-tight leading-tight">
                            Somos más que una institución financiera
                        </h1>
                        <p class="text-sm sm:text-base text-slate-300 leading-relaxed">
                            Nacimos en 1987 de la unión de 47 familias trabajadoras con una convicción: que el acceso al crédito justo y al ahorro seguro no debería ser privilegio de pocos. Hoy, con más de 8,400 socios, seguimos siendo fieles a ese principio fundacional.
                        </p>
                    </div>

                    <!-- MISIÓN Y VISIÓN -->
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                        <div class="bg-[#0F233D] border border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-3">
                            <div class="w-10 h-10 rounded-xl bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-400 text-lg">
                                <i class="fa-solid fa-bullseye"></i>
                            </div>
                            <h3 class="text-lg font-bold text-white">Nuestra Misión</h3>
                            <p class="text-xs text-slate-300 leading-relaxed">
                                Impulsar el desarrollo socioeconómico integral de nuestros socios mediante soluciones financieras inclusivas, transparentes y competitivas de ahorro, crédito e inversión.
                            </p>
                        </div>

                        <div class="bg-[#0F233D] border border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-3">
                            <div class="w-10 h-10 rounded-xl bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-400 text-lg">
                                <i class="fa-solid fa-eye"></i>
                            </div>
                            <h3 class="text-lg font-bold text-white">Nuestra Visión</h3>
                            <p class="text-xs text-slate-300 leading-relaxed">
                                Ser la cooperativa financiera referente por su solidez, innovación en servicios digitales y capacidad de transformar vidas con un modelo autosostenible.
                            </p>
                        </div>
                    </div>

                    <!-- ALCANCES E IMPACTO -->
                    <div class="bg-[#0F233D] border border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-6">
                        <div class="flex items-center gap-3 border-b border-slate-800 pb-4">
                            <div class="w-10 h-10 rounded-xl bg-amber-500/10 border border-amber-500/20 flex items-center justify-center text-amber-400 text-lg">
                                <i class="fa-solid fa-chart-line"></i>
                            </div>
                            <div>
                                <h3 class="text-lg font-bold text-white">Alcances e Impacto</h3>
                                <p class="text-xs text-slate-400">Compromiso real con nuestra comunidad</p>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                            <div class="flex items-start gap-3">
                                <div class="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center text-emerald-400 flex-shrink-0 mt-0.5">
                                    <i class="fa-solid fa-building-columns text-sm"></i>
                                </div>
                                <div>
                                    <h4 class="text-sm font-bold text-white">Cobertura Territorial</h4>
                                    <p class="text-xs text-slate-400 mt-1">Presencia activa en 8 departamentos con 12 oficinas físicas.</p>
                                </div>
                            </div>

                            <div class="flex items-start gap-3">
                                <div class="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center text-emerald-400 flex-shrink-0 mt-0.5">
                                    <i class="fa-solid fa-code text-sm"></i>
                                </div>
                                <div>
                                    <h4 class="text-sm font-bold text-white">Innovación Digital</h4>
                                    <p class="text-xs text-slate-400 mt-1">Portal Socio en tiempo real para consultas y gestión 24/7.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- COLUMNA DERECHA -->
                <div class="lg:col-span-5 flex flex-col gap-6">
                    <div class="bg-[#0F233D] border border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-2">
                        <span class="text-xs font-bold uppercase tracking-wider text-slate-400">ACTIVOS TOTALES</span>
                        <div class="text-4xl font-extrabold text-blue-400">$100M</div>
                        <span class="text-xs text-emerald-400 font-semibold flex items-center gap-1">
                            <i class="fa-solid fa-arrow-up"></i> 14.2% vs año anterior
                        </span>
                    </div>

                    <div class="bg-[#0F233D] border border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-2">
                        <span class="text-xs font-bold uppercase tracking-wider text-slate-400">SOLVENCIA</span>
                        <div class="text-4xl font-extrabold text-blue-400">18.4%</div>
                        <span class="text-xs text-slate-400">Índice BIS (mín. legal 8%)</span>
                    </div>

                    <div class="bg-[#0F233D] border border-slate-700/80 rounded-2xl p-6 shadow-xl flex flex-col gap-2">
                        <span class="text-xs font-bold uppercase tracking-wider text-slate-400">CALIFICACIÓN DE RIESGO</span>
                        <div class="text-4xl font-extrabold text-emerald-400">AA+</div>
                        <span class="text-xs text-slate-400">Fitch Ratings · Perspectiva Estable</span>
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div class="bg-[#0F233D] border border-slate-700/80 rounded-2xl p-5 shadow-xl flex flex-col gap-1">
                            <span class="text-[11px] font-bold uppercase tracking-wider text-slate-400">CARTERA SANA</span>
                            <div class="text-2xl font-extrabold text-emerald-400">97.8%</div>
                            <span class="text-[11px] text-slate-400">Morosidad 2.2%</span>
                        </div>

                        <div class="bg-[#0F233D] border border-slate-700/80 rounded-2xl p-5 shadow-xl flex flex-col gap-1">
                            <span class="text-[11px] font-bold uppercase tracking-wider text-slate-400">OFICINAS</span>
                            <div class="text-2xl font-extrabold text-blue-400">3</div>
                            <span class="text-[11px] text-slate-400">En 1 departamento</span>
                        </div>
                    </div>
                </div>

            </div>
        </main>

    </form>
</body>
</html>