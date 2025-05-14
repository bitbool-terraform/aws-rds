resource "aws_security_group" "dbaccess" {
  for_each =  { for k, v in var.dbs :  k => v if lookup(v,"enabled",true) != false } 

  name     = format("%s-rds-access-%s",var.project,each.value.dbname)
  vpc_id   = data.terraform_remote_state.base.outputs.vpc_id

  tags = merge(local.tags_module_sgs,{"rds" = each.value.dbname, "Name" = format("%s-rds-access-%s",var.project,each.value.dbname)})

  lifecycle { ignore_changes = [ingress,egress] }

}


resource "aws_security_group" "dbaccessViaSg" {
  for_each =  { for k, v in var.dbs :  k => v if lookup(v,"enabled",true) != false } 

  name     = format("%s-rds-dbaccessViaSg-%s",var.project,each.value.dbname)
  vpc_id   = data.terraform_remote_state.base.outputs.vpc_id

  tags = merge(local.tags_module_sgs,{"rds" = each.value.dbname, "Name" = format("%s-rds-dbaccessViaSg-%s",var.project,each.value.dbname)})

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = var.users_vpn_range
    description = "hivecloud vpn users"
  }

}