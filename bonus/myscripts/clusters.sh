#!/bin/bash

if command -v k3d &> /dev/null; then
if sudo k3d cluster get bonus-cluster &> /dev/null; then
    echo "bonus-cluster exists, starting if necessary..."
    sudo k3d cluster start bonus-cluster
    sudo k3d kubeconfig merge bonus-cluster --kubeconfig-switch-context
else
    sudo k3d cluster create bonus-cluster --port 8080:80@loadbalancer --port 8888:80@loadbalancer
    if [ $? -eq 0 ]; then
        echo "bonus-cluster created successfully."
        sudo k3d kubeconfig merge bonus-cluster --kubeconfig-switch-context
    else
        echo "Failed to create bonus-cluster." >&2
        exit 1
    fi
fi
else
    echo "k3d is not installed, run k3d.sh" >&2
    exit 1
fi