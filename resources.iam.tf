data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "dbs_iam" {
  for_each =  var.db_iam_roles

  name               = format("rds-dbIAMAccess-%s-%s",var.db_name,each.key)
  path   = "/"

  
  policy= jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds-db:connect"
      ],
      "Resource": "${formatlist(format("arn:aws:rds-db:%s:%s:dbuser:%s/%%s",data.aws_region.current.region,data.aws_caller_identity.current.account_id,aws_db_instance.db[0].resource_id),each.value)}"
    }
  ]
} 

  )
}



# DO NOT DO THIS. Bind the policies outside
# locals {
#   iam_roles_db_users = merge(flatten([
#     for dbuser,values in var.db_iam_users: {
#       for iam_role in lookup(values,"iam_roles",[]): "${format("%s-%s",dbuser,iam_role)}" => {
#           iam_role = iam_role
#           dbuser = dbuser
#         }
#       }
#   ])...)

#   iam_users_db_users = merge(flatten([
#     for dbuser,values in var.db_iam_users: {
#       for iam_user in lookup(values,"iam_users",[]): "${format("%s-%s",dbuser,iam_user)}" => {
#           iam_user = iam_user
#           dbuser = dbuser
#         }
#       }
#   ])...)  
# }

# resource "aws_iam_role_policy_attachment" "dbs_iam_roles" {
#   for_each =  local.iam_roles_db_users

#   role       = each.value.iam_role
#   policy_arn = aws_iam_policy.dbs_iam[each.value.dbuser].arn
# }

# resource "aws_iam_user_policy_attachment" "dbs_iam_roles" {
#   for_each =  local.iam_users_db_users

#   user       = each.value.iam_user
#   policy_arn = aws_iam_policy.dbs_iam[each.value.dbuser].arn
# }

