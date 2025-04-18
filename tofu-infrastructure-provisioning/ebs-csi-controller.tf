# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# This module:
## - creates an IAM role that can be assumed by a specific K8S ServiceAccount (ebs-csi-controller-sa in kube-system namespace)
## - attaches the right IAM permissions so this ServiceAccount can manage EBS volumes
## This ServiceAccount will be used by the EBS CSI driver to manage volumes
module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.54.1"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}