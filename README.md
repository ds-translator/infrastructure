# Infrastructure with Terraform/Terragrunt

This repo contains the parameterized AWS infrastructure with EKS cluster and nodegroups.

We use Terragrunt to deploy DRY to dev-, prod- and stage-environments.

How to use:

1. Apply the creation of group and users and IAM roles/policies for cluster administration with your admin or bootstrap account.
2. Apply the infrastructure in dev/stage/prod

To view the changes run:

    cd ./live/dev
    terragrunt run-all init -reconfigure --terragrunt-exclude-dir=alb
    terragrunt run-all plan --terragrunt-exclude-dir=alb

The `alb`-module requires an existing kubernetes cluster, so it will fail during plan. You should install it afterwards.

To apply all modules run:

    cd ./live/dev
    terragrunt run-all apply -auto-approve

# Notes

It seems that the AWS sandbox does not permit KMS creation.
If we use `create_kms_key = false` then we have to provide our own key ARN
As this project is for educational purposes only we omit encryption by setting `cluster_encryption_config = {}` in the eks module.

# Least privilege policy with iamlive
# OIDC Proxy Issue with Terraform

When running Terraform with a proxy (e.g., using **iamlive** with proxy), the **tls_certificate** data source may fail to verify the certificate from the EKS OIDC endpoint. This occurs because HTTPS requests are forwarded via the proxy, which presents a self-signed certificate that isn’t trusted.

Terraform’s **tls_certificate** data source retrieves the certificate from the URL provided by:

```hcl
data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer

Solutions:

`export NO_PROXY=oidc.eks.RE-GION-1.amazonaws.com

or

    data "tls_certificate" "cluster" {
    url          = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
    verify_chain = false
    }

or 

    provider "tls" {
    proxy {
        from_env = false
    }
    }

