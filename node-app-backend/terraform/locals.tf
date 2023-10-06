locals {

 tags = {
    Name = "timing-api-backend"
    Environment = "DEV"
    Terraform = "true"
 }

 rds_secret_arn = data.aws_ssm_parameter.rds_secret_arn.value  # terraform will go and search for the rds_secret and store here in local
 app_alb_security_group_id = data.aws_ssm_parameter.app_alb_security_group_id.value
 vpc_id = data.aws_ssm_parameter.vpc_id.value
 # here in rds_endoint we dont need to expose the host value so we use split function to hide the o index value
 rds_endpoint = split(":", data.aws_ssm_parameter.rds_endpoint.value)[0]
 rds_security_group_id = data.aws_ssm_parameter.rds_security_group_id.value
 ecs_cluster_id = data.aws_ssm_parameter.ecs_cluster_id.value
 # the below split function is used to split the comma sperated two subnets and convert into terraform set
 private_subnet_ids = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
 app_target_group_arns = data.aws_ssm_parameter.app_target_group_arns.value
 container_name = "api-ecs"
 # we need to provide this env variables to help the application container to connect to rds
 env_vars = [
   {
      "name" : "PORT",
      "value":  "3000"     
   },

   {
      "name" : "DB",
      "value" : "timing"
   },

   {
      "name" : "DB_USER",
      "value" : "timingadmin"
   },

   {
      "name" : "DB_HOST",
      "value" : "${local.rds_endpoint}"
   },

   {
      "name" : "DB_PORT",
      "value" : "5432"
   }


 ]

# we can get n number of secrets like use blow code. outof all secrets one screte is rds like below
 application_secrets = [
   {
      "name" :"DBPASS",
      "valueFrom" : "${local.rds_secret_arn}"
   }
 ]
 
}



