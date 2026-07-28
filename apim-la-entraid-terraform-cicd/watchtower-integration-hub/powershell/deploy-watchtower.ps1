# deploy-watchtower.ps1
Write-Host "🦸 Deploying Watchtower Integration Hub..." -ForegroundColor Cyan

# Variables
$resourceGroup = "rg-watchtower-$(Get-Random -Minimum 1000 -Maximum 9999)"
$location = "eastus"
$prefix = "watchtower"

# 1. Create Resource Group
Write-Host "📁 Creating resource group..." -ForegroundColor Yellow
az group create --name $resourceGroup --location $location

# 2. Deploy API Management
Write-Host "🌐 Deploying API Management..." -ForegroundColor Yellow
$apimName = "${prefix}-apim-$(-join ((65..90) + (97..122) | Get-Random -Count 6 | % {[char]$_}))"
az apim create --name $apimName --resource-group $resourceGroup `
    --publisher-name "Justice League" --publisher-email "admin@watchtower.league" `
    --sku-name Developer

# 3. Deploy Logic Apps
Write-Host "⚡ Deploying Logic Apps..." -ForegroundColor Yellow
az logic workflow create --name "logic-gotham-patrol" `
    --resource-group $resourceGroup --location $location `
    --definition-file "logic-apps/gotham-patrol.json"

az logic workflow create --name "logic-krypton-alert" `
    --resource-group $resourceGroup --location $location `
    --definition-file "logic-apps/krypton-alert.json"

# 4. Deploy Key Vault
Write-Host "🔑 Deploying Key Vault..." -ForegroundColor Yellow
$kvName = "${prefix}-kv-$(-join ((65..90) + (97..122) | Get-Random -Count 6 | % {[char]$_}))"
az keyvault create --name $kvName --resource-group $resourceGroup --location $location

Write-Host "✅ Watchtower Integration Hub Deployed!" -ForegroundColor Green
Write-Host "API Gateway URL: https://${apimName}.azure-api.net" -ForegroundColor Green