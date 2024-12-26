# Stage 1: Build

# FROM is the base image that we use to build a new image. 
# This directive must be placed at the top of the Dockerfile.
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# WORKDIR is a directive used to set the working directory. 
# It is similar to a home directory, in this case, the home directory of the container. 
# When WORKDIR is called, it will create the directory on the first call and access it 
# as the home directory. It can be used multiple times within a Dockerfile.
WORKDIR /src

# The COPY directive is used to copy new files or directories from the source (src) 
# to the destination (dest) in the container's file system. 
# The source can be a local host path or a URL.
COPY ./server ./

# The RUN command is used to install or execute packages during the image build process.
RUN dotnet restore

# Set the working directory to where the .csproj file is located
WORKDIR /src/API

# Build the project
RUN dotnet publish -c Release -o /app/publish

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Copy the build artifacts from the previous stage
COPY --from=build /app/publish .

# Expose the port the application will run on
EXPOSE 8080

# Set the entry point for the container
ENTRYPOINT ["dotnet", "API.dll"]
