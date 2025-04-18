# Deploy EcoStream infrastructure

This directory contains Terraform/Tofu configurations files to deploy the AWS resources required to run EcoStream:
- an AWS EKS cluster and all associated resources (VPC, subnets, NAT gateways, Load Balancer etc..)
- TODO: a Route 53 to access the cluster
- TODO: an AWS WAF resource (Web Application Firewall) and AWS Firewal Manager (?)

This script can be integrated into a CI/CD pipeline.

The configuration files are based on the following tutorial from Terraform website: [Provision an EKS cluster (AWS)](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks). The code samples provided in this tutorial are licensed under MPL 2.0 which allow modificaton and redistribution of the original code, but only under the condition that users make the entire program available under the same license, that's why we are keeping the same license here.

## Run locally

### Prerequisites

The AWS user you are going to use to create the EKS cluster needs a few permissions.

Here are the permissions we provided to our AWS user when testing the tofu script.

Please note that we attach too many permissions here so it does comply with the "principle of least privilege". We need to rework the set of permissions to provide the required ones only.

- following standard policies:

```
AmazonEKS_CNI_Policy
AmazonEKSClusterPolicy
AmazonEKSServicePolicy
AmazonVPCFullAccess
IAMFullAccess
```

- custom policy
```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"eks:ListEksAnywhereSubscriptions",
				"kms:GenerateRandom",
				"logs:*",
				"ec2:DescribeAddressesAttribute",
				"kms:DescribeCustomKeyStores",
				"kms:DeleteCustomKeyStore",
				"kms:UpdateCustomKeyStore",
				"kms:CreateKey",
				"eks:CreateEksAnywhereSubscription",
				"eks:DescribeAddonVersions",
				"kms:ConnectCustomKeyStore",
				"eks:CreateCluster",
				"ec2:DeleteLaunchTemplate",
				"eks:DescribeAddonConfiguration",
				"kms:ListRetirableGrants",
				"ec2:DescribeLaunchTemplates",
				"ec2:DescribeLaunchTemplateVersions",
				"ec2:RunInstances",
				"logs:TagResource",
				"logs:CreateLogGroup",
				"eks:RegisterCluster",
				"kms:CreateCustomKeyStore",
				"kms:ListKeys",
				"eks:DescribeClusterVersions",
				"ec2:CreateLaunchTemplate",
				"kms:ListAliases",
				"kms:DisconnectCustomKeyStore",
				"eks:ListAccessPolicies",
				"eks:ListClusters"
			],
			"Resource": "*"
		},
		{
			"Sid": "VisualEditor1",
			"Effect": "Allow",
			"Action": "kms:TagResource",
			"Resource": [
				"arn:aws:kms:*:531920760589:alias/*",
				"arn:aws:kms:*:531920760589:key/*"
			]
		},
		{
			"Sid": "VisualEditor2",
			"Effect": "Allow",
			"Action": "eks:*",
			"Resource": [
				"arn:aws:eks:*:531920760589:eks-anywhere-subscription/*",
				"arn:aws:eks:*:531920760589:nodegroup/*/*/*",
				"arn:aws:eks:*:531920760589:podidentityassociation/*/*",
				"arn:aws:eks:*:531920760589:access-entry/*/*/*/*/*",
				"arn:aws:eks:*:531920760589:cluster/*",
				"arn:aws:eks:*:531920760589:identityproviderconfig/*/*/*/*",
				"arn:aws:eks:*:531920760589:addon/*/*/*",
				"arn:aws:eks:*:531920760589:fargateprofile/*/*/*"
			]
		},
		{
			"Sid": "VisualEditor3",
			"Effect": "Allow",
			"Action": "kms:*",
			"Resource": [
				"arn:aws:kms:*:531920760589:alias/*",
				"arn:aws:kms:*:531920760589:key/*"
			]
		}
	]
}
```

### Deploy the EKS cluster and other required resources

- apply the tofu configuration files

```
# create a tofu.tfvars file to set your AWS access key ID and secret access key
# and optionnally a few other values
cat > tofu.tfvars <<EOF
AWS_ACCESS_KEY_ID     = ""
AWS_SECRET_ACCESS_KEY = ""
aws_region            = "eu-west-3"
env_name              = "local-dev"
EOF
# run 
tofu init
tofu apply -var-file="tofu.tfvars"
```

- Wait for the resources to be created, you should see the following message (with different values for cluster_endpoint and cluster_security_group_id) when it's done:

```
Apply complete! Resources: 62 added, 0 changed, 0 destroyed.

Outputs:

aws_region = "eu-west-3"
cluster_endpoint = "https://03AC57322BA72D2A6C5C4BAA34A8CCFE.gr7.eu-west-3.eks.amazonaws.com"
cluster_name = "ecostream-local-dev"
cluster_security_group_id = "sg-0b4a2065d80442fa3"
env_name = "local-dev"
```

- update kubeconfig file with your cluster information:

```
# export IAM User access key id  and secret access key, same values as in tofu.tfvars
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_REGION=eu-west-3
# check used identity
aws sts get-caller-identity
{
    "UserId": "AIDKKEPRRLQXFNUSEY",
    "Account": "59384857489",
    "Arn": "arn:aws:iam::59384857489:user/ecostream-user"
}
aws eks update-kubeconfig --region eu-west-3 --name ecostream-local-dev
# check access to the EKS cluster with kubectl
kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   172.20.0.1   <none>        443/TCP   5m
```

### Provide other Users access to the cluster

TODO: create an Ansible playbook to handle these steps

**[DEPRECATED]** ~~You can modify the `aws-auth` ConfigMap from the `kube-system` namespace to provide IAM Users or Roles with access to the EKS cluster.~~

Using the `aws-auth` ConfigMap is deprecated now, we must use EKS access entries to grant users access to the EKS cluster.
Ref: https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html.

In this example, we create an EKS access entry for the AWSReservedSSO_AdministratorAccess_76056229cd03f2ac IAM Role, which is the role assumed by our IAM Identity Center admin users.

As we are going to create a STANDARD access type and we want the IAM Role to have access to Kubernetes objects on the cluster, we must create Kubernetes RBAC objects.

Here we grant full administrator access to the EKS Cluster. We could have used the existing cluster-admin ClusterRole, but we define a custom one which is very much the same, for the sake of modifying it later if necessary.
We create a corresponding ClusterRoleBinding to bind the ClusterRole to the EcostreamAdmins Group that we will add the IAM Role to in the next steps.

```
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: ecostream-cluster-admin
rules:
- apiGroups:
  - '*'
  resources:
  - '*'
  verbs:
  - '*'
- nonResourceURLs:
  - '*'
  verbs:
  - '*'
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ecostream-admins-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ecostream-cluster-admin
subjects:
- kind: Group
  name: EcostreamAdmins
  apiGroup: rbac.authorization.k8s.io
EOF
```

- run the following command to create a STANDARD access entry for an IAM Role or an IAM User (replace the ARN of our IAM principal with yours):

```
aws eks create-access-entry \
    --cluster-name ecostream-local-dev \
    --principal-arn arn:aws:iam::531920760589:role/aws-reserved/sso.amazonaws.com/eu-west-3/AWSReservedSSO_AdministratorAccess_76056229cd03f2ac \
    --type STANDARD \
    --user EcostreamAdmins \
    --kubernetes-groups EcostreamAdmins
```

- now try to access the EKS cluster resources using your IAM Identity Center User:

```
aws configure sso
...
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""
kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   172.20.0.1   <none>        443/TCP   20m
```


### Destroy the environment

- in order to destroy every resources that were deployed by tofu, run:

```
tofu destroy -var-file="tofu.tfvars"
```