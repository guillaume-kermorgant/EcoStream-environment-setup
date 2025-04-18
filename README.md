# EcoStream environment setup

Terraform script to deploy EcoStream environment on the cloud.

## AWS Access

- the access key used by gitlab-ci and passed in to tofu via https://gitlab.com/gkermo/ecostream-environment-setup/-/settings/ci_cd#js-cicd-variables-settings are the ones of ecostream-gitlab-ci user in AWS.
That user belongs to the ecostream-admins group which has all the required permissions to deploy the infrastructure defined here.

## Docker images management

The OpenTofu image used in this pipeline is stored in gkermo/ecostream gitlab container registry, in order to avoid the existing pull rate limitation from docker hub.

Here is the process to follow in order to pull a gitlab-opentofu image from dockerhub and push it to gkermo/ecostream container registry.

```
docker pull --platform=linux/amd64 registry.gitlab.com/components/opentofu/gitlab-opentofu:1.1.0-opentofu1.9.0-alpine
docker save registry.gitlab.com/components/opentofu/gitlab-opentofu:1.1.0-opentofu1.9.0-alpine -o gitlab-opentofu:1.1.0-opentofu1.9.0-alpine-amd64.tar
docker load -i gitlab-opentofu:1.1.0-opentofu1.9.0-alpine-amd64.tar
docker tag registry.gitlab.com/components/opentofu/gitlab-opentofu:1.1.0-opentofu1.9.0-alpine registry.gitlab.com/gkermo/ecostream/opentofu/gitlab-opentofu:1.1.0-opentofu1.9.0-alpine-amd64
docker push registry.gitlab.com/gkermo/ecostream/opentofu/gitlab-opentofu:1.1.0-opentofu1.9.0-alpine-amd64
```
