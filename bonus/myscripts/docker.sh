#!/bin/bash

TMP_DIR="/tmp"
install_docker()
{
    if [ "$(id -u)" -ne 0 ]; then
        echo "Run this script with sudo." >&2
        exit 1
    fi
    if command -v "curl" > /dev/null >&1; then
        if command -v "docker" >/dev/null 2>&1; then
            echo "docker is installed skipping installation..."
        else
            echo "docker is not installed or not in the PATH, reinstalling..." >&2
            curl -fsSL https://get.docker.com -o $TMP_DIR/get-docker.sh
            sudo bash $TMP_DIR/get-docker.sh
            if [ $? -eq 0 ]; then
                echo "docker installed successfully."
            else
                echo "Failed to install docker." >&2
                exit 1
            fi
        fi
    else
        echo "curl is missing, installing..."
        sudo apt install curl -y
        install_docker
    fi
}

install_docker