resource "aws_cloudwatch_metric_alarm" "CPUUtilization" {
  count = var.create_alarms ? 1 : 0

  alarm_name               = format("%s-rds-CPUUtilization",var.db_name)
  alarm_description        = "High RDS CPU"
  metric_name              = "CPUUtilization"
  namespace                = "AWS/RDS"
  statistic                = "Average"
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  threshold                = lookup(var.db,"alarms_cpu_threshold",var.alarms_cpu_threshold) 
  period                   = lookup(var.db,"alarms_cpu_period",var.alarms_cpu_period) 
  evaluation_periods       = lookup(var.db,"alarms_cpu_evaluation",var.alarms_cpu_evaluation) 
  unit                     = "Percent"
  dimensions               = {"DBInstanceIdentifier"= aws_db_instance.db[0].identifier}
  alarm_actions            = var.alarms_actions 
  ok_actions               = var.alarms_actions  
  datapoints_to_alarm      = 2
}

resource "aws_cloudwatch_metric_alarm" "FreeStorageSpace" {
  count = var.create_alarms ? 1 : 0
  
  alarm_name               = format("%s-rds-FreeStorageSpace",var.db_name)
  alarm_description        = "High RDS disk usage"
  metric_name              = "FreeStorageSpace"
  namespace                = "AWS/RDS"
  statistic                = "Minimum"
  comparison_operator      = "LessThanOrEqualToThreshold"
  threshold                = lookup(var.db,"alarms_storageFree_threshold",var.alarms_storageFree_threshold) 
  period                   = lookup(var.db,"alarms_storageFree_period",var.alarms_storageFree_period) 
  evaluation_periods       = lookup(var.db,"alarms_storageFree_evaluation",var.alarms_storageFree_evaluation)  
  unit                     = "Bytes"
  dimensions               = {"DBInstanceIdentifier"= aws_db_instance.db[0].identifier}
  alarm_actions            = var.alarms_actions 
  ok_actions               = var.alarms_actions  
  datapoints_to_alarm      = 2  
}

resource "aws_cloudwatch_metric_alarm" "FreeableMemory" {
  count = var.create_alarms ? 1 : 0
  
  alarm_name               = format("%s-rds-FreeableMemory",var.db_name)
  alarm_description        = "Low RDS free mem"
  metric_name              = "FreeableMemory"
  namespace                = "AWS/RDS"
  statistic                = "Minimum"
  comparison_operator      = "LessThanOrEqualToThreshold"
  threshold                = lookup(var.db,"alarms_memFree_threshold",var.alarms_memFree_threshold) 
  period                   = lookup(var.db,"alarms_memFree_period",var.alarms_memFree_period) 
  evaluation_periods       = lookup(var.db,"alarms_memFree_evaluation",var.alarms_memFree_evaluation) 
  unit                     = "Bytes"
  dimensions               = {"DBInstanceIdentifier"= aws_db_instance.db[0].identifier}
  alarm_actions            = var.alarms_actions 
  ok_actions               = var.alarms_actions  
  datapoints_to_alarm      = 2  
}

resource "aws_cloudwatch_metric_alarm" "DatabaseConnections" {
  count = var.create_alarms ? 1 : 0
  
  alarm_name               = format("%s-rds-DatabaseConnections",var.db_name)
  alarm_description        = "DatabaseConnections"
  metric_name              = "DatabaseConnections"
  namespace                = "AWS/RDS"
  statistic                = "Average"
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  threshold                = lookup(var.db,"alarms_connections_threshold",var.alarms_connections_threshold) 
  period                   = lookup(var.db,"alarms_connections_period",var.alarms_connections_period) 
  evaluation_periods       = lookup(var.db,"alarms_connections_evaluation",var.alarms_connections_evaluation) 
  unit                     = "Count"
  dimensions               = {"DBInstanceIdentifier"= aws_db_instance.db[0].identifier}
  alarm_actions            = var.alarms_actions 
  ok_actions               = var.alarms_actions  
  datapoints_to_alarm      = 2  
}

