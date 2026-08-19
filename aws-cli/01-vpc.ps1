# ============================
# Lesson 1 - Create VPC
# ============================

Write-Host ""
Write-Host "Creating BlueGreen VPC..."
Write-Host ""

aws ec2 create-vpc `
    --cidr-block 10.0.0.0/16 `
    --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=BlueGreen-VPC}]"

Write-Host ""
Write-Host "VPC creation request sent successfully."
Write-Host "Verify using:"
Write-Host 'aws ec2 describe-vpcs --filters "Name=tag:Name,Values=BlueGreen-VPC"'