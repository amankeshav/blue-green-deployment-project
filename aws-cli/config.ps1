# =====================================
# AWS Project Configuration
# =====================================

# Region
$REGION = "ap-south-1"

# Force AWS CLI to use Mumbai
$env:AWS_REGION = $REGION
$env:AWS_DEFAULT_REGION = $REGION

# VPC
$VPC_ID = "vpc-043ee564b8349925f"

# Subnets
$SUBNET_A = "subnet-08b4201a1d20a1bae"
$SUBNET_B = "subnet-0d1951dcc77297680"

# Internet Gateway
$IGW_ID = "igw-0f09880e3851580ec"

# Route Table
$ROUTE_TABLE_ID = "rtb-0af15158c85af2dcf"

# Security Groups
$ALB_SG = "sg-094514a6ba5843b92"
$WEB_SG = "sg-0c124230e698a5aa2"

# EC2 Instances
$BLUE_INSTANCE = "i-0d319c274e3d036f1"
$GREEN_INSTANCE = "i-0ca2e2e8e3e261448"

# Target Groups
$BLUE_TARGET_GROUP = "arn:aws:elasticloadbalancing:ap-south-1:796973478135:targetgroup/Blue-TG/fbfbe53dcb139824"
$GREEN_TARGET_GROUP = "arn:aws:elasticloadbalancing:ap-south-1:796973478135:targetgroup/Green-TG/b05701f79b1d39b5"

# Load Balancer
$LOAD_BALANCER_ARN = "arn:aws:elasticloadbalancing:ap-south-1:796973478135:loadbalancer/app/BlueGreen-ALB/d034c5c261efde82"

# Listener
$LISTENER_ARN = "arn:aws:elasticloadbalancing:ap-south-1:796973478135:listener/app/BlueGreen-ALB/d034c5c261efde82/26360d72dc5b8c50"

