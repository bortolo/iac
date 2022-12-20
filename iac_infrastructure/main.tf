resource "aws_subnet" "web" {
  vpc_id     = data.terraform_remote_state.iac_tools.outputs.vpc_id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "vpc-iac-infra-web"
    Owner = "andrea.bortolossi"
    Environment = "production"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.web.id
  route_table_id = data.terraform_remote_state.iac_tools.outputs.public_route_tables[0]
}


module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "security-group-web"
  description = "Security group for web instance"
  vpc_id      = data.terraform_remote_state.iac_tools.outputs.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp","http-80-tcp","all-icmp"]
  egress_rules        = ["all-all"]

}

module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami                         = "ami-0a261c0e5f51090b1"
  instance_type               = "t2.micro"
  availability_zone           = aws_subnet.web.availability_zone
  subnet_id                   = aws_subnet.web.id
  vpc_security_group_ids      = [module.security_group.security_group_id]
  associate_public_ip_address = true
    key_name                    = "ec2-key-pair"

  user_data_base64            = base64encode(file("./resources/userdata.txt"))
  user_data_replace_on_change = true

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      tags = {
        Name = "my-root-block"
      }
    },
  ]

  ebs_block_device = [
    {
      device_name = "/dev/sdf"
      volume_type = "gp3"
      volume_size = 5
      throughput  = 200
      encrypted   = false
    }
  ]

      tags = {
    Name = "web01"
    Owner = "andrea.bortolossi"
    Environment = "production"
    App = "web"
  }

}

resource "aws_subnet" "db" {
  vpc_id     = data.terraform_remote_state.iac_tools.outputs.vpc_id
  cidr_block = "10.0.12.0/24"

  tags = {
    Name = "vpc-iac-infra-db"
    Owner = "andrea.bortolossi"
    Environment = "production"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.db.id
  route_table_id = data.terraform_remote_state.iac_tools.outputs.private_route_tables[0]
}