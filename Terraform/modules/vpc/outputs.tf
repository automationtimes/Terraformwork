output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnets" {
  value = aws_subnet.public_subnets.*.id
}
output "public_subnets_id" {
  value = aws_subnet.public_subnets[0].id
}

output "private_subnets" {
  value = aws_subnet.private_subnets.*.id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnets[0].id
}


