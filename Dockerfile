# Use the official ASP.NET Core runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official .NET SDK as a build image
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["DotNetMetadataMcpServer/DotNetMetadataMcpServer.csproj", "DotNetMetadataMcpServer/"]
RUN dotnet restore "DotNetMetadataMcpServer/DotNetMetadataMcpServer.csproj"
COPY . .
WORKDIR "/src/DotNetMetadataMcpServer"
RUN dotnet build "DotNetMetadataMcpServer.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DotNetMetadataMcpServer.csproj" -c Release -o /app/publish

# Use the base image to run the app
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV HOME /app
ENTRYPOINT ["dotnet", "DotNetMetadataMcpServer.dll"]
