<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Transparencia.aspx.cs" Inherits="CoopFacil.Pages.Transparencia" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Transparencia - CoopFacil</title>
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
                    <a href="Servicios.aspx" class="text-slate-300 hover:text-emerald-400 transition">Servicios</a>
                    <a href="Transparencia.aspx" class="text-emerald-400 font-bold border-b-2 border-emerald-400 pb-1">Transparencia</a>
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
                
                <!-- SECCIÓN SUPERIOR: TÍTULO E INFORMACIÓN FINANCIERA (KPIs) -->
                <section class="flex flex-col gap-6">
                    <div>
                        <span class="text-xs font-bold uppercase tracking-wider text-emerald-400 flex items-center gap-2 mb-2">
                            <span class="w-4 h-[2px] bg-emerald-400 inline-block"></span> GOBERNANZA Y RENDICIÓN DE CUENTAS
                        </span>
                        <h1 class="text-3xl sm:text-4xl font-extrabold text-white tracking-tight mb-3">
                            Transparencia total
                        </h1>
                        <p class="text-sm sm:text-base text-slate-300 leading-relaxed max-w-3xl">
                            Como cooperativa, estamos obligados con nuestros socios a rendir cuentas públicamente. Aquí encontrará toda la información financiera, legal y de gobernanza de CoopFacil.
                        </p>
                    </div>

                    <!-- TARJETAS DE INFORMACIÓN FINANCIERA -->
                    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                        
                        <div class="bg-[#0F233D] border border-slate-700/80 border-t-2 border-t-emerald-500 rounded-xl p-6 text-center shadow-xl hover:border-emerald-500/50 transition">
                            <p class="text-3xl font-extrabold text-white">AA+</p>
                            <p class="text-xs font-medium text-slate-400 mt-2">Calificación Fitch Ratings</p>
                        </div>

                        <div class="bg-[#0F233D] border border-slate-700/80 border-t-2 border-t-emerald-500 rounded-xl p-6 text-center shadow-xl hover:border-emerald-500/50 transition">
                            <p class="text-3xl font-extrabold text-white">18.4%</p>
                            <p class="text-xs font-medium text-slate-400 mt-2">Índice de Solvencia BIS</p>
                        </div>

                        <div class="bg-[#0F233D] border border-slate-700/80 border-t-2 border-t-emerald-500 rounded-xl p-6 text-center shadow-xl hover:border-emerald-500/50 transition">
                            <p class="text-3xl font-extrabold text-white">97.8%</p>
                            <p class="text-xs font-medium text-slate-400 mt-2">Cartera Crediticia Sana</p>
                        </div>

                        <div class="bg-[#0F233D] border border-slate-700/80 border-t-2 border-t-emerald-500 rounded-xl p-6 text-center shadow-xl hover:border-emerald-500/50 transition">
                            <p class="text-3xl font-extrabold text-white">$46M</p>
                            <p class="text-xs font-medium text-slate-400 mt-2">Patrimonio Cooperativo</p>
                        </div>

                    </div>
                </section>

                <!-- SECCIÓN EN DOS COLUMNAS: DOCUMENTOS OFICIALES Y ÓRGANOS DE GOBIERNO -->
                <section class="grid grid-cols-1 lg:grid-cols-2 gap-8 items-start">
                    
                    <!-- COLUMNA IZQUIERDA: DOCUMENTOS OFICIALES -->
                    <div class="flex flex-col gap-4">
                        <h2 class="text-xl font-bold text-white flex items-center gap-2">
                            <i class="fa-solid fa-folder-open text-emerald-400 text-base"></i> Documentos Oficiales
                        </h2>

                        <div class="flex flex-col gap-3">
                            
                            <!-- Documento 1 -->
                            <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 flex items-center justify-between gap-4 shadow-lg hover:border-emerald-500/60 transition group">
                                <div class="flex items-center gap-3.5">
                                    <div class="w-10 h-10 rounded-lg bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-400 flex-shrink-0">
                                        <i class="fa-solid fa-chart-column text-lg"></i>
                                    </div>
                                    <div>
                                        <h3 class="text-sm font-bold text-white group-hover:text-emerald-400 transition">
                                            Estados Financieros Auditados 2024
                                        </h3>
                                        <p class="text-xs text-slate-400 font-medium mt-0.5">
                                            Auditor: Deloitte · Aprobados: Asamblea General Mar 2025
                                        </p>
                                    </div>
                                </div>
                                <a href="Documentos/Estados Financieros Auditados 2024.pdf" download="Estados_Financieros_Auditados_2024.pdf" target="_blank" class="text-xs font-bold text-emerald-400 hover:text-white bg-emerald-950/60 hover:bg-emerald-600 border border-emerald-500/40 px-3.5 py-2 rounded-lg transition flex items-center gap-1.5 flex-shrink-0">
                                    PDF <i class="fa-solid fa-arrow-down text-[10px]"></i>
                                </a>
                            </div>

                            <!-- Documento 2 -->
                            <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 flex items-center justify-between gap-4 shadow-lg hover:border-emerald-500/60 transition group">
                                <div class="flex items-center gap-3.5">
                                    <div class="w-10 h-10 rounded-lg bg-amber-500/10 border border-amber-500/20 flex items-center justify-center text-amber-400 flex-shrink-0">
                                        <i class="fa-solid fa-file-lines text-lg"></i>
                                    </div>
                                    <div>
                                        <h3 class="text-sm font-bold text-white group-hover:text-emerald-400 transition">
                                            Informe de Gestión 2024
                                        </h3>
                                        <p class="text-xs text-slate-400 font-medium mt-0.5">
                                            Consejo de Administración · 148 páginas
                                        </p>
                                    </div>
                                </div>
                                <a href="Documentos/Informe de Gestion 2024.pdf" download="Informe_de_Gestion_2024.pdf" target="_blank" class="text-xs font-bold text-emerald-400 hover:text-white bg-emerald-950/60 hover:bg-emerald-600 border border-emerald-500/40 px-3.5 py-2 rounded-lg transition flex items-center gap-1.5 flex-shrink-0">
                                    PDF <i class="fa-solid fa-arrow-down text-[10px]"></i>
                                </a>
                            </div>

                            <!-- Documento 3 -->
                            <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 flex items-center justify-between gap-4 shadow-lg hover:border-emerald-500/60 transition group">
                                <div class="flex items-center gap-3.5">
                                    <div class="w-10 h-10 rounded-lg bg-amber-500/10 border border-amber-500/20 flex items-center justify-center text-amber-400 flex-shrink-0">
                                        <i class="fa-solid fa-scale-balanced text-lg"></i>
                                    </div>
                                    <div>
                                        <h3 class="text-sm font-bold text-white group-hover:text-emerald-400 transition">
                                            Estatuto Cooperativo Vigente
                                        </h3>
                                        <p class="text-xs text-slate-400 font-medium mt-0.5">
                                            Última reforma: Asamblea Extraordinaria Nov 2023
                                        </p>
                                    </div>
                                </div>
                                <a href="Documentos/Estatuto Cooperativo Vigente.pdf" download="Estatuto_Cooperativo_Vigente.pdf" target="_blank" class="text-xs font-bold text-emerald-400 hover:text-white bg-emerald-950/60 hover:bg-emerald-600 border border-emerald-500/40 px-3.5 py-2 rounded-lg transition flex items-center gap-1.5 flex-shrink-0">
                                    PDF <i class="fa-solid fa-arrow-down text-[10px]"></i>
                                </a>
                            </div>

                            <!-- Documento 4 -->
                            <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 flex items-center justify-between gap-4 shadow-lg hover:border-emerald-500/60 transition group">
                                <div class="flex items-center gap-3.5">
                                    <div class="w-10 h-10 rounded-lg bg-red-500/10 border border-red-500/20 flex items-center justify-center text-red-400 flex-shrink-0">
                                        <i class="fa-solid fa-file-pdf text-lg"></i>
                                    </div>
                                    <div>
                                        <h3 class="text-sm font-bold text-white group-hover:text-emerald-400 transition">
                                            Acta Asamblea General 2025
                                        </h3>
                                        <p class="text-xs text-slate-400 font-medium mt-0.5">
                                            Celebrada el 15 de marzo de 2025 · Quórum: 82%
                                        </p>
                                    </div>
                                </div>
                                <a href="Documentos/Acta Asamblea General 2025.pdf" download="Acta_Asamblea_General_2025.pdf" target="_blank" class="text-xs font-bold text-emerald-400 hover:text-white bg-emerald-950/60 hover:bg-emerald-600 border border-emerald-500/40 px-3.5 py-2 rounded-lg transition flex items-center gap-1.5 flex-shrink-0">
                                    PDF <i class="fa-solid fa-arrow-down text-[10px]"></i>
                                </a>
                            </div>

                            <!-- Documento 5 -->
                            <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 flex items-center justify-between gap-4 shadow-lg hover:border-emerald-500/60 transition group">
                                <div class="flex items-center gap-3.5">
                                    <div class="w-10 h-10 rounded-lg bg-blue-500/10 border border-blue-500/20 flex items-center justify-center text-blue-400 flex-shrink-0">
                                        <i class="fa-solid fa-shield-halved text-lg"></i>
                                    </div>
                                    <div>
                                        <h3 class="text-sm font-bold text-white group-hover:text-emerald-400 transition">
                                            Política SARLAFT / Prevención LA
                                        </h3>
                                        <p class="text-xs text-slate-400 font-medium mt-0.5">
                                            Sistema Anti-Lavado · Vigente 2025
                                        </p>
                                    </div>
                                </div>
                                <a href="Documentos/Politica SARLAFT Prevencion LAFT.pdf" download="Politica_SARLAFT_Prevencion_LAFT.pdf" target="_blank" class="text-xs font-bold text-emerald-400 hover:text-white bg-emerald-950/60 hover:bg-emerald-600 border border-emerald-500/40 px-3.5 py-2 rounded-lg transition flex items-center gap-1.5 flex-shrink-0">
                                    PDF <i class="fa-solid fa-arrow-down text-[10px]"></i>
                                </a>
                            </div>

                        </div>
                    </div>

                    <!-- COLUMNA DERECHA: ÓRGANOS DE GOBIERNO -->
                    <div class="flex flex-col gap-4">
                        <h2 class="text-xl font-bold text-white flex items-center gap-2">
                            <i class="fa-solid fa-sitemap text-emerald-400 text-base"></i> Comité Cooperativo
                        </h2>

                        <div class="flex flex-col gap-3">
                            
                            <!-- Órgano 1 -->
                            <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 shadow-lg hover:border-slate-600 transition">
                                <span class="text-[11px] font-bold text-emerald-400 tracking-wider uppercase block">
                                    PRESIDENTE DEL CONSEJO DE ADMINISTRACIÓN
                                </span>
                                <h3 class="text-sm font-bold text-white mt-1">
                                    Ing. Leonardo Daniel Vasquez Monge
                                </h3>
                                <p class="text-xs text-slate-400 font-medium mt-0.5">
                                    Período 2024 – 2026 · Elegido por el Comité Cooperativo
                                </p>
                            </div>

                            <!-- Órgano 2 -->
                            <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 shadow-lg hover:border-slate-600 transition">
                                <span class="text-[11px] font-bold text-emerald-400 tracking-wider uppercase block">
                                    VICEPRESIDENTE DEL CONSEJO DE ADMINISTRACIÓN
                                </span>
                                <h3 class="text-sm font-bold text-white mt-1">
                                    Dr. Ian Andre Reyes Ortiz
                                </h3>
                                <p class="text-xs text-slate-400 font-medium mt-0.5">
                                    Período 2024 – 2026 · Máster en Gestión Cooperativa
                                </p>
                            </div>

                            <!-- Órgano 3 -->
                            <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 shadow-lg hover:border-slate-600 transition">
                                <span class="text-[11px] font-bold text-emerald-400 tracking-wider uppercase block">
                                    GERENTE GENERAL
                                </span>
                                <h3 class="text-sm font-bold text-white mt-1">
                                    Ing. Francisco Javier Alvarenga Navarro
                                </h3>
                                <p class="text-xs text-slate-400 font-medium mt-0.5">
                                    Desde 2019 · Economista Financiero
                                </p>
                            </div>

                            <!-- Órgano 4 -->
                            <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 shadow-lg hover:border-slate-600 transition">
                                <span class="text-[11px] font-bold text-emerald-400 tracking-wider uppercase block">
                                    PRESIDENTE DE LA JUNTA DE VIGILANCIA
                                </span>
                                <h3 class="text-sm font-bold text-white mt-1">
                                    Lic. Mario Jose Nuñez Clara
                                </h3>
                                <p class="text-xs text-slate-400 font-medium mt-0.5">
                                    Período 2024 – 2026 · Contador Público Certificado
                                </p>
                            </div>

                            <!-- Órgano 5 -->
                            <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 shadow-lg hover:border-slate-600 transition">
                                <span class="text-[11px] font-bold text-emerald-400 tracking-wider uppercase block">
                                    PRESIDENTE DEL COMITÉ DE CRÉDITO
                                </span>
                                <h3 class="text-sm font-bold text-white mt-1">
                                    Lic. Emerson Edenilson Alas Escobar
                                </h3>
                                <p class="text-xs text-slate-400 font-medium mt-0.5">
                                    Período 2024 – 2026 · Especialista en Riesgo Crediticio
                                </p>
                            </div>

                            <!-- Órgano 6 -->
                            <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 shadow-lg hover:border-slate-600 transition">
                                <span class="text-[11px] font-bold text-emerald-400 tracking-wider uppercase block">
                                    PRESIDENTE DEL COMITÉ DE EDUCACIÓN
                                </span>
                                <h3 class="text-sm font-bold text-white mt-1">
                                    Dr. Leonel Mariano Clavel Ramirez
                                </h3>
                                <p class="text-xs text-slate-400 font-medium mt-0.5">
                                    Período 2024 – 2026 · Pedagogo y Economista
                                </p>
                            </div>

                            <!-- Órgano 7 -->
                            <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 shadow-lg hover:border-slate-600 transition">
                                <span class="text-[11px] font-bold text-emerald-400 tracking-wider uppercase block">
                                    SECRETARIO DEL CONSEJO DE ADMINISTRACIÓN
                                </span>
                                <h3 class="text-sm font-bold text-white mt-1">
                                    Lic. Raul Fernando Escobar Nuñez
                                </h3>
                                <p class="text-xs text-slate-400 font-medium mt-0.5">
                                    Período 2025 – 2027 · Abogado y Notario
                                </p>
                            </div>

                            <!-- Órgano 8 -->
                            <div class="bg-[#0F233D] border border-slate-700/80 rounded-xl p-4 shadow-lg hover:border-slate-600 transition">
                                <span class="text-[11px] font-bold text-emerald-400 tracking-wider uppercase block">
                                    TESORERA DEL COMITÉ DE RIESGOS
                                </span>
                                <h3 class="text-sm font-bold text-white mt-1">
                                    Licda. Samantha Nicole Velasquez Berrios
                                </h3>
                                <p class="text-xs text-slate-400 font-medium mt-0.5">
                                    Período 2025 – 2027 · Especialista en Finanzas Internacionales
                                </p>
                            </div>

                        </div>
                    </div>

                </section>

            </main>
        </div>

        <!-- PIE DE PÁGINA -->
        <footer class="bg-[#0F233D] border-t border-slate-800 text-slate-400 text-xs text-center py-6 mt-auto">
            <p>© 2026 CoopFacil. Todos los derechos reservados.</p>
        </footer>

    </form>
</body>
</html>