#!/bin/bash
sudo k3d kubeconfig merge p3-cluster --kubeconfig-switch-context &> /dev/null

if sudo kubectl get namespace argocd &> /dev/null; then
    echo "Namespace 'argocd' already exists. Skipping creation."
else
    echo "Creating namespace 'argocd'..."
    sudo kubectl create namespace argocd
    if [ $? -eq 0 ]; then
        echo "Namespace 'argocd' created successfully."
    else
        echo "Failed to create namespace 'argocd'."
        exit 1
    fi
fi

if sudo kubectl get namespace dev &> /dev/null; then
    echo "Namespace 'dev' already exists. Skipping creation."
else
    echo "Creating namespace 'dev'..."
    sudo kubectl create namespace dev
    if [ $? -eq 0 ]; then
        echo "Namespace 'dev' created successfully."
    else
        echo "Failed to create namespace 'dev'." >&2
        exit 1
    fi
fi

if sudo kubectl get namespace gitlab &> /dev/null; then
    echo "Namespace 'gitlab' already exists. Skipping creation."
else
    echo "Creating namespace 'gitlab'..."
    sudo kubectl create namespace gitlab
    if [ $? -eq 0 ]; then
        echo "Namespace 'gitlab' created successfully."
    else
        echo "Failed to create namespace 'gitlab'." >&2
        exit 1
    fi
fi
