# Environment configuration with Ansible

The Ansible playbook in this directory configures the EKS cluster and deploys the Ecostream application.

## Prerequisites

- An EKS cluster must have been provisioned using the Tofu files from `../tofu-infrastructure-provisioning``
- install Ansible, if it is not already installed, following https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
- install required Ansible collections:
```
ansible-galaxy collection install community.aws
ansible-galaxy collection install kubernetes.core
```

## Run the playbook

Export the AWS access key ID and secret access key of the User that has been used to create the EKS cluster and run the Playbook:

```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION="eu-west-3"
export EKS_CLUSTER_NAME="ecostream-local-dev"
# you can add a comma separated list of ARNs here
export EKS_ADMINS_IAM_PRINCIPAL_ARN=""
ansible-playbook playbook.yml
```