#!/bin/bash

# Set variables
JENKINS_HOME="/var/lib/jenkins"
BACKUP_DIR="/path/to/backup/jenkins_backup_$(date +%F_%T)"
S3_BUCKET="s3://your-bucket-name"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Stop Jenkins service
sudo systemctl stop jenkins

# Backup Jenkins Home Directory
echo "Backing up Jenkins home directory..."
tar -czf "$BACKUP_DIR/jenkins_home.tar.gz" -C "$JENKINS_HOME" .

# Backup Jenkins plugins
echo "Backing up Jenkins plugins..."
tar -czf "$BACKUP_DIR/jenkins_plugins.tar.gz" -C "$JENKINS_HOME/plugins" .

# Backup Jenkins users
echo "Backing up Jenkins users..."
tar -czf "$BACKUP_DIR/jenkins_users.tar.gz" -C "$JENKINS_HOME/users" .

# Start Jenkins service
sudo systemctl start jenkins

# Copy backup to S3 (optional)
if [ -n "$S3_BUCKET" ]; then
  echo "Copying backup to S3 bucket..."
  aws s3 cp "$BACKUP_DIR" "$S3_BUCKET" --recursive
fi

# Print completion message
echo "Backup completed successfully. Files are stored in $BACKUP_DIR"
