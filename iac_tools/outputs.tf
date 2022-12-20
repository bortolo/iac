output "public_ip" {
  value = module.ec2.public_ip
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "public_route_tables" {
  value = module.vpc.public_route_table_ids
}

output "private_route_tables" {
  value = module.vpc.private_route_table_ids
}

output "availability_zones" {
  value = module.vpc.azs
}