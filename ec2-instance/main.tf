provider "aws" {
  region = "eu-central-1"
}
resource "aws_instance" "example" {
  ami           = "ami-07eef52105e8a2059"
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }
}