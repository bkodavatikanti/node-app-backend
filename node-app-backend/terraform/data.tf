#Generates an IAM policy document in JSON format for use with resources that expect policy documents such as aws_iam_policy.

#Using this data source to generate policy documents is optional. 
#It is also valid to use literal JSON strings in your configuration or to use the file interpolation function to read a raw JSON policy document from a file.
# this is going to trusted by ECS
data "aws_iam_policy_document" "ecs_trust" {  
  statement {
    sid = "ECSTRUSTPOLICY"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }   
   }
  }


  data "aws_iam_policy_document" "rds_secret" {  
  statement {
    sid = "AllowECStoAccesstheRDSsecret"  # in SID we provide some meaningful name
    actions = [
      "secretsmanager:GetSecretValue"   #This is to get the secrets from the rds cz we are giving the action as only get
    ]
    resources = ["${local.rds_secret_arn}"]  # we need to define the resource where it will go and fetch the secerets
   }
}
  
  # we use datasource to get the parameter store rds_secret_arn to here
  data "aws_ssm_parameter" "rds_secret_arn" {
  name = "/timing/rds/rds_secret_arn"  #By using this name we defined in paramter store we retreive the arm
 }

  data "aws_ssm_parameter" "app_alb_security_group_id" {
  name = "/timing/vpc/app_alb_security_group_id"
 }

 data "aws_ssm_parameter" "vpc_id" {
  name = "/timing/vpc/vpc_id"
 }

 data "aws_ssm_parameter" "rds_endpoint" {
  name = "/timing/vpc/rds_endpoint"
 }

 data "aws_ssm_parameter" "rds_security_group_id" {
  name = "/timing/vpc/rds_security_group_id"
 }

 data "aws_ssm_parameter" "ecs_cluster_id" {
  name = "/timing/ecs/ecs_cluster_id"
 }

 data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/timing/vpc/private_subnet_ids"
 }

data "aws_ssm_parameter" "app_target_group_arns" {
  name = "/timing/ec2/app_target_group_arns"
 }