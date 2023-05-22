# Establecer la imagen base
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar los archivos del proyecto
COPY ./CatalogoApi .

COPY ./web.config ./CatalogoFibergis

# Restaurar las dependencias
RUN dotnet restore "./CatalogoFibergis/CatalogoFibergis.csproj"

# Compilar la aplicación
RUN dotnet build "./CatalogoFibergis/CatalogoFibergis.csproj" -c Release -o /app/build

# Publicar la aplicación
RUN dotnet publish "./CatalogoFibergis/CatalogoFibergis.csproj" -c Release -o /app/publish

# Establecer la imagen base para la aplicación final
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Establecer el directorio de trabajo de la aplicación final
WORKDIR /app

# Copiar los archivos publicados desde la etapa anterior
COPY --from=build-env /app/publish .

ENV ASPNETCORE_URLS=http://*:80
# ENV ASPNETCORE_ENVIRONMENT=”production”
ENV ASPNETCORE_ENVIRONMENT=Development

# Exponer el puerto necesario
# EXPOSE 44323
EXPOSE 80

# Iniciar la aplicación al ejecutar el contenedor
ENTRYPOINT ["dotnet", "CatalogoFibergis.dll"]
