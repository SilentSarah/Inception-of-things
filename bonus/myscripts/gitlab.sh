#!/bin/bash

echo "Switching to the correct cluster context..."
sudo k3d kubeconfig merge p3-cluster --kubeconfig-switch-context &> /dev/null

sudo helm repo add gitlab https://charts.gitlab.io/
sudo helm repo update

echo "Installing GitLab CE (Lite)..."
sudo helm upgrade --install gitlab gitlab/gitlab \
  -n gitlab \
  --set global.hosts.domain=localhost \
  --set global.hosts.https=false \
  --set global.edition=ce \
  --set nginx-ingress.enabled=false \
  --set prometheus.install=false \
  --set gitlab-runner.install=false \
  --set global.ingress.configureCertmanager=false \
  --set global.ingress.class=traefik \
  --set gitlab.webservice.resources.requests.memory=512Mi \
  --set gitlab.webservice.workerProcesses=1 \
  --set gitlab.sidekiq.resources.requests.memory=512Mi \
  --set gitlab.sidekiq.concurrency=5 \
  --timeout 600s

if [ $? -eq 0 ]; then
    echo "Retrieving root password..."
    
    ITER=0
    while ! sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab &> /dev/null; do
        if [ $ITER -ge 12 ]; then
            echo "Timeout waiting for GitLab password secret." >&2
            exit 1
        fi
        echo "Waiting for password secret to be generated..."
        sleep 10
        ITER=$((ITER+1))
    done

    GITLAB_PWD=$(sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode)
    
    echo "GitLab Root Password: $GITLAB_PWD"
    echo "$GITLAB_PWD" > $(users)/gitlab-password.txt
    chmod 600 $(users)/gitlab-password.txt

    echo "Waiting for GitLab UI to be fully ready (this can take 5-10 minutes)..."
    sudo kubectl wait -n gitlab --for=condition=available deployment/gitlab-webservice-default --timeout=600s

    echo "------------------------------------------------------------"
    echo "GitLab Installation Complete!"
    echo "URL: http://gitlab.localhost:8081"
    echo "Username: root"
    echo "Password: $GITLAB_PWD"
    echo ""
    echo "Password saved to: $(users)/gitlab-password.txt"
    echo "------------------------------------------------------------"
else
    echo "Failed to install GitLab." >&2
    exit 1
fi