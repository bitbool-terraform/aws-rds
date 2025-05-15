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
      "Resource": "${formatlist(format("arn:aws:rds-db:%s:%s:dbuser:%s/%%s",data.aws_region.current.name,data.aws_caller_identity.current.account_id,aws_db_instance.db[0].resource_id),each.value)}"
    }
  ]
} 

  )
}
