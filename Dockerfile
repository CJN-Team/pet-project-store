#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Pet.Project.Store.Api/Pet.Project.Store.Api.csproj", "Pet.Project.Store.Api/"]
COPY ["Pet.Project.Store.Domain/Pet.Project.Store.Domain.csproj", "Pet.Project.Store.Domain/"]
COPY ["Pet.Project.Store.Infraestructure/Pet.Project.Store.Infraestructure.csproj", "Pet.Project.Store.Infraestructure/"]
RUN dotnet restore "Pet.Project.Store.Api/Pet.Project.Store.Api.csproj"
COPY . .
WORKDIR "/src/Pet.Project.Store.Api"
RUN dotnet build "Pet.Project.Store.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Pet.Project.Store.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Pet.Project.Store.Api.dll"]