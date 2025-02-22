resource "aws_route53_zone" "dst_hosted_zone" {
  name    = "dstranslator.cloud"
  comment = "Managed by Terraform"
}