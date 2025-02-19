# Bootstrap Configuration for GitHub Actions OIDC Integration

This Terraform configuration sets up the foundational AWS IAM resources to enable GitHub Actions to assume roles securely via OIDC. It provisions:

- An OIDC provider for GitHub Actions.
- Three IAM roles (for dev, staging, and prod).
- Environment-specific IAM policies.
- Policy attachments for each role.

## Folder Structure

    bootstrap/ 
    ├── main.tf # Terraform configuration and provider setup 
    ├── oidc.tf # OIDC provider resource for GitHub Actions 
    ├── iam_roles.tf # IAM roles for each environment
    ├── iam_policies.tf # IAM policies and role policy attachments for each environment 
    ├── variables.tf # Variables used in the configuration 
    ├── outputs.tf # Outputs for resource ARNs 
    └── README.md # This readme file

## Usage

1. **Configure Variables:**
   - Set the `aws_region` in `variables.tf` (or override via CLI/TFVars).
   - Provide your GitHub repository (format: `org/repo`) as `github_repo`.

2. **Initialize Terraform:**

   ```bash
   terraform init

3. **Apply the Configuration:**

    ```bash
    terraform apply

This will provision the OIDC provider, roles, and policies required to allow GitHub Actions to assume the appropriate role for each environment using OIDC.


---

### How It Works

- **OIDC Provider:**  
  The `aws_iam_openid_connect_provider` resource creates the trust between AWS and GitHub Actions by registering `https://token.actions.githubusercontent.com`.

- **IAM Roles:**  
  For each environment defined in `local.environments`, an IAM role is created with a trust policy that allows GitHub Actions (based on token claims) to assume the role.

- **IAM Policies & Attachments:**  
  Each role gets its own policy (which you can customize per environment) attached via `aws_iam_role_policy_attachment`.

- **Variables & Outputs:**  
  Variables allow you to parameterize the configuration (e.g., region and GitHub repo), and outputs provide the created resource ARNs for reference.
