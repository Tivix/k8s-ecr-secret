#!/usr/bin/env bash

mkdir -p ~/.kube

if [ ! -z "$KUBE_CONFIG" ]; then
	if [[ $KUBE_CONFIG =~ ^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$ ]]; then
		echo "KUBE_CONFIG var seems to be base64 encoded - decoding..."
		echo -n "$KUBE_CONFIG" | base64 -d > ~/.kube/config
	else
		echo "Creating kubeconfig file..."
		echo -n "$KUBE_CONFIG" > ~/.kube/config
	fi
	chmod 600 ~/.kube/config
else
	echo "Missing KUBE_CONFIG variable."
	exit 1
fi