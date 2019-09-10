# 下載dotnet core 3.0 sdk Image
FROM mcr.microsoft.com/dotnet/core/sdk:3.0-alpine AS build
# 建立指定的工作目錄
WORKDIR /app 
# 將本機所有的檔案複製到所指定的工作目錄 (/app)
COPY . .
# 執行dotnet core發行指令，並將發行用的程式輸出至/app/Publish資料夾中
RUN  dotnet publish  -c Release -o Publish 


# 下載dotnet core 3.0 的runtime
FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-alpine as execImage
# 複製build Image裡的/app/Publish的檔案到本地端
COPY --from=build /app/Publish/. .
ENV ASPNETCORE_ENVIRONMENT="Development"
# 背景執行dotnet core 應用程式
ENTRYPOINT ["dotnet", "DockerDemo.dll"]