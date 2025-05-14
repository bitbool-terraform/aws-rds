output "db" {
 value = aws_db_instance.db[0]
}

output "sg_unmanaged" {
 value = aws_security_group.dbaccess_unmanaged[0]
}


