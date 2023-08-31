output "aurora_cluster_arn" {
  value       = aws_rds_cluster.aurora_cluster.arn
  description = "ARN of the Aurora Cluster"
}

output "aurora_cluster_endpoint" {
  value       = aws_rds_cluster.aurora_cluster.endpoint
  description = "Writer endpoint for the Aurora Cluster"
}

output "aurora_cluster_reader_endpoint" {
  value       = aws_rds_cluster.aurora_cluster.reader_endpoint
  description = "Reader endpoint for the Aurora Cluster"
}
