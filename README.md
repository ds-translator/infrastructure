# Infrastructure with Terraform/Terragrunt

This repo contains the parameterized AWS infrastructure with EKS cluster and nodegroups.

We use Terragrunt to deploy DRY to dev-, prod- and stage-environments.

How to use:

1. Apply the creation of DevOps-group and users and IAM role for cluster administration.
2. Apply the infrastructure in dev/stage/prod

To view the changes run:
`cd ./live/dev`
`terragrunt plan --terragrunt-exclude-dir=alb`
The `alb`-module requires an existing kubernetes cluster, so it will fail during plan.

To apply all modules run:
`cd ./live/dev`
`terragrunt run-all apply --auto-approve`
