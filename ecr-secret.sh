#!/bin/bash

if [ -z ${ACCOUNT} ]; then
	echo "No ACCOUNT provided, trying to guess one..."
	ACCOUNT=$(aws sts get-caller-identity --query 'Account' --output text 2>&1) || {
		echo -e "\nCouldn't locate credentials. No API keys provided. Exiting...";
		exit 1;
	}
else
	ACCOUNT=${ACCOUNT}
fi

if [ -z ${REGION} ]; then
	echo "No REGION provided. Using default one: us-west-1"
	REGION=us-west-1
else
	REGION=${REGION}
fi

if [ -z ${SECRET_NAME} ]; then
	echo "No SECRET_NAME provided. Creating default one: ecr-registry-credentials"
	SECRET_NAME=ecr-registry-credentials
else
	SECRET_NAME=${SECRET_NAME}
fi

if [ -z ${NS} ]; then
	echo "No NAMESPACE provided. Using default"
	NS=default
else
	NS=${NS}
fi

echo -e "\nSetting ecr secrets for values:\n"
echo "ACCOUNT: ${ACCOUNT}"
echo "REGION: ${REGION}"
echo "SECRET_NAME: ${SECRET_NAME}"

DOCKER_REGISTRY_SERVER=https://${ACCOUNT}.dkr.ecr.${REGION}.amazonaws.com
DOCKER_USER=AWS
DOCKER_PASSWORD=`aws ecr get-login-password --region ${REGION} 2>&1`  || {
	echo -e "\nCouldn't get ecr password for account ${ACCOUNT}. Probably missing API KEYs or instance not authorized to assume role for ECR. Exiting...";
	exit 1;
}

parse-kube-config.sh

kubectl -n ${NS} delete secret ${SECRET_NAME} || true
kubectl -n ${NS} create secret docker-registry ${SECRET_NAME} \
	--docker-server=$DOCKER_REGISTRY_SERVER \
	--docker-username=$DOCKER_USER \
	--docker-password=$DOCKER_PASSWORD \
	--docker-email=no@email.local
kubectl -n ${NS} patch serviceaccount default -p '{"imagePullSecrets":[{"name":"${SECRET_NAME}"}]}'

