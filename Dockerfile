# ---- Compilación ----
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Primero solo el .csproj, para aprovechar la caché de la restauración de paquetes
COPY CoopFacil/CoopFacil.csproj CoopFacil/
RUN dotnet restore CoopFacil/CoopFacil.csproj

COPY CoopFacil/ CoopFacil/
RUN dotnet publish CoopFacil/CoopFacil.csproj -c Release -o /app --no-restore

# ---- Ejecución ----
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app .

# Railway define PORT; Program.cs lo lee y escucha en 0.0.0.0:$PORT
ENV ASPNETCORE_ENVIRONMENT=Production
ENTRYPOINT ["dotnet", "CoopFacil.dll"]
