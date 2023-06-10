# Establecer la imagen base
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar los archivos del proyecto
COPY ./CatalogoApi .

COPY ./web.config ./CatalogoFibergis

COPY ./CatalogoApi/CatalogoFibergis/appsettings.json ./CatalogoFibergis/appsettings.Development.json

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
COPY --from=build-env /app/CatalogoFibergis/catalogoFibergis.xml .

ENV ASPNETCORE_URLS=http://*:80
# ENV ASPNETCORE_ENVIRONMENT=”production”
ENV ASPNETCORE_ENVIRONMENT=Development

# Exponer el puerto necesario
# EXPOSE 44323
EXPOSE 80
# EXPOSE 443

# Eliminar la carpeta si existe y luego crearla en el contenedor
RUN rm -rf /app/wwwroot && mkdir /app/wwwroot

# Agregar el volumen para mapear la carpeta del host al contenedor
VOLUME /home/geouser/pasaje/wwwroot:/app/wwwroot

# Iniciar la aplicación al ejecutar el contenedor
ENTRYPOINT ["dotnet", "CatalogoFibergis.dll"]
