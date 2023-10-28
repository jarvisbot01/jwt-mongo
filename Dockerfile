ARG VARIANT=7.0.403-bookworm-slim-amd64
FROM mcr.microsoft.com/dotnet/sdk:${VARIANT} AS build
WORKDIR /source

COPY *.csproj Api/
RUN dotnet restore Api/JwtMongo.csproj

COPY . Api/

FROM build AS publish
WORKDIR /source/Api
RUN dotnet publish -o /app

FROM mcr.microsoft.com/dotnet/aspnet:7.0.13-bookworm-slim-amd64 AS runtime
WORKDIR /app
COPY --from=publish /app .

ENTRYPOINT ["dotnet"]
CMD ["JwtMongo.dll", "--urls", "http://+:5000"]
