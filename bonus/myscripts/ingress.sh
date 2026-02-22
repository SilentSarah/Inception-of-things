#!/bin/bash

sudo kubectl apply -f /vagrant/confs/ingress.yaml
sudo kubectl apply -f /vagrant/confs/ingress-argocd.yaml
