# EcoStream environment setup


This repository contains resources that helps deploying EcoStream on the cloud.
There are two main directories here:
- tofu-infrastructure-provisioning which contains Open Tofu (Terraform) configuration files that allows deploying an EKS Cluster and corresponding resources to AWS
- ansible-environment-configuration which contains an Ansible playbook that finishes configuring the environment and deploys EcoStream to the EKS cluster

## AWS Access

- the access key used by gitlab-ci and passed in to tofu via https://gitlab.com/gkermo/ecostream-environment-setup/-/settings/ci_cd#js-cicd-variables-settings are the ones of ecostream-gitlab-ci user in AWS.
That user belongs to the ecostream-admins group which has all the required permissions to deploy the infrastructure defined here.
