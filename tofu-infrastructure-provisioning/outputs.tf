# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "eks_oidc_provider_arn" {
  description = "ARN of the OIDC provider built in EKS ()"
  value       = module.eks.oidc_provider_arn
}
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca_cert" {
  description = "CA cert of the EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

# Debug
output "env_name" {
  description = "env_name variable"
  value       = var.env_name
}
