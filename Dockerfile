# Establecer la imagen base
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar los archivos del proyecto
COPY /usr/src/app/fibergis_catalogoapi/CatalogoApi/CatalogoFibergis .

# Restaurar las dependencias
RUN dotnet restore "CatalogoFibergis.csproj"

# Compilar la aplicación
RUN dotnet build "CatalogoFibergis.csproj" -c Release -o /app/build

# Publicar la aplicación
RUN dotnet publish "CatalogoFibergis.csproj" -c Release -o /app/publish

# Establecer la imagen base para la aplicación final
FROM mcr.microsoft.com/dotnet/aspnet:7.0

# Establecer el directorio de trabajo de la aplicación final
WORKDIR /app

# Copiar los archivos publicados desde la etapa anterior
COPY --from=build-env /app/publish .

# Exponer el puerto necesario
EXPOSE 5024

# Iniciar la aplicación al ejecutar el contenedor
ENTRYPOINT ["dotnet", "CatalogoFibergis.dll"]
