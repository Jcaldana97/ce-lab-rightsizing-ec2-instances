#!/bin/bash
yum update -y
 
# Install separately — if `stress` is unavailable in AL2023's default repos,
# a single combined `yum install` fails atomically and silently skips the
# CloudWatch agent too, since this script has no `set -e` to stop on error.
yum install -y amazon-cloudwatch-agent
yum install -y stress || echo "stress package unavailable — load testing in Step 4 will need an alternative"
 
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'CWCONFIG'
{
  "metrics": {
    "namespace": "CWAgent",
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}"
    },
    "metrics_collected": {
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": ["disk_used_percent"],
        "resources": ["/"],
        "metrics_collection_interval": 60
      }
    }
  }
}
CWCONFIG
 
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s