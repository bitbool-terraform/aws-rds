resource "aws_db_instance" "db" {
  count = var.create_db ? 1 : 0

  deletion_protection = lookup(var.db,"deletion_protection",var.deletion_protection)
  license_model     = lookup(var.db,"license_model",var.license_model)
  engine            = lookup(var.db,"engine",var.engine)
  engine_version    = lookup(var.db,"engine_version",var.engine_version)
  instance_class    = var.db.instance_class
  allocated_storage = var.db.allocated_storage
  max_allocated_storage = var.db.db_max_gb

  storage_type = lookup(var.db,"storage_type",var.storage_type)
  iops = lookup(var.db,"iops",var.iops)
  storage_throughput = lookup(var.db,"storage_throughput",var.storage_throughput)

  db_name = replace(var.db_name,"-","_")
  identifier = var.db_name

  username = lookup(var.db,"dbAdmin",var.dbAdmin)

  password = var.dbAdminPassword
  manage_master_user_password = var.dbAdminPassword == null 
  port     = lookup(var.db,"port",var.port)

  #availability_zone = each.value.azs[0]
  multi_az = lookup(var.db,"multi_az",var.multi_az)
  vpc_security_group_ids = concat(aws_security_group.dbaccess_unmanaged.*.id,aws_security_group.dbaccess.*.id)
  publicly_accessible = lookup(var.db,"publicly_accessible",false)

  maintenance_window = "Mon:08:00-Mon:09:00"
  backup_window      = "03:00-05:00"

  # disable backups to create DB faster
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot = "false"

  copy_tags_to_snapshot = true
  tags = merge( {Name = var.db_name, TFModule = "aws-rds", AwsService = "rds"}, var.backup_tags , var.tags )


  # DB subnet group
  db_subnet_group_name = var.db_subnet_group_name

  # DB parameter group
  parameter_group_name = lookup(var.db,"parameter_group_name",var.parameter_group_name)
  allow_major_version_upgrade = false
  auto_minor_version_upgrade = true
  apply_immediately = true

  # Snapshot name upon DB deletion
  final_snapshot_identifier = format("%s-finalSnap",var.db_name)

  enabled_cloudwatch_logs_exports = ["postgresql","upgrade"]

  database_insights_mode = lookup(var.db,"database_insights_mode",var.database_insights_mode)
  monitoring_interval = lookup(var.db,"monitoring_interval",var.monitoring_interval)
  monitoring_role_arn = lookup(var.db,"monitoring_interval",var.monitoring_interval) > 0 ? aws_iam_role.rds_enhanced_monitoring[0].arn : null
  performance_insights_enabled = true
  performance_insights_kms_key_id = var.kms_key_id
  performance_insights_retention_period = 7
  iam_database_authentication_enabled = true
  
  storage_encrypted = true
  kms_key_id = var.kms_key_id
}



resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = var.create_db ? 1 : 0

  name        = format("%s-enhanced_monitoring",var.db_name)
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count = var.create_db ? 1 : 0

  role       = aws_iam_role.rds_enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
