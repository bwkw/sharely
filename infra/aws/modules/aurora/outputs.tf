output "aurora_cluster_arn" {
  description = "ARN of the Aurora Cluster"
  value       = aws_rds_cluster.aurora.arn
}

output "aurora_cluster_endpoint" {
  description = "Writer endpoint for the Aurora Cluster"
  value       = aws_rds_cluster.aurora.endpoint
}

output "aurora_cluster_reader_endpoint" {
  description = "Reader endpoint for the Aurora Cluster"
  value       = aws_rds_cluster.aurora.reader_endpoint
}
