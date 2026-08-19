# ==========================================
# Lesson 2 - Create Public Subnets
# ==========================================

. .\config.ps1

Write-Host ""
Write-Host "Creating Public Subnet A..."
Write-Host ""

aws ec2 create-subnet `
    --vpc-id $VPC_ID `
    --cidr-block 10.0.1.0/24 `
    --availability-zone ap-south-1a `
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=Public-Subnet-A}]"

Write-Host ""
Write-Host "Creating Public Subnet B..."
Write-Host ""

aws ec2 create-subnet `
    --vpc-id $VPC_ID `
    --cidr-block 10.0.2.0/24 `
    --availability-zone ap-south-1b `
    --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=Public-Subnet-B}]"

Write-Host ""
Write-Host "Public Subnet creation requests sent successfully."