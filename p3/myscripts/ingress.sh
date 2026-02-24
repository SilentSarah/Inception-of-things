#!/bin/bash

sudo kubectl apply -f $(pwd)/../confs/ingress.yaml
sudo kubectl apply -f $(pwd)/../confs/ingress-argocd.yaml