#!/bin/bash

# Set variables
JENKINS_HOME="/var/lib/jenkins"
BACKUP_DIR="/path/to/backup/jenkins_backup"
S3_BUCKET="s3://your-bucket-name"
RESTORE_FROM_S3=false  # Set to true if restoring from S3

# Function to restore a tar.gz file
restore_archive() {
  local archive=$1
  local destination=$2
  echo "Restoring $archive to $destination..."
  tar -xzf "$archive" -C "$destination"
}

# Stop Jenkins service
sudo systemctl stop jenkins

# If restoring from S3
if [ "$RESTORE_FROM_S3" = true ]; then
  echo "Downloading backup from S3 bucket..."
  aws s3 cp "$S3_BUCKET" "$BACKUP_DIR" --recursive
fi

# Restore Jenkins Home Directory
restore_archive "$BACKUP_DIR/jenkins_home.tar.gz" "$JENKINS_HOME"

# Restore Jenkins Plugins
restore_archive "$BACKUP_DIR/jenkins_plugins.tar.gz" "$JENKINS_HOME/plugins"

# Restore Jenkins Users
restore_archive "$BACKUP_DIR/jenkins_users.tar.gz" "$JENKINS_HOME/users"

# Change ownership to jenkins user
sudo chown -R jenkins:jenkins "$JENKINS_HOME"

# Start Jenkins service
sudo systemctl start jenkins

# Print completion message
echo "Restore completed successfully."
