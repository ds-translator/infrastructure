# Infrastructure with Terraform/Terragrunt

This repo contains the parameterized AWS infrastructure with EKS cluster and nodegroups.

We use Terragrunt to deploy DRY to dev-, prod- and stage-environments.

How to use:

    cd live/dev
    terragrunt plan
    terragrunt apply --auto-approve
    


