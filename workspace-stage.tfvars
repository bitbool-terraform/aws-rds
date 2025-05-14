base_workspace = "stage"
env_tag = "stage"

users_vpn_range = ["10.50.112.0/23","10.50.45.211/32","10.70.1.255/32"]

dbs = {
  "uni5saasdev1" = {
    dbname = "dev1"
    dbsize = "db.t4g.small"
    db_max_gb = 200
    multi_az = false  
    backup = "none"
    alarms = false
    alarms_topics = ["main"]    
    backup = "comprinno"      
  }
  "uni5saasstg1" = {
    dbname = "stg1"
    dbsize = "db.t4g.small"
    db_max_gb = 200
    multi_az = false
    backup = "none"
    alarms = false
    alarms_topics = ["main"]      
    backup = "comprinno"      
  }      
}

