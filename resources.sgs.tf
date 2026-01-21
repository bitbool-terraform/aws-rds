resource "aws_security_group" "dbaccess_unmanaged" {
  count       = var.create_sgs ? 1 : 0

  name        = format("rds-%s-access-unmanaged",var.db_name)
  description = "you can freely add entries for access to rds here. This is created by TF but the rules are not managed by TF"
  vpc_id      = var.vpc_id

  tags        = merge({ TFModule = "aws-rds", "rds" = var.db_name, "Name" = format("rds-%s-access-unmanaged",var.db_name)})

  lifecycle { ignore_changes = [ingress,egress] }

}

resource "aws_security_group" "grant_db_access" {
  count = var.create_sgs ? 1 : 0

  name        = format("rds-%s-access-granted",var.db_name)
  description = "resources with this sg assigned are granted access to the database. No rules here"
  vpc_id      = var.vpc_id

  tags        = merge({ TFModule = "aws-rds", "rds" = var.db_name, "Name" = format("rds-%s-access-granted",var.db_name)})

}



resource "aws_security_group" "dbaccess" {
  count = var.create_sgs ? 1 : 0

  name     = format("rds-%s-access",var.db_name)
  vpc_id   = var.vpc_id

  tags = merge({ TFModule = "aws-rds", "rds" = var.db_name, "Name" = format("rds-%s-access",var.db_name)})

  dynamic "ingress" {
    for_each = var.security_group_source_ranges
    content {
      from_port = lookup(var.db,"port",var.port)
      to_port   = lookup(var.db,"port",var.port)
      protocol  = "tcp"

      cidr_blocks = ingress.value
      description = "acess from module source ranges"
    }
  }

  dynamic "ingress" {
    for_each = var.security_group_source_sgs
    content {
      from_port = lookup(var.db,"port",var.port)
      to_port   = lookup(var.db,"port",var.port)
      protocol  = "tcp"

      security_groups = [ingress.value]
      description = "acess from module"
    }
  }

  ingress {
    from_port = lookup(var.db,"port",var.port)
    to_port   = lookup(var.db,"port",var.port)
    protocol  = "tcp"

    security_groups = aws_security_group.grant_db_access.*.id
    description = "acess from module"
  }

}