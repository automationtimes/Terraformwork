
# Internet VPC
####################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${terraform.workspace}-${var.vpc.name}"
  }
}
resource "aws_internet_gateway" "vpc-gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${terraform.workspace}-${var.vpc.name}-gw"
  }
}

