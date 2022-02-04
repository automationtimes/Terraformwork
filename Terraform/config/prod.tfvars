aws-region = "us-east-1"

vpc = {
  vpc-cidr             = "10.0.0.0/16"
  public-subnets-cidr  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.5.0/24"]
  private-subnets-cidr = ["10.0.3.0/24", "10.0.4.0/24"]
  name                 = "zprofile"
  env                  = "prod"
}