#!/bin/bash

install_k3d() {
    if command -v "k3d" > /dev/null >&1; then
        echo "k3d is already installed, skipping..."
    else
        echo "k3d is missing, installing..."
        curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
        if [ $? -eq 0 ]; then
            echo "k3d installed successfully."
        else
            echo "Failed to install k3d." >&2
            exit 1
        fi
    fi
}

install_k3d
