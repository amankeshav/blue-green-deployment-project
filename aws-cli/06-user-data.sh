#!/bin/bash

dnf update -y
dnf install -y httpd

systemctl enable httpd
systemctl start httpd

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds:21600")

INSTANCE_ID=$(curl \
-H "X-aws-ec2-metadata-token:$TOKEN" \
http://169.254.169.254/latest/meta-data/instance-id)

cat > /var/www/html/index.html <<EOF
<html>
<head>
<title>Green Deployment</title>
</head>
<body>
<h1>GREEN ENVIRONMENT</h1>
<h2>Instance ID: $INSTANCE_ID</h2>
</body>
</html>
EOF

systemctl restart httpd