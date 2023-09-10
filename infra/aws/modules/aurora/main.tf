# ---------------------------
# Aurora RDS Cluster
# ---------------------------
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "${var.app_name}-${var.environment}-aurora-cluster"
  engine                  = "aurora-mysql"
  database_name           = "${var.app_name}${var.environment}"
  master_username         = var.db_username
  master_password         = var.db_password
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  vpc_security_group_ids  = var.sg_ids
  db_subnet_group_name    = aws_db_subnet_group.aurora.name
  availability_zones      = [var.az_a, var.az_c]
}

resource "aws_rds_cluster_instance" "aurora_instance_1a" {
  identifier         = "${var.app_name}-${var.environment}-aurora-instance-1a"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = var.instance_class
  availability_zone  = var.az_a
  engine = "aurora-mysql"
}

resource "aws_rds_cluster_instance" "aurora_instance_1c" {
  identifier         = "${var.app_name}-${var.environment}-aurora-instance-1c"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = var.instance_class
  availability_zone  = var.az_c
  engine = "aurora-mysql"
}

# ---------------------------
# DB Subnet Group
# ---------------------------
resource "aws_db_subnet_group" "aurora" {
  name       = "${var.app_name}-${var.environment}-aurora-subnet-group"
  subnet_ids = var.pri2_sub_ids

  tags = {
    Name = "${var.app_name}-${var.environment}-aurora-subnet-group"
  }
}
