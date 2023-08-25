output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the created VPC"
}

output "subnet_pub_1a_id" {
  value       = aws_subnet.pub_1a.id
  description = "ID of the first created public subnet in AZ 1a"
}

output "subnet_pub_1c_id" {
  value       = aws_subnet.pub_1c.id
  description = "ID of the first created public subnet in AZ 1c"
}

output "subnet_pri1_1a_id" {
  value       = aws_subnet.pri1_1a.id
  description = "ID of the first created private subnet in AZ 1a"
}

output "subnet_pri2_1a_id" {
  value       = aws_subnet.pri2_1a.id
  description = "ID of the second created private subnet in AZ 1a"
}

output "subnet_pri1_1c_id" {
  value       = aws_subnet.pri1_1c.id
  description = "ID of the first created private subnet in AZ 1c"
}

output "subnet_pri2_1c_id" {
  value       = aws_subnet.pri2_1c.id
  description = "ID of the second created private subnet in AZ 1c"
}
