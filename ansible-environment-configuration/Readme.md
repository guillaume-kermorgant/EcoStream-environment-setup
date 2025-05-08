# Environment configuration with Ansible

The Ansible playbook in this directory configures the EKS cluster and deploys the Ecostream application.

## Prerequisites

- an EKS cluster must have been provisioned using the Tofu files from `../tofu-infrastructure-provisioning`
- you must have a custom host name


## Run the Playbook

- export the AWS access key ID and secret access key of the User that has been used to create the EKS cluster:

```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION="eu-west-3"
export ENV_NAME="dev"
export ECOSTREAM_NAMESPACE="ecostream"
# you can add a comma separated list of ARNs here if you need to provide access to multiple ARNs
export EKS_ADMINS_IAM_PRINCIPAL_ARN=""
# [now required for ArgoCD] custom host name used to access ArgoCD, it must be registered in Route 53 and have a certificate in AWS ACM
export ECOSTREAM_HOSTNAME=""
# you need to provide a deploy token for ArgoCD to access the gitops repository, c.f. https://argo-cd.readthedocs.io/en/release-1.8/user-guide/private-repositories/
export GITLAB_USERNAME=""
export GITLAB_TOKEN=""
```
xR
- install Ansible, if it is not already installed, following https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

- install required Ansible collections:

```
ansible-galaxy collection install community.aws
ansible-galaxy collection install kubernetes.core
```

- run the playbook:

```
ansible-playbook playbook.yml
```