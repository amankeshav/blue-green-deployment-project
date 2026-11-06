# ======================================
# Lesson 4
# Create Route Table
# ======================================

. .\config.ps1

Write-Host ""
Write-Host "Creating Route Table..."
Write-Host ""

aws ec2 create-route-table `
    --vpc-id $VPC_ID `
    --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=Public-Route-Table}]"

Write-Host ""
Write-Host "Adding Internet Route..."
Write-Host ""

aws ec2 create-route `
    --route-table-id $ROUTE_TABLE_ID `
    --destination-cidr-block 0.0.0.0/0 `
    --gateway-id $IGW_ID

Write-Host ""
Write-Host "Associating Public Subnet A..."
Write-Host ""

aws ec2 associate-route-table `
    --route-table-id $ROUTE_TABLE_ID `
    --subnet-id $SUBNET_A

Write-Host ""
Write-Host "Associating Public Subnet B..."
Write-Host ""

aws ec2 associate-route-table `
    --route-table-id $ROUTE_TABLE_ID `
    --subnet-id $SUBNET_B

Write-Host ""
Write-Host "Route Table configuration completed."