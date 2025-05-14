resource "aws_cloudwatch_metric_alarm" "CPUUtilization" {
  for_each =  { for k, v in var.dbs :  k => v if lookup(v,"alarms",true) != false } 

  alarm_name               = format("%s-%s-rds-CPUUtilization",var.project,each.value.dbname)
  alarm_description        = "High RDS CPU"
  metric_name              = "CPUUtilization"
  namespace                = "AWS/RDS"
  statistic                = "Average"
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  threshold                = lookup(each.value,"alarms_cpu_threshold",var.alarms_cpu_threshold) 
  period                   = lookup(each.value,"alarms_cpu_period",var.alarms_cpu_period) 
  evaluation_periods       = lookup(each.value,"alarms_cpu_evaluation",var.alarms_cpu_evaluation) 
  unit                     = "Percent"
  dimensions               = {"DBInstanceIdentifier"= aws_db_instance.db[each.key].id}
  alarm_actions            = each.value.alarms_actions_high # flatten([for topic in each.value.alarms_topics: data.terraform_remote_state.base.outputs.sns_topic_arns[topic]])
  ok_actions               = each.value.alarms_actions_high  
  datapoints_to_alarm      = 10
}

resource "aws_cloudwatch_metric_alarm" "FreeStorageSpace" {
  for_each =  { for k, v in var.dbs :  k => v if lookup(v,"alarms",true) != false } 
  
  alarm_name               = format("%s-%s-rds-FreeStorageSpace",var.project,each.value.dbname)
  alarm_description        = "High RDS disk usage"
  metric_name              = "FreeStorageSpace"
  namespace                = "AWS/RDS"
  statistic                = "Minimum"
  comparison_operator      = "LessThanOrEqualToThreshold"
  threshold                = lookup(each.value,"alarms_storageFree_threshold",var.alarms_storageFree_threshold) 
  period                   = lookup(each.value,"alarms_storageFree_period",var.alarms_storageFree_period) 
  evaluation_periods       = lookup(each.value,"alarms_storageFree_evaluation",var.alarms_storageFree_evaluation)  
  unit                     = "Bytes"
  dimensions               = {"DBInstanceIdentifier"= aws_db_instance.db[each.key].id}
  alarm_actions            = each.value.alarms_actions_high # flatten([for topic in each.value.alarms_topics: data.terraform_remote_state.base.outputs.sns_topic_arns[topic]])
  ok_actions               = each.value.alarms_actions_high  
  datapoints_to_alarm      = 2  
}

resource "aws_cloudwatch_metric_alarm" "FreeableMemory" {
  for_each =  { for k, v in var.dbs :  k => v if lookup(v,"alarms",true) != false } 
  
  alarm_name               = format("%s-%s-rds-FreeableMemory",var.project,each.value.dbname)
  alarm_description        = "Low RDS free mem"
  metric_name              = "FreeableMemory"
  namespace                = "AWS/RDS"
  statistic                = "Minimum"
  comparison_operator      = "LessThanOrEqualToThreshold"
  threshold                = lookup(each.value,"alarms_memFree_threshold",var.alarms_memFree_threshold) 
  period                   = lookup(each.value,"alarms_memFree_period",var.alarms_memFree_period) 
  evaluation_periods       = lookup(each.value,"alarms_memFree_evaluation",var.alarms_memFree_evaluation) 
  unit                     = "Bytes"
  dimensions               = {"DBInstanceIdentifier"= aws_db_instance.db[each.key].id}
  alarm_actions            = each.value.alarms_actions_critical # flatten([for topic in each.value.alarms_topics: data.terraform_remote_state.base.outputs.sns_topic_arns[topic]])
  ok_actions               = each.value.alarms_actions_critical  
  datapoints_to_alarm      = 2  
}

resource "aws_cloudwatch_metric_alarm" "DatabaseConnections" {
  for_each =  { for k, v in var.dbs :  k => v if lookup(v,"alarms",true) != false } 
  
  alarm_name               = format("%s-%s-rds-DatabaseConnections",var.project,each.value.dbname)
  alarm_description        = "DatabaseConnections"
  metric_name              = "DatabaseConnections"
  namespace                = "AWS/RDS"
  statistic                = "Average"
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  threshold                = lookup(each.value,"alarms_connections_threshold",var.alarms_connections_threshold) 
  period                   = lookup(each.value,"alarms_connections_period",var.alarms_connections_period) 
  evaluation_periods       = lookup(each.value,"alarms_connections_evaluation",var.alarms_connections_evaluation) 
  unit                     = "Count"
  dimensions               = {"DBInstanceIdentifier"= aws_db_instance.db[each.key].id}
  alarm_actions            = each.value.alarms_actions_high # flatten([for topic in each.value.alarms_topics: data.terraform_remote_state.base.outputs.sns_topic_arns[topic]])
  ok_actions               = each.value.alarms_actions_high  
  datapoints_to_alarm      = 2  
}

