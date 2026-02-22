#!/bin/bash

if command -v k3d &> /dev/null; then
if sudo k3d cluster get p3-cluster &> /dev/null; then
    echo "p3-cluster exists, starting if necessary..."
    sudo k3d cluster start p3-cluster
    sudo k3d kubeconfig merge p3-cluster --kubeconfig-switch-context
else
    sudo k3d cluster create p3-cluster --port 8080:80@loadbalancer --port 8888:80@loadbalancer
    if [ $? -eq 0 ]; then
        echo "p3-cluster created successfully."
        sudo k3d kubeconfig merge p3-cluster --kubeconfig-switch-context
    else
        echo "Failed to create p3-cluster." >&2
        exit 1
    fi
fi
else
    echo "k3d is not installed, run k3d.sh" >&2
    exit 1
fi