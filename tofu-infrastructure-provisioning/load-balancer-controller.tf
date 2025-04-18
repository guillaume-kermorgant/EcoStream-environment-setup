# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# The following module:
## - creates an IAM role that can be assumed by a specific K8S ServiceAccount (aws-load-balancer-controller in kube-system namespace)
## - attaches the right IAM permissions so this SA can manage an AWS ALB (Application Load Balancer)
## - configure the trust policy (it tells AWS "you can trust this OIDC provider" the OIDC provider is the one associated with the EKS cluster)
## This ServiceAccount will then be used by AWS Load Balancer Controller to manager AWS ALB
module "lb_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${local.cluster_name}_eks_lb"
  attach_load_balancer_controller_policy = true

  # enable OIDC trust (heart of IRSA, IAM roles for service accounts)
  # this tells AWS to 
  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

# Here we deploy the ServiceAccount that will be used by AWS Load Balancer Controller
resource "kubernetes_service_account" "service-account" {

  provider = kubernetes.eks

  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
        "app.kubernetes.io/name"= "aws-load-balancer-controller"
        "app.kubernetes.io/component"= "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

# And finally, we deploy AWS Load Balancer Controller using a helm chart provided by AWS
resource "helm_release" "lb" {

  provider = helm.eks

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.service-account
  ]

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  # Use the right image for your region https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.eu-west-3.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }
}