#!/bin/bash
sudo k3d kubeconfig merge p3-cluster --kubeconfig-switch-context &> /dev/null

if command -v kubectl &> /dev/null; then
    if sudo kubectl get namespace argocd &> /dev/null; then
        sudo kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

        sudo kubectl patch configmap argocd-cmd-params-cm -n argocd --type merge -p '{"data":{"server.insecure":"true"}}'
        sudo kubectl rollout restart deployment argocd-server -n argocd

        echo "Waiting for ArgoCD deployments to be available..."
        sudo kubectl wait -n argocd --for=condition=available deployment --all --timeout=600s
        if [ $? -eq 0 ]; then
            echo "argocd installed successfully."
            echo "Applying ArgoCD Application..."
            sudo kubectl apply -f $(pwd)/../confs/application.yaml

            echo "Retrieving ArgoCD Password..."
            ARGOCD_PWD=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

            echo "ArgoCD Password: $ARGOCD_PWD"
            echo "$ARGOCD_PWD" > $HOME/argocd-password.txt
            chmod 600 $HOME/argocd-password.txt

            echo "------------------------------------------------------------"
            echo "ArgoCD Installation Complete!"
            echo "ArgoCD URL IN VM: http://argocd.localhost:8080"
            echo "ArgoCD URL ON HOST: http://argocd.localhost:8081"
            echo "Username: admin"
            echo "Password: $ARGOCD_PWD"
            echo ""
            echo "Password saved to: $HOME/argocd-password.txt"
            echo "------------------------------------------------------------"
        else
            echo "Failed to install argocd." >&2
            exit 1
        fi
    else
        echo "argocd namespace does not exist, run namespaces.sh" >&2
        exit 1
    fi
else
    echo "kubectl is not installed, run kubectl.sh" >&2
    exit 1
fi