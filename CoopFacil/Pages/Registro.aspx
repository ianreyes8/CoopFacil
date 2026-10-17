<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="CoopFacil.Pages.Registro" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Registro de Socio - CoopFacil</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="bg-[#0B1A30] text-white font-sans antialiased min-h-screen flex items-center justify-center p-4">
    <form id="form1" runat="server" class="w-full max-w-md">
        
        <div class="bg-[#0F233D] border border-slate-700/60 rounded-2xl p-6 sm:p-8 shadow-2xl">
            
            <div class="text-center mb-6">
                <a href="../Default.aspx" class="inline-flex items-center gap-2 mb-2">
                    <div class="relative flex items-center justify-center bg-[#071322] p-2 rounded-full border border-slate-700">
                        <i class="fa-solid fa-user text-lg text-blue-500"></i>
                        <i class="fa-solid fa-user text-lg text-emerald-500 -ml-1"></i>
                    </div>
                    <span class="text-lg font-bold text-white"><span class="text-blue-500">Coop</span><span class="text-emerald-500">Facil</span></span>
                </a>
                <h2 class="text-xl font-bold text-white mt-2">Registro de Nuevo Socio</h2>
                <p class="text-xs text-slate-400 mt-1">Ingresa tus datos para registrarte en la cooperativa</p>
            </div>

            <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="mb-4 p-3 bg-red-900/50 border border-red-500 rounded-lg text-xs text-red-200">
                <asp:Literal ID="litError" runat="server"></asp:Literal>
            </asp:Panel>

            <div class="space-y-4">
                <div>
                    <label class="block text-xs font-medium text-slate-300 mb-1">Nombre Completo</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="w-full bg-[#071322] border border-slate-700 rounded-lg px-3 py-2.5 text-sm text-white focus:outline-none focus:border-blue-500 transition" placeholder="Ej. Juan Pérez"></asp:TextBox>
                </div>

                <div>
                    <label class="block text-xs font-medium text-slate-300 mb-1">Correo Electrónico</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="w-full bg-[#071322] border border-slate-700 rounded-lg px-3 py-2.5 text-sm text-white focus:outline-none focus:border-blue-500 transition" placeholder="correo@ejemplo.com"></asp:TextBox>
                </div>

                <div>
                    <label class="block text-xs font-medium text-slate-300 mb-1">Tipo de Acceso</label>
                    <asp:DropDownList ID="ddlTipoAcceso" runat="server" CssClass="w-full bg-[#071322] border border-slate-700 rounded-lg px-3 py-2.5 text-sm text-white focus:outline-none focus:border-blue-500 transition">
                        <asp:ListItem Value="Socio Individual">Socio Individual</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div>
                    <label class="block text-xs font-medium text-slate-300 mb-1">Contraseña</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="w-full bg-[#071322] border border-slate-700 rounded-lg px-3 py-2.5 text-sm text-white focus:outline-none focus:border-blue-500 transition" placeholder="••••••••"></asp:TextBox>
                </div>

                <div>
                    <label class="block text-xs font-medium text-slate-300 mb-1">Confirmar Contraseña</label>
                    <asp:TextBox ID="txtPasswordConfirm" runat="server" TextMode="Password" CssClass="w-full bg-[#071322] border border-slate-700 rounded-lg px-3 py-2.5 text-sm text-white focus:outline-none focus:border-blue-500 transition" placeholder="••••••••"></asp:TextBox>
                </div>

                <asp:Button ID="btnRegistrar" runat="server" Text="Completar Registro" OnClick="btnRegistrar_Click" CssClass="w-full bg-emerald-600 hover:bg-emerald-500 text-white font-bold py-3 rounded-lg text-sm transition cursor-pointer mt-2 shadow-lg shadow-emerald-900/30" />

                <div class="text-center text-xs text-slate-400 pt-2">
                    ¿Ya estás registrado? <a href="../Default.aspx" class="text-blue-400 font-semibold hover:underline">Iniciar Sesión</a>
                </div>
            </div>
        </div>

    </form>
</body>
</html>