#variable "aws_region" { default = "eu-west-1" }
variable "db" {}
variable "db_name" {}


variable "create_db" { default = true }
variable "create_sgs" { default = true }
variable "create_alarms" { default = true }

variable "dbAdminPassword" { default = null }
#variable "users_vpn_range" {}
#variable "systemenv" { default = "" }
#variable "env_tag" { type = string}

#variable "alarms" { type = map }

variable "alarms_actions" { default = [] }

variable "alarms_cpu_period" { default = 60 }
variable "alarms_cpu_evaluation" { default = 2 }
variable "alarms_cpu_threshold" { default = 80 }

variable "alarms_storageFree_period" { default = 60 }
variable "alarms_storageFree_evaluation" { default = 2 }
variable "alarms_storageFree_threshold" { default = 80 }

variable "alarms_memFree_period" { default = 60 }
variable "alarms_memFree_evaluation" { default = 2 }
variable "alarms_memFree_threshold" { default = 80 }

variable "alarms_connections_period" { default = 60 }
variable "alarms_connections_evaluation" { default = 2 }
variable "alarms_connections_threshold" { default = 30 }

variable "monitoring_interval" { default = 60 }
variable "database_insights_mode" { default = null }
variable "deletion_protection" { default = true }

variable "engine" { default = "postgres" }
variable "engine_version" {}
variable "license_model" { default = "postgresql-license" }
variable "parameter_group_name" { default = null }


variable "allocated_storage" { default = 30 }
variable "port" { default = "5432" }
# variable "dbsize" {}

# variable "dbname" {}
# variable "dbAdminPassword" {}
# variable "db_max_gb" {}
variable "storage_type" { default = "gp3" }
variable "iops" { default = null }
variable "storage_throughput" { default = null }
variable "dbAdmin" { default = "dba" }
variable "multi_az" { default = false }

variable "backup_tags" { default = {} }
variable "tags" { default = {} }

variable "vpc_id" {}
variable "db_subnet_group_name" {}
variable "security_group_source_ranges" { default = []}
variable "security_group_source_sgs" {default = []}

variable "kms_key_id" {}

variable "db_iam_roles" { default = {} }


