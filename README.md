# 🔵🟢 Blue-Green Deployment on AWS

<p align="center">

**A hands-on AWS DevOps project implementing Blue-Green Deployment using EC2, Application Load Balancer, Target Groups, AWS CLI and CloudWatch.**

</p>

<p align="center">

![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws)
![EC2](https://img.shields.io/badge/AWS-EC2-orange?logo=amazonec2)
![ALB](https://img.shields.io/badge/AWS-Application%20Load%20Balancer-blue)
![CLI](https://img.shields.io/badge/AWS-CLI-yellow?logo=amazonaws)
![CloudWatch](https://img.shields.io/badge/Amazon-CloudWatch-orange?logo=amazonaws)
![PowerShell](https://img.shields.io/badge/PowerShell-Automation-blue?logo=powershell)
![Deployment](https://img.shields.io/badge/Deployment-Blue--Green-success)

</p>

---

## 📌 Project Overview

This project demonstrates the implementation of a **Blue-Green Deployment strategy on AWS**.

Two separate application environments are maintained:

* 🔵 **Blue Environment** — Current stable/production environment
* 🟢 **Green Environment** — New version/staging environment

An **Application Load Balancer (ALB)** is used as the single entry point for users. The ALB listener forwards traffic to either the Blue or Green Target Group.

This allows the application to be updated with **minimal downtime** while keeping the previous environment available for **rapid rollback**.

---

## 🎯 Project Objectives

The main objectives of this project are:

* Create an AWS VPC and networking infrastructure.
* Configure public subnets across Availability Zones.
* Configure Internet Gateway and routing.
* Create security groups for ALB and EC2 instances.
* Launch separate Blue and Green EC2 environments.
* Configure Apache web servers using EC2 User Data.
* Create separate Target Groups.
* Configure an Application Load Balancer.
* Configure ALB listener-based traffic switching.
* Verify Target Group health.
* Monitor EC2 instances using CloudWatch.
* Perform Blue → Green deployment.
* Perform Green → Blue rollback using AWS CLI.

---

# 🏗️ Architecture

```text
                         👨‍💻 Developer
                              │
                              ▼
                     ┌─────────────────┐
                     │     AWS CLI     │
                     │   PowerShell    │
                     └────────┬────────┘
                              │
                              ▼
                    ┌────────────────────┐
                    │  Application Load  │
                    │     Balancer       │
                    └─────────┬──────────┘
                              │
                       Listener :80
                              │
                    ┌─────────┴─────────┐
                    │                   │
                    ▼                   ▼
             ┌─────────────┐     ┌─────────────┐
             │ 🔵 Blue-TG  │     │ 🟢 Green-TG │
             └──────┬──────┘     └──────┬──────┘
                    │                   │
                    ▼                   ▼
             ┌─────────────┐     ┌─────────────┐
             │ 🔵 Blue EC2 │     │ 🟢 Green EC2│
             │   Apache    │     │   Apache    │
             └─────────────┘     └─────────────┘
                    │                   │
                    └─────────┬─────────┘
                              │
                              ▼
                       ☁️ CloudWatch
                         Monitoring
```

### Traffic Flow

Only one environment receives production traffic at a time.

```text
                    ALB Listener
                         │
              ┌──────────┴──────────┐
              │                     │
              ▼                     ▼
         🔵 BLUE-TG             🟢 GREEN-TG
              │                     │
              ▼                     ▼
         🔵 Blue EC2            🟢 Green EC2
```

The active Target Group can be changed without replacing the EC2 infrastructure.

---

# 🔄 Blue-Green Deployment Workflow

The deployment process follows these stages:

```text
┌──────────────────────────────┐
│     🔵 Blue is Production    │
└──────────────┬───────────────┘
               │
               ▼
     Deploy New Version
               │
               ▼
┌──────────────────────────────┐
│      🟢 Green Environment    │
│         is prepared          │
└──────────────┬───────────────┘
               │
               ▼
       Health Check Green
               │
        ┌──────┴──────┐
        │             │
     Healthy       Unhealthy
        │             │
        ▼             ▼
 Switch Traffic    Fix Green
 Blue → Green          │
        │              │
        ▼              │
 Monitor Green         │
        │              │
    ┌───┴────┐         │
    │        │         │
 Stable   Failure      │
    │        │         │
    ▼        ▼         │
 Keep     Rollback ◄───┘
 Green    Green → Blue
```

---

# ☁️ AWS Services Used

| AWS Service                   | Purpose                                           |
| ----------------------------- | ------------------------------------------------- |
| **Amazon VPC**                | Provides isolated networking                      |
| **Amazon EC2**                | Hosts Blue and Green application servers          |
| **Application Load Balancer** | Receives and routes application traffic           |
| **Target Groups**             | Represent Blue and Green environments             |
| **Internet Gateway**          | Provides Internet connectivity                    |
| **Route Tables**              | Control network routing                           |
| **Security Groups**           | Control inbound/outbound traffic                  |
| **Amazon CloudWatch**         | Monitor server health and performance             |
| **AWS CLI**                   | Automate infrastructure and deployment operations |

---

# 📁 Project Structure

```text
BlueGreenDeployment/
│
├── app/
│   └── Application files
│
├── aws-cli/
│   ├── 01-vpc.ps1
│   ├── 02-subnets.ps1
│   ├── 03-internet-gateway.ps1
│   ├── 04-route-table.ps1
│   ├── 05-security-groups.ps1
│   ├── 06-user-data.sh
│   └── config.ps1
│
├── docs/
│   ├── resource-ids.txt
│   └── Screenshots/
│
├── .gitignore
└── README.md
```

> 🔐 The EC2 private key (`.pem`) should remain local and must not be committed to GitHub.

---

# 🌐 AWS Infrastructure

## VPC

The deployment uses a dedicated VPC:

```text
VPC CIDR: 10.0.0.0/16
Region: ap-south-1
```

The VPC provides an isolated networking environment for the Blue-Green infrastructure.

---

## Public Subnets

Two public subnets are used to provide high availability across Availability Zones.

```text
Public Subnet A
10.0.1.0/24
ap-south-1a
```

```text
Public Subnet B
10.0.2.0/24
ap-south-1b
```

---

## Internet Gateway

An Internet Gateway provides Internet connectivity for resources deployed in the public subnets.

The route table contains:

```text
10.0.0.0/16 → local
0.0.0.0/0   → Internet Gateway
```

---

# 🔐 Security Groups

Two security groups are used:

### ALB Security Group

Controls incoming traffic to the Application Load Balancer.

### Web Server Security Group

Controls traffic reaching the EC2 application servers.

The architecture is:

```text
Internet
   │
   ▼
ALB Security Group
   │
   ▼
Application Load Balancer
   │
   ▼
Web Server Security Group
   │
   ├── 🔵 Blue EC2
   │
   └── 🟢 Green EC2
```

---

# 💻 EC2 Blue & Green Environments

The project uses two independent EC2 environments.

```text
🔵 BLUE ENVIRONMENT
Current / Stable Version
        │
        ▼
    Blue EC2
        │
        ▼
    Blue-TG
```

```text
🟢 GREEN ENVIRONMENT
New / Tested Version
        │
        ▼
    Green EC2
        │
        ▼
    Green-TG
```

The environments can be independently tested before traffic is switched.

---

# 📝 EC2 User Data Automation

The project uses `06-user-data.sh` to configure the EC2 web servers automatically.

The script performs tasks such as:

```text
1. Update packages
2. Install Apache
3. Enable Apache
4. Start Apache
5. Retrieve EC2 instance information
6. Create the application web page
7. Display environment information
```

This allows the Blue and Green servers to clearly identify themselves.

Example:

```html
<h1>GREEN ENVIRONMENT</h1>
<h2>Instance ID: i-xxxxxxxxxxxxxxxxx</h2>
```

This makes it easy to verify which environment is receiving traffic.

---

# ⚖️ Application Load Balancer

The Application Load Balancer provides a single endpoint for users.

```text
                         Internet
                            │
                            ▼
                  ┌───────────────────┐
                  │   BlueGreen-ALB   │
                  └─────────┬─────────┘
                            │
                       HTTP :80
                            │
                            ▼
                    ┌───────────────┐
                    │ ALB Listener  │
                    └───────┬───────┘
                            │
                  ┌─────────┴─────────┐
                  │                   │
                  ▼                   ▼
             🔵 Blue-TG          🟢 Green-TG
                  │                   │
                  ▼                   ▼
             🔵 Blue EC2         🟢 Green EC2
```

---

# 🎯 Target Groups

Two Target Groups represent the two deployment environments:

```text
🔵 Blue-TG
       │
       └── Blue EC2
```

```text
🟢 Green-TG
       │
       └── Green EC2
```

Before switching traffic, the health of the target must be verified.

---

# 🩺 Health Check

### Check Blue Target Group

```powershell
aws elbv2 describe-target-health `
    --target-group-arn $BLUE_TARGET_GROUP `
    --region $REGION
```

### Check Green Target Group

```powershell
aws elbv2 describe-target-health `
    --target-group-arn $GREEN_TARGET_GROUP `
    --region $REGION
```

Expected healthy state:

```text
State: healthy
```

Only after the Green environment is healthy should production traffic be switched.

---

# 🚦 Check Current Traffic

The ALB listener configuration can be checked using:

```powershell
aws elbv2 describe-listeners `
    --listener-arns $LISTENER_ARN `
    --query "Listeners[0].DefaultActions[*].ForwardConfig.TargetGroups[*].{TargetGroup:TargetGroupArn,Weight:Weight}" `
    --output table `
    --region $REGION
```

This identifies which Target Group is currently receiving traffic.

---

# 🔵➡️🟢 Deploy Blue → Green

After the Green environment has been successfully tested, switch traffic from Blue to Green.

```powershell
aws elbv2 modify-listener `
    --listener-arn $LISTENER_ARN `
    --default-actions "Type=forward,TargetGroupArn=$GREEN_TARGET_GROUP" `
    --region $REGION
```

Traffic flow becomes:

```text
Users
  │
  ▼
ALB
  │
  ▼
Green Target Group
  │
  ▼
🟢 Green EC2
```

The Green environment is now serving production traffic.

---

# 🟢➡️🔵 Rollback

If the Green deployment fails health checks or application validation, traffic can be immediately returned to Blue.

```powershell
aws elbv2 modify-listener `
    --listener-arn $LISTENER_ARN `
    --default-actions "Type=forward,TargetGroupArn=$BLUE_TARGET_GROUP" `
    --region $REGION
```

Traffic flow becomes:

```text
Users
  │
  ▼
ALB
  │
  ▼
Blue Target Group
  │
  ▼
🔵 Blue EC2
```

This is the key advantage of the Blue-Green deployment strategy: **the previous environment remains available for rapid recovery.**

---

# 📊 CloudWatch Monitoring

Amazon CloudWatch is used to monitor the EC2 environments.

Important metrics include:

* CPU Utilization
* Network In
* Network Out
* Network Packets In
* Network Packets Out
* Status Check Failed
* System Status Check
* Instance health

Monitoring helps determine whether the Green environment is stable after deployment.

---

# 📸 Implementation Screenshots

## 1. EC2 Blue & Green Environments

The AWS EC2 console showing the deployed environments.

![EC2 Blue and Green Environments](Screenshots/Screenshot%202026-08-16%20131919.png)

---

## 2. CloudWatch Monitoring

CloudWatch provides monitoring information for the deployed EC2 instances.

![CloudWatch Monitoring](Screenshots/Screenshot%202026-08-16%20132111.png)

---

## 3. AWS Resource Configuration

The project configuration contains the resource identifiers required by the AWS CLI scripts.

![AWS Resource Configuration](Screenshots/Screenshot%202026-08-16%20132225.png)

---

## 4. Target Group Health

The AWS CLI is used to verify whether the Blue and Green targets are healthy.

![Target Group Health](Screenshots/Screenshot%202026-08-16%20132243.png)

---

## 5. ALB Listener Configuration

The ALB listener determines which Target Group receives application traffic.

![ALB Listener Configuration](Screenshots/Screenshot%202026-08-16%20132254.png)

---

# 🧪 Deployment Verification

The deployment can be verified using the following sequence:

### Step 1 — Check Blue Health

```powershell
aws elbv2 describe-target-health `
    --target-group-arn $BLUE_TARGET_GROUP `
    --region $REGION
```

### Step 2 — Check Green Health

```powershell
aws elbv2 describe-target-health `
    --target-group-arn $GREEN_TARGET_GROUP `
    --region $REGION
```

### Step 3 — Identify Active Target Group

```powershell
aws elbv2 describe-listeners `
    --listener-arns $LISTENER_ARN `
    --region $REGION
```

### Step 4 — Switch Traffic

```powershell
aws elbv2 modify-listener `
    --listener-arn $LISTENER_ARN `
    --default-actions "Type=forward,TargetGroupArn=$GREEN_TARGET_GROUP" `
    --region $REGION
```

### Step 5 — Test Application

Open the ALB DNS name in a browser and verify that the displayed environment changes.

### Step 6 — Rollback if Required

```powershell
aws elbv2 modify-listener `
    --listener-arn $LISTENER_ARN `
    --default-actions "Type=forward,TargetGroupArn=$BLUE_TARGET_GROUP" `
    --region $REGION
```

---

# 📈 Deployment Results

The project demonstrates:

| Capability                | Result        |
| ------------------------- | ------------- |
| EC2 Blue Environment      | ✅ Implemented |
| EC2 Green Environment     | ✅ Implemented |
| Application Load Balancer | ✅ Implemented |
| Blue Target Group         | ✅ Implemented |
| Green Target Group        | ✅ Implemented |
| Target Health Checks      | ✅ Implemented |
| Traffic Switching         | ✅ Implemented |
| Blue → Green Deployment   | ✅ Implemented |
| Green → Blue Rollback     | ✅ Implemented |
| CloudWatch Monitoring     | ✅ Implemented |
| AWS CLI Automation        | ✅ Implemented |
| PowerShell Automation     | ✅ Implemented |

---

# ⭐ Key Benefits

### Minimal Downtime

Production traffic can be redirected without stopping the entire application.

### Fast Rollback

The previous Blue environment remains available, allowing rapid recovery.

### Safer Deployment

The Green environment can be tested before becoming production.

### Independent Environments

Blue and Green can be configured and monitored separately.

### Controlled Traffic

The ALB listener determines which environment receives user traffic.

### AWS CLI Automation

Deployment operations can be performed quickly using repeatable CLI commands.

---

# 🔐 Security Considerations

Never commit private keys or AWS credentials to GitHub.

The following files should be excluded:

```gitignore
*.pem
.env
.env.*
```

The project should never contain:

```text
AWS Access Key
AWS Secret Access Key
AWS Session Token
Private SSH Keys
Passwords
API Keys
```

The EC2 private key used for SSH access should remain on the local machine.

---

# 🚀 Future Enhancements

The current implementation can be extended with:

* GitHub Actions CI/CD
* Automated deployment pipeline
* Automated health validation
* Automatic rollback
* AWS Auto Scaling Groups
* HTTPS using AWS Certificate Manager
* Route 53 custom domain
* CloudWatch Alarms
* SNS notifications
* Terraform / CloudFormation Infrastructure as Code
* Canary deployments
* Weighted ALB traffic shifting
* Containerization using Amazon ECS

---

# 🧠 Learning Outcomes

Through this project, I gained practical experience with:

* AWS VPC networking
* EC2 provisioning
* Linux server configuration
* Application Load Balancers
* Target Groups
* ALB listeners
* Health checks
* AWS CLI
* PowerShell automation
* EC2 User Data
* CloudWatch monitoring
* Blue-Green deployment
* Production traffic switching
* Rollback strategies
* AWS security fundamentals

---

# 👨‍💻 Author

1. **Bhargav Das**
2. **Aryan Ranjan**
3. **Rishu Kumar**
4. **Shobhit Panchal**
5. **Keshav Kumar**

Cloud / AWS Enthusiast

### Technologies

`AWS` • `EC2` • `VPC` • `ALB` • `CloudWatch` • `AWS CLI` • `PowerShell` • `Linux`

---

# ⭐ Conclusion

This project successfully demonstrates a practical **Blue-Green Deployment architecture on AWS**.

By maintaining separate Blue and Green environments and controlling traffic through an Application Load Balancer, application releases can be performed safely while keeping the previous version available for rollback.

The core deployment cycle is:

```text
🔵 BLUE
   │
   │ Deploy & Test
   ▼
🟢 GREEN
   │
   │ Health Check
   ▼
Traffic Switch
   │
   ▼
🟢 GREEN → Production
   │
   │ Failure?
   ▼
🔵 BLUE → Rollback
```

The project provides a strong foundation for moving toward a fully automated **CI/CD and DevOps deployment pipeline**.
