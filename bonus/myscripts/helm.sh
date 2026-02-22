#!/bin/bash

install_helm(){
if command -v "helm" &> /dev/null; then
    echo "helm is already installed"
else
    echo "installing helm"
    if command -v "curl" &> /dev/null; then
        curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | bash
        if [ $? -eq 0 ]; then
            echo "helm installed successfully."
        else
            echo "Failed to install helm." >&2
            exit 1
        fi
    else
        echo "curl is not installed, installing..."
        sudo apt install curl -y
        install_helm
    fi
fi
}

install_helm