#!/bin/bash

# Set the hostname using hostnamectl
hostnamectl set-hostname ${hostname}

# Update /etc/hosts with the provided hostname
echo "$(hostname -I | awk '{print $1}') $hostname" >> /etc/hosts

# Set up basic CloudWatch configuration
sudo yum install -y amazon-cloudwatch-agent

# Configure CloudWatch agent (basic example)
cat <<EOF > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "my-log-group",
            "log_stream_name": "my-log-stream",
            "timezone": "UTC"
          }
        ]
      }
    }
  }
}
EOF

# Start CloudWatch agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
