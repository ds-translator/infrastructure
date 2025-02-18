# Infrastructure with Terraform/Terragrunt

This repo contains the parameterized AWS infrastructure with EKS cluster and nodegroups.

We use Terragrunt to deploy DRY to dev-, prod- and stage-environments.

How to use:

1. Apply the creation of DevOps-group and users and IAM role for cluster administration.
2. Apply the infrastructure in dev/stage/prod

To view the changes run:
`cd ./live/dev`
`terragrunt run-all plan --terragrunt-exclude-dir=alb`
The `alb`-module requires an existing kubernetes cluster, so it will fail during plan.

To apply all modules run:
`cd ./live/dev`
`terragrunt run-all apply --auto-approve`

`terragrunt run-all init -reconfigure --terragrunt-exclude-dir=alb

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

