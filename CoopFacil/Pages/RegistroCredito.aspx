<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegistroCredito.aspx.cs" Inherits="CoopFacil.Pages.RegistroCredito" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" class="dark">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Apertura de Cuenta de Ahorro - CoopFacil</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: { coop: { darkBg: '#0B1A30', darkCard: '#0F233D', emerald: '#10B981', blue: '#3B82F6' } }
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
            <!-- BARRA DE NAVEGACIÓN -->
            <header class="bg-white/90 dark:bg-[#0B1A30]/95 backdrop-blur-md border-b border-slate-200 dark:border-slate-800 sticky top-0 z-50 w-full px-6 sm:px-10 py-4 flex items-center justify-between gap-4">
                <div class="flex items-center gap-4">
                    <a href="../Index.aspx" class="flex items-center gap-3 group">
                        <div class="w-10 h-10 rounded-xl bg-emerald-500/10 dark:bg-emerald-600/20 border border-emerald-500/30 flex items-center justify-center text-emerald-600 dark:text-emerald-400 text-xl shadow-inner group-hover:scale-105 transition-transform">
                            <i class="fa-solid fa-users-gear"></i>
                        </div>
                        <div class="flex flex-col">
                            <span class="text-xl font-extrabold tracking-tight leading-none text-slate-900 dark:text-white">Coop<span class="text-emerald-600 dark:text-emerald-400">Facil</span></span>
                            <span class="text-[9px] font-bold tracking-widest text-slate-500 dark:text-slate-400 uppercase mt-1">COOPERATIVA FINANCIERA</span>
                        </div>
                    </a>
                </div>
                <nav class="hidden md:flex items-center gap-8 text-sm font-semibold">
                    <a href="../Index.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition pb-1 border-b-2 border-transparent">Inicio</a>
                    <a href="QuienesSomos.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition pb-1 border-b-2 border-transparent">Quiénes Somos</a>
                    <a href="Servicios.aspx" class="text-emerald-600 dark:text-emerald-400 font-bold border-b-2 border-emerald-600 dark:border-emerald-400 pb-1">Servicios</a>
                    <a href="Transparencia.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition pb-1 border-b-2 border-transparent">Transparencia</a>
                    <a href="Contacto.aspx" class="text-slate-600 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400 transition pb-1 border-b-2 border-transparent">Contacto</a>
                </nav>
            </header>

            <!-- FORMULARIO DE REGISTRO DE CUENTA -->
            <main class="max-w-2xl mx-auto px-6 py-12 flex flex-col gap-6">
                <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-800 rounded-3xl p-8 shadow-xl">
                    <div class="flex items-center gap-3 mb-6 border-b border-slate-200 dark:border-slate-800 pb-4">
                        <div class="w-12 h-12 rounded-2xl bg-emerald-500/20 text-emerald-600 dark:text-emerald-400 flex items-center justify-center text-2xl">
                            <i class="fa-solid fa-user-plus"></i>
                        </div>
                        <div>
                            <span class="text-xs font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-widest block">REQUISITO DE DESEMBOLSO</span>
                            <h1 class="text-2xl font-black text-slate-900 dark:text-white">Apertura de Cuenta de Ahorro</h1>
                        </div>
                    </div>

                    <p class="text-xs text-slate-600 dark:text-slate-300 mb-6">
                        Para vincular y desembolsar los fondos de tus créditos aprobados, completa tus datos personales.
                    </p>

                    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="mb-4 p-4 rounded-xl bg-red-500/10 border border-red-500/40 text-red-600 dark:text-red-400 text-xs font-bold flex items-center gap-2">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <asp:Literal ID="litError" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Nombres <span class="text-emerald-500">*</span></label>
                            <asp:TextBox ID="txtNombres" runat="server" oninput="filtrarLetras(this)" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500" placeholder="Ej. Leonardo"></asp:TextBox>
                        </div>
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Apellidos <span class="text-emerald-500">*</span></label>
                            <asp:TextBox ID="txtApellidos" runat="server" oninput="filtrarLetras(this)" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500" placeholder="Ej. Vásquez"></asp:TextBox>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-700 dark:text-slate-300">DUI <span class="text-emerald-500">*</span></label>
                            <asp:TextBox ID="txtDUI" runat="server" maxlength="10" oninput="formatearDUI(this)" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500" placeholder="00000000-0"></asp:TextBox>
                        </div>
                        <div class="flex flex-col gap-1.5">
                            <label class="text-xs font-bold text-slate-700 dark:text-slate-300">Fecha de Nacimiento <span class="text-emerald-500">*</span></label>
                            <asp:TextBox ID="txtFechaNacimiento" runat="server" TextMode="Date" CssClass="bg-slate-50 dark:bg-[#0B1A30] border border-slate-300 dark:border-slate-700 rounded-xl px-4 py-2.5 text-xs text-slate-900 dark:text-white focus:outline-none focus:border-emerald-500"></asp:TextBox>
                        </div>
                    </div>

                    <asp:Button ID="btnCrearCuenta" runat="server" Text="Crear Cuenta y Ver Desembolso" OnClick="btnCrearCuenta_Click" CssClass="w-full bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-sm py-3.5 rounded-xl shadow-lg transition cursor-pointer" />
                </div>
            </main>
        </div>

        <footer class="bg-white dark:bg-[#0F233D] border-t border-slate-200 dark:border-slate-800 text-slate-500 dark:text-slate-400 text-xs text-center py-6">
            <p>© <%= DateTime.Now.Year %> CoopFacil. Todos los derechos reservados.</p>
        </footer>
    </form>

    <script>
        function filtrarLetras(input) { input.value = input.value.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]/g, ''); }
        function formatearDUI(input) {
            let val = input.value.replace(/\D/g, '');
            if (val.length > 9) val = val.substring(0, 9);
            input.value = val.length > 8 ? val.substring(0, 8) + '-' + val.substring(8, 9) : val;
        }
    </script>
</body>
</html>