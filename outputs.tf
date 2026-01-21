output "db" {
 value = aws_db_instance.db[0]
}

output "sg_unmanaged" {
 value = aws_security_group.dbaccess_unmanaged[0]
}


output "master_password_secret_arn" {
  value = aws_db_instance.db[0].master_user_secret 
}

output "master_username" {
  value = aws_db_instance.db[0].username
}

output "db_address" {
  value = aws_db_instance.db[0].address
}

output "db_iam_policies" {
  value = { for k,v in var.db_iam_roles: k=>aws_iam_policy.dbs_iam[k].arn }
}