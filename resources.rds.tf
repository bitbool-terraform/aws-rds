resource "aws_db_instance" "db" {

  deletion_protection = true
  license_model     = var.license_model
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.dbsize
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.db_max_gb

  storage_type = var.storage_type
  iops = var.iops

  db_name = format("%s_%s",var.project,var.dbname)
  identifier = format("%s-%s",var.project,var.dbname)

  username = var.dbAdmin

  password = var.dbAdminPassword
  port     = var.port

  #availability_zone = each.value.azs[0]
  multi_az = var.multi_az
  vpc_security_group_ids = [aws_security_group.dbaccessViaSg
  .id,aws_security_group.dbaccess.id]
  publicly_accessible = false

  maintenance_window = "Mon:08:00-Mon:09:00"
  backup_window      = "03:00-05:00"

  # disable backups to create DB faster
  backup_retention_period = 30
  skip_final_snapshot = "false"

  copy_tags_to_snapshot = true
  tags = merge( {Name = format("%s-%s",var.project,var.dbname)}, local.tags_module_rds, var.backup_tags )


  # DB subnet group
  db_subnet_group_name = var.db_subnet_group_name

  # DB parameter group
  parameter_group_name = var.parameter_group_name #aws_db_parameter_group.db[each.key].name #
  allow_major_version_upgrade = false
  auto_minor_version_upgrade = true
  apply_immediately = true

  # Snapshot name upon DB deletion
  final_snapshot_identifier = format("%s-%s-finalSnap",var.project,var.dbname)

  enabled_cloudwatch_logs_exports = ["postgresql","upgrade"]

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_interval > 0 ? aws_iam_role.rds_enhanced_monitoring.arn : null
  performance_insights_enabled = true
  performance_insights_kms_key_id = data.terraform_remote_state.base.outputs.kms_rds_key_arn
  performance_insights_retention_period = 7
  iam_database_authentication_enabled = true
  
  storage_encrypted = true
  kms_key_id = var.kms_key_id
}

# resource "aws_db_parameter_group" "db" {
#   for_each =  { for k, v in var.dbs :  k => v if lookup(v,"enabled",true) != false } 

#   name   = "uni5saaspostgres14"
#   family = "postgres14"

#   parameter {
#     name  = "encrypt.key"
#     value = "QXDqUZsdjLwZ33n9cRFL"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }



# // THE FOLLOWING REQUIRES THAT THE DB IS ACCESSIBLE FROM OUR HOST

# provider "postgresql" {
#   alias           = "db_dev"
#   host            = aws_db_instance.db.address
#   port            = aws_db_instance.db.port
#   database        = "postgres"
#   username        = var.dbAdminUser
#   password        = local.dbAdminPass
#   sslmode         = "require"
#   connect_timeout = 15
#   superuser = false
# }

# resource "postgresql_role" "appuser" {
#   for_each =  { for k, v in var.app_envs :  k => v if lookup(v,"apps_api",true) != false }

#   provider = postgresql.db_dev
#   name     = "${var.dbAppUserPrefix}${each.value.name}"
#   login    = true
#   password = local.dbAppPass[each.key]
#   depends_on = [
#    aws_db_instance.db
#   ]  
# }

# resource "postgresql_grant_role" "grant_app" {
#   for_each =  { for k, v in var.app_envs :  k => v if lookup(v,"apps_api",true) != false }

#   provider = postgresql.db_dev
#   role              = var.dbAdminUser
#   grant_role        = "${var.dbAppUserPrefix}${each.value.name}"
#   with_admin_option = true
#   depends_on = [
#    postgresql_role.appuser
#   ]
# }

# resource "postgresql_database" "appdb" {
#   for_each =  { for k, v in var.app_envs :  k => v if lookup(v,"apps_api",true) != false }

#   provider = postgresql.db_dev
#   name     = "${var.dbAppUserPrefix}${each.value.name}"
#   owner    = "${var.dbAppUserPrefix}${each.value.name}"
#   depends_on = [
#     postgresql_grant_role.grant_app
#   ]
# }

# resource "postgresql_role" "paymentsuser" {
#   for_each =  { for k, v in var.app_envs :  k => v if lookup(v,"apps_paymentsapi",false) != false }

#   provider = postgresql.db_dev
#   name     = "${var.dbPaymentsUserPrefix}${each.value.name}"
#   login    = true
#   password = local.dbPaymentsPass[each.key]
#   depends_on = [
#    aws_db_instance.db
#   ]  
# }

# resource "postgresql_grant_role" "grant_payments" {
#   for_each =  { for k, v in var.app_envs :  k => v if lookup(v,"apps_paymentsapi",false) != false }

#   provider = postgresql.db_dev
#   role              = var.dbAdminUser
#   grant_role        = "${var.dbPaymentsUserPrefix}${each.value.name}"
#   with_admin_option = true
#   depends_on = [
#    postgresql_role.paymentsuser
#   ]
# }

# resource "postgresql_database" "paymentsdb" {
#   for_each =  { for k, v in var.app_envs :  k => v if lookup(v,"apps_paymentsapi",false) != false }

#   provider = postgresql.db_dev
#   name     = "${var.dbPaymentsUserPrefix}${each.value.name}"
#   owner    = "${var.dbPaymentsUserPrefix}${each.value.name}"
#   depends_on = [
#     postgresql_grant_role.grant_app
#   ]
# }


resource "aws_iam_role" "rds_enhanced_monitoring" {
  name        = format("%s%s-enhanced_monitoring",var.project,var.systemenv)
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
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
