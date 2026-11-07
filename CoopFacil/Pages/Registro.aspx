<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="CoopFacil.Pages.Registro" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" class="dark">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Registro de Socio - CoopFacil</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        coop: { darkBg: '#0B1A30', darkCard: '#0F233D', emerald: '#10B981', blue: '#3B82F6' }
                    }
                }
            }
        }
    </script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script>
    (function () {
        const savedTheme = localStorage.getItem('coopfacil-theme');
        if (savedTheme === 'light') { document.documentElement.classList.remove('dark'); }
        else { document.documentElement.classList.add('dark'); }
    })();
</script>
</head>
<body class="bg-slate-50 dark:bg-[#0B1A30] text-slate-800 dark:text-slate-100 font-sans antialiased min-h-screen flex items-center justify-center p-4 transition-colors duration-300 relative">
    
    <!-- BOTÓN CAMBIO DE TEMA EN ESQUINA SUPERIOR DERECHA -->
    <button type="button" onclick="toggleTheme()" id="themeToggleBtn" title="Cambiar Tema" class="absolute top-4 right-4 w-10 h-10 rounded-xl bg-white dark:bg-[#0F233D] border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-amber-400 hover:bg-slate-100 dark:hover:bg-slate-800 transition flex items-center justify-center text-base shadow-sm">
        <i id="themeIconSun" class="fa-solid fa-sun hidden"></i>
        <i id="themeIconMoon" class="fa-solid fa-moon"></i>
    </button>

    <form id="form1" runat="server" autocomplete="off" class="w-full max-w-md">
        
        <div class="bg-white dark:bg-[#0F233D] border border-slate-200 dark:border-slate-700/60 rounded-2xl p-6 sm:p-8 shadow-xl dark:shadow-2xl transition-colors duration-300">
            
            <div class="text-center mb-6">
                <a href="../Default.aspx" class="inline-flex items-center gap-2 mb-2 group">
                    <div class="relative flex items-center justify-center bg-slate-100 dark:bg-[#071322] p-2 rounded-full border border-slate-300 dark:border-slate-700 group-hover:scale-105 transition-transform">
                        <i class="fa-solid fa-user text-lg text-blue-600 dark:text-blue-500"></i>
                        <i class="fa-solid fa-user text-lg text-emerald-600 dark:text-emerald-500 -ml-1"></i>
                    </div>
                    <span class="text-lg font-bold text-slate-900 dark:text-white"><span class="text-blue-600 dark:text-blue-500">Coop</span><span class="text-emerald-600 dark:text-emerald-500">Facil</span></span>
                </a>
                <h2 class="text-xl font-bold text-slate-900 dark:text-white mt-2">Registro de Nuevo Socio</h2>
                <p class="text-xs text-slate-500 dark:text-slate-400 mt-1">Ingresa tus datos para registrarte en la cooperativa</p>
            </div>

            <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="mb-4 p-3 bg-red-100 dark:bg-red-900/50 border border-red-300 dark:border-red-500 rounded-lg text-xs text-red-800 dark:text-red-200 font-medium">
                <asp:Literal ID="litError" runat="server"></asp:Literal>
            </asp:Panel>

            <div class="space-y-4">
                <div>
                    <label class="block text-xs font-medium text-slate-700 dark:text-slate-300 mb-1">Nombre Completo <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                    <asp:TextBox ID="txtNombre" runat="server" oninput="filtrarSoloLetras(this)" CssClass="w-full bg-slate-50 dark:bg-[#071322] border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2.5 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition" placeholder="Ej. Juan Pérez"></asp:TextBox>
                </div>

                <div>
                    <label class="block text-xs font-medium text-slate-700 dark:text-slate-300 mb-1">Correo Electrónico <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="w-full bg-slate-50 dark:bg-[#071322] border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2.5 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition" placeholder="correo@ejemplo.com"></asp:TextBox>
                </div>

                <div>
                    <label class="block text-xs font-medium text-slate-700 dark:text-slate-300 mb-1">Tipo de Acceso <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                    <asp:DropDownList ID="ddlTipoAcceso" runat="server" CssClass="w-full bg-slate-50 dark:bg-[#071322] border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2.5 text-sm text-slate-900 dark:text-white focus:outline-none focus:border-blue-500 transition">
                        <asp:ListItem Value="Socio Individual">Socio Individual</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div>
                    <label class="block text-xs font-medium text-slate-700 dark:text-slate-300 mb-1">Contraseña <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="w-full bg-slate-50 dark:bg-[#071322] border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2.5 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition" placeholder="••••••••"></asp:TextBox>
                </div>

                <div>
                    <label class="block text-xs font-medium text-slate-700 dark:text-slate-300 mb-1">Confirmar Contraseña <span class="text-emerald-600 dark:text-emerald-400">*</span></label>
                    <asp:TextBox ID="txtPasswordConfirm" runat="server" TextMode="Password" CssClass="w-full bg-slate-50 dark:bg-[#071322] border border-slate-300 dark:border-slate-700 rounded-lg px-3 py-2.5 text-sm text-slate-900 dark:text-white placeholder-slate-400 dark:placeholder-slate-500 focus:outline-none focus:border-blue-500 transition" placeholder="••••••••"></asp:TextBox>
                </div>

                <asp:Button ID="btnRegistrar" runat="server" Text="Completar Registro" OnClick="btnRegistrar_Click" CssClass="w-full bg-emerald-600 hover:bg-emerald-500 text-white font-bold py-3 rounded-lg text-sm transition cursor-pointer mt-2 shadow-lg shadow-emerald-900/20" />

                <div class="text-center text-xs text-slate-500 dark:text-slate-400 pt-2">
                    ¿Ya estás registrado? <a href="../Default.aspx" class="text-blue-600 dark:text-blue-400 font-semibold hover:underline">Iniciar Sesión</a>
                </div>
            </div>
        </div>

    </form>

    <script>
        function updateThemeIcons(isDark) {
            const sunIcon = document.getElementById('themeIconSun');
            const moonIcon = document.getElementById('themeIconMoon');
            if (isDark) {
                sunIcon.classList.remove('hidden');
                moonIcon.classList.add('hidden');
            } else {
                sunIcon.classList.add('hidden');
                moonIcon.classList.remove('hidden');
            }
        }

        function toggleTheme() {
            const isDark = document.documentElement.classList.toggle('dark');
            localStorage.setItem('coopfacil-theme', isDark ? 'dark' : 'light');
            updateThemeIcons(isDark);
        }

        function filtrarSoloLetras(input) {
            if (!input) return;
            input.value = input.value.replace(/[^a-zA-ZáéíóúÁÉÍÓÚñÑ\s]/g, '');
        }

        document.addEventListener('DOMContentLoaded', function () {
            const isDark = document.documentElement.classList.contains('dark');
            updateThemeIcons(isDark);
        });
    </script>
</body>
</html>