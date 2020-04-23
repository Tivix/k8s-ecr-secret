k8s-ecr-secret
==============

# Overview

Purpose of this image is to create `docker-registry` type of kubernetes secret for ECR based docker registry. Image can be use for initial secret creation or as part of cronJob as ECR tokens happens to invalidate themself after 12 hrs.

to generate secret it uses:
    - aws cli to get password
    - script to parse kubeconfig pass as variable
    - kubectl to delete/create secret

# Usage

  - `docker build -t k8s-ecr-secret .`
  - `docker run -it --rm=true [-e vars] k8s-ecr-secret`

## Variables

  - ACCOUNT=aws_account_number
  -	REGION=us-west-1
  -	SECRET_NAME=ecr-registry-credentials
  -	AWS_ACCESS_KEY_ID=
  -	AWS_SECRET_ACCESS_KEY=
  -	KUBE_CONFIG=

where:

**KUBE_CONFIG** is complete kubeconfig file and it is assumed to be base64 encrypted. In case of Github Actions usage it can be put stright into github secrets without encoding.

**ACCOUNT** can be ommited if `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are provided

**AWS_ACCESS_KEY_ID** and **AWS_SECRET_ACCESS_KEY** can be ommited if run on EC2 instance authorized to assume role with ECR access policy. In that case `ACCOUNT` has to be provided.

