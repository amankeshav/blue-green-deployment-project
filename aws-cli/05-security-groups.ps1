# ==========================================
# Lesson 5 - Security Groups
# ==========================================

. .\config.ps1

Write-Host ""
Write-Host "Creating ALB Security Group..."
Write-Host ""

aws ec2 create-security-group `
    --group-name ALB-SG `
    --description "Application Load Balancer Security Group" `
    --vpc-id $VPC_ID `
    --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=ALB-SG}]"

Write-Host ""
Write-Host "Creating Web Server Security Group..."
Write-Host ""

aws ec2 create-security-group `
    --group-name WEB-SG `
    --description "Web Server Security Group" `
    --vpc-id $VPC_ID `
    --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=WEB-SG}]"

Write-Host ""
Write-Host "Security Group creation requests sent successfully."