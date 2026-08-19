# ==========================================
# Lesson 3 - Internet Gateway
# ==========================================

. .\config.ps1

Write-Host ""
Write-Host "Creating Internet Gateway..."
Write-Host ""

aws ec2 create-internet-gateway `
    --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=BlueGreen-IGW}]"

Write-Host ""
Write-Host "Attaching Internet Gateway to VPC..."
Write-Host ""

Write-Host "Run the attach command after copying the Internet Gateway ID."