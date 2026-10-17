<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CoopFacil.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CoopFacil - Iniciar Sesión</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body class="bg-[#0B1A30] text-white font-sans antialiased min-h-screen flex flex-col justify-between">
    <form id="form1" runat="server">
        
        <header class="border-b border-slate-800 bg-[#0B1A30]/90 sticky top-0 z-40 backdrop-blur">
            <div class="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
                <a href="Index.aspx" class="flex items-center gap-3">
                    <div class="relative flex items-center justify-center bg-[#0F233D] p-2 rounded-full border border-slate-700">
                        <i class="fa-solid fa-user text-xl text-blue-500"></i>
                        <i class="fa-solid fa-user text-xl text-emerald-500 -ml-1"></i>
                    </div>
                    <div>
                        <span class="text-xl font-bold tracking-tight block leading-none"><span class="text-blue-500">Coop</span><span class="text-emerald-500">Facil</span></span>
                        <span class="text-[10px] text-slate-400 tracking-wider uppercase">Cooperativa Financiera</span>
                    </div>
                </a>
            </div>
        </header>

        <main class="max-w-7xl mx-auto px-6 py-12 grid grid-cols-1 lg:grid-cols-12 gap-12 items-center flex-grow w-full">
            
            <div class="lg:col-span-7 space-y-6">
                <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-800/80 border border-slate-700 text-xs text-slate-300">
                    <span class="w-2 h-2 rounded-full bg-blue-500 animate-pulse"></span>
                    Cooperativa Regulada · Vigilada por Superintendencia
                </div>

                <h1 class="text-4xl md:text-6xl font-extrabold text-white leading-tight tracking-tight">
                    Finanzas que <br />
                    <span class="text-blue-500">construyen comunidad</span> <br />
                    desde 1987
                </h1>

                <p class="text-slate-300 text-base md:text-lg max-w-xl leading-relaxed">
                    CoopFacil es la cooperativa de ahorro y crédito de mayor crecimiento en la región. Democratizando el acceso a servicios financieros con principios cooperativos.
                </p>

                <div class="pt-8 grid grid-cols-2 sm:grid-cols-4 gap-6 border-t border-slate-800">
                    <div>
                        <p class="text-2xl md:text-3xl font-bold text-white">$0.0M</p>
                        <p class="text-xs text-slate-400 mt-1">Activos gestionados</p>
                    </div>
                    <div>
                        <p class="text-2xl md:text-3xl font-bold text-white">39</p>
                        <p class="text-xs text-slate-400 mt-1">Años de trayectoria</p>
                    </div>
                    <div>
                        <p class="text-2xl md:text-3xl font-bold text-white"><asp:Label ID="lblSocios" runat="server" Text="0"></asp:Label></p>
                        <p class="text-xs text-slate-400 mt-1">Socios registrados</p>
                    </div>
                    <div>
                        <p class="text-2xl md:text-3xl font-bold text-white text-emerald-400">100%</p>
                        <p class="text-xs text-slate-400 mt-1">Satisfacción</p>
                    </div>
                </div>
            </div>

            <!-- TARJETA INICIO SESIÓN -->
            <div class="lg:col-span-5">
                <div class="bg-[#0F233D]/90 border border-slate-700/60 rounded-2xl p-6 shadow-2xl backdrop-blur-md">
                    <div class="border-b border-slate-700/50 pb-4 mb-6">
                        <h2 class="text-center font-semibold text-white py-2 text-lg bg-slate-800/50 rounded-lg border border-slate-700/50">
                            Iniciar Sesión
                        </h2>
                    </div>

                    <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="mb-4 p-3 bg-red-900/50 border border-red-500 rounded-lg text-xs text-red-200">
                        <asp:Literal ID="litError" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="space-y-4">
                        <div>
                            <label class="block text-xs font-medium text-slate-300 mb-1">Correo Electrónico</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="w-full bg-[#071322] border border-slate-700 rounded-lg px-3 py-2.5 text-sm text-white focus:outline-none focus:border-blue-500 transition" placeholder="ejemplo@correo.com"></asp:TextBox>
                        </div>

                        <div>
                            <label class="block text-xs font-medium text-slate-300 mb-1">Contraseña</label>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="w-full bg-[#071322] border border-slate-700 rounded-lg px-3 py-2.5 text-sm text-white focus:outline-none focus:border-blue-500 transition" placeholder="••••••••"></asp:TextBox>
                        </div>

                        <asp:Button ID="btnAcceder" runat="server" Text="Acceder al Portal →" OnClick="btnAcceder_Click" CssClass="w-full bg-blue-600 hover:bg-blue-500 text-white font-bold py-3 rounded-lg text-sm transition cursor-pointer mt-2 shadow-lg shadow-blue-900/30" />

                        <div class="flex items-center justify-between text-xs text-slate-400 pt-2">
                            <span>¿No tienes cuenta?</span>
                            <a href="Pages/Registro.aspx" class="text-emerald-400 font-semibold hover:underline">Registrarse</a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </form>
</body>
</html>