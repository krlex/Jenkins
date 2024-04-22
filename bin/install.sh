#!/bin/bash
#

export BIN_DIR=`dirname $0`
export PROJECT_ENV="${BIN_DIR}/../"

# Function to install dependencies for Debian/Ubuntu
install_dependencies_debian() {
    echo "Installing dependencies for Debian/Ubuntu..."
    sudo apt-get update
    sudo apt-get install -y openjdk-17-jdk
}

# Function to install dependencies for Fedora/CentOS
install_dependencies_fedora() {
    echo "Installing dependencies for Fedora/CentOS..."
    sudo yum update
    sudo yum install -y java-17-openjdk-devel
}

# Function to install Docker and Docker Compose
install_docker_and_compose() {
    echo "Installing Docker and Docker Compose..."

    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER

    # Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
}

# Function to install Jenkins without Docker
install_jenkins_without_docker() {
    if [ "$distribution" == "debian" ]; then
        install_dependencies_debian
    elif [ "$distribution" == "fedora" ]; then
        install_dependencies_fedora
    fi
    
    echo "Installing Jenkins without Docker..."
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add - >/dev/null 2>&1
    sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt-get update
    sudo apt-get install -y jenkins
    sudo groupadd docker
    sudo usermod -aG docker jenkins
}

# Function to install Jenkins with Docker
install_jenkins_with_docker() {
    # Check if Docker and Docker Compose are installed
    if ! command -v docker &>/dev/null || ! command -v docker-compose &>/dev/null; then
        install_docker_and_compose
    fi
    
    echo "Installing Jenkins with Docker..."
    # Placeholder for Docker Compose commands
    sudo docker-compose -f $PROJECT_ENV/docker-compose.yml up -d
}

# Function to output initial admin password
output_initial_password() {
    echo "Initial admin password:"
    sudo docker exec $(sudo docker ps -aqf "name=jenkins") cat /var/jenkins_home/secrets/initialAdminPassword
}

# Main script

# Prompt user for options
options=("Docker" "Docker Compose" "Tomcat" "Maven" "Yarn" "NPM" "Jenkins")
selected=()

echo "List of available options:"
for (( i=0; i<${#options[@]}; i++ )); do
    echo "$((i+1)). ${options[$i]}"
done

# Prompt user for selections
read -p "Enter the numbers of the options you want to install (e.g., '1 3 5'): " selections
for selection in $selections; do
    index=$((selection - 1))
    if [ $index -ge 0 ] && [ $index -lt ${#options[@]} ]; then
        selected+=("${options[$index]}")
    else
        echo "Invalid option number: $selection"
    fi
done

# Detect the Linux distribution
if [ -f /etc/debian_version ]; then
    distribution="debian"
elif [ -f /etc/redhat-release ]; then
    distribution="fedora"
else
    echo "Unsupported Linux distribution."
    exit 1
fi

# If Jenkins selected, prompt for installation method
if [[ " ${selected[@]} " =~ " Jenkins " ]]; then
    echo "Select Jenkins installation method:"
    echo "1. Without Docker"
    echo "2. With Docker Compose"
    read -p "Enter the number of the installation method: " jenkins_installation_option
    case "$jenkins_installation_option" in
        1 )
            install_jenkins_without_docker
            ;;
        2 )
            install_jenkins_with_docker
            ;;
        * )
            echo "Invalid option. Jenkins installation aborted."
            ;;
    esac
fi

# If Jenkins selected and installed with Docker, output initial admin password
if [[ " ${selected[@]} " =~ " Jenkins " ]] && [[ " ${selected[@]} " =~ " Docker Compose " ]]; then
    echo "Waiting for Jenkins container to initialize..."
    sleep 30 # Adjust as needed
    output_initial_password
fi
