base_workspace = "us1"
dbenv = "us1"
env_tag = "Production"

users_vpn_range = ["172.31.112.0/23","172.31.3.217/32"]

dbs = {
  "uni5saasus1" = {
    dbname = "us1"
    dbsize = "db.m5.xlarge"
    db_max_gb = 250
    multi_az = true
    alarms = true
    alarms_topics = ["main"]  
    backup = "comprinno"
    storage_type = "gp3"
    alarms_actions_high = ["arn:aws:sns:us-east-1:934743933529:hivecloud-alarms-High","arn:aws:sns:us-east-1:934743933529:uni5saas-us1-alarms-main"]
    alarms_actions_critical = ["arn:aws:sns:us-east-1:934743933529:hivecloud-alarms-Critical","arn:aws:sns:us-east-1:934743933529:uni5saas-us1-alarms-main"]
    alarms_cpu_evaluation = 10
    alarms_storageFree_threshold = 14000000000
    alarms_connections_threshold = 95
    alarms_memFree_threshold = 4000000000
  }      
}

