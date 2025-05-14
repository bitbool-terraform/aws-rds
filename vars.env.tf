variable "aws_region" { default = "eu-west-1" }
variable "dbs" {}
variable "dbAdminPasswords" { type = map }
variable "users_vpn_range" {}
variable "systemenv" { default = "" }
variable "env_tag" { type = string}

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


variable "engine" { default = "postgres" }
variable "engine_version" { default = "14.12" }
variable "license_model" { default = "postgresql-license" }
variable "parameter_group_name" { default = "default.postgres14" }


variable "allocated_storage" { default = 30 }
variable "port" { default = "5432" }
variable "dbsize" {}

variable "dbname" {}
variable "dbAdminPassword" {}
variable "db_max_gb" {}
variable "storage_type" { default = "gp2" }
variable "iops" { default = null }
variable "dbAdmin" { default = "dba" }
variable "multi_az" { default = false }
variable "backup_tags" { default = {} }
variable "db_subnet_group_name" {}

variable "db_subnet_group_name" {}

variable "kms_key_id" {}


