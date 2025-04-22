# this tf file deploys ExternalDNS so the custom host name can be used to access EcoStream
# when deploying an Ingress, we be able to specify a host name, and ExternalDNS will
# create DNS records in Route 53 on the fly when Ingresses are created

# use kubergrunt to get the thumbrint of the EKS cluster's OIDC Identity Provider
# the thumbpritn is a signature for the CA's certificate of the OIDC identity provider
# it is needed by AWS to verify trust with the IdP
# c.f. https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
# data "external" "thumb" {
#   program = ["kubergrunt", "eks", "oidc-thumbprint", "--issuer-url", module.eks.cluster_oidc_issuer_url]
# }

# resource "aws_iam_openid_connect_provider" "default" {
#   url             = module.eks.cluster_oidc_issuer_url
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.external.thumb.result.thumbprint]
# }

# install ExternalDNS - only if Route 53 zone ID is provided
module "eks-external-dns" {

  count = var.route_53_zone_id == "" ? 0 : 1

  source                           = "lablabs/eks-external-dns/aws"
  version                          = "1.2.0"
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  policy_allowed_zone_ids = [
    var.route_53_zone_id
  ]
  settings = {
    "policy" = "sync"
  }

  providers = {
    helm       = helm.eks
    kubernetes = kubernetes.eks
  }

  depends_on = [module.eks]
}
