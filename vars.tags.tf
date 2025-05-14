locals {

  tags_module_aws_instance = { TFModule = "aws_instance" }
  tags_module_aws_ebs_volume = { TFModule = "aws_ebs_volume" }
  tags_module_sgs = { TFModule = "sgs" }
  tags_module_vpc = { TFModule = "vpc" }
  tags_module_eks = { TFModule = "eks" }
  tags_module_rds = { TFModule = "rds" }

  # tags_module_rds = {TFModule = "rds", AwsService = "rds" , EnvironmentAwsService = "${var.systemenv}_rds"}

  # tags_aws_ec2 = {AwsService = "ec2" , EnvironmentAwsService = "${var.systemenv}_ec2"}
  # tags_aws_beanstalk = {AwsService = "ec2" , EnvironmentAwsService = "${var.systemenv}_beanstalk"}
  # tags_aws_ebs = {AwsService = "ec2,ebs" }
  # tags_aws_cwlogs = {AwsService = "cwlogs" , EnvironmentAwsService = "${var.systemenv}_cwlogs"}
  # tags_aws_vpn = {AwsService = "vpn" }

}