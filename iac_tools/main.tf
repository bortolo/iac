module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-prova"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a"]
  public_subnets = ["10.0.1.0/24"]

  enable_ipv6 = true

  enable_nat_gateway = false
  single_nat_gateway = false

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  vpc_tags = {
    Name = "vpc-name"
  }
}