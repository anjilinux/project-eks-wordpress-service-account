#!/bin/bash
#
# Run this script to deploy Wordpress on Kubernetes
#

# Allow connection from master to nodes
kubectl apply -f template-aws-auth-cm.yaml

# Allow Tiller (helm service username) to use namespaces
kubectl apply -f rbac-config.yaml

# Init helm
helm init --service-account tiller --history-max 200

# Install wordpress on production environment
helm install --name wp-prod --namespace wp-prod -f template-wordpress_parameters-prod.yaml stable/wordpress

# Install wordpress on development environment
helm install --name wp-dev --namespace wp-dev -f template-wordpress_parameters-dev.yaml stable/wordpress
