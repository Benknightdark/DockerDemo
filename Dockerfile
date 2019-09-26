# 下載dotnet core 3.0 sdk Image後，命名為build，並透過此Image產生一個暫時性的Container
FROM mcr.microsoft.com/dotnet/core/sdk:3.0-alpine AS build
# 建立Conatiner指定的工作目錄
WORKDIR /app 
# 將目前Dockerfile同一層的所有檔案和資料夾複製到所指定的Container工作目錄 (/app)
COPY . .
# 執行dotnet core發行指令，並將發行用的程式存至/app/Publish資料夾中
RUN  dotnet publish  -c Release -o Publish 


# 下載dotnet core 3.0 的runtime Image後，命名為runtime，並透過此Image產生一個Container
FROM mcr.microsoft.com/dotnet/core/aspnet:3.0-alpine as runtime
# 複製build Image所產生的 Container裡的/app/Publish的檔案到runtime Image所產生的 Cotainer的根目錄
COPY --from=build /app/Publish/. .
# 設定container的環境變數
ENV HOME_PAGE_NAME="Hello Docker"
# 背景執行dotnet core 應用程式
ENTRYPOINT ["dotnet", "DockerDemo.dll"]

#所有流程跑完後，會將最後一個產生的Container封裝為Image，並將先前產生的Container通通刪除
