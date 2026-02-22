#!/bin/bash

KUBECTL_RELEASE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
install_kubectl() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "Run this script with sudo." >&2
        exit 1
    fi
    if command -v "curl" > /dev/null >&1; then
        if command -v "kubectl" > /dev/null >&1; then
            echo "kubectl is already installed, skipping..."
        else
            echo "kubectl is missing, installing..."
            curl -LO "https://dl.k8s.io/release/$KUBECTL_RELEASE_VERSION/bin/linux/amd64/kubectl"
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
            if [ $? -eq 0 ]; then
                echo "kubectl installed successfully."
            else
                echo "Failed to install kubectl." >&2
                exit 1
            fi
        fi
    else
        echo "curl is missing, installing..."
        sudo apt install curl -y
        install_kubectl
    fi
}

install_kubectl