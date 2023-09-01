output "aurora_vpc_endpoint_id" {
  description = "The ID of the VPC Endpoint for Aurora"
  value       = aws_vpc_endpoint.aurora.id
}
