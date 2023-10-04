# AWS ECS task need two types of roles
#1.Task execution - This will be used by containers inside task
#2. Task - This is by taskitself

resource "aws_iam_role" "api_role_task_execution" {
  name = "${local.tags.Name}-task-execution"     # it will go and fetch the name inside the node-app-backend folder Name
  assume_role_policy = data.aws_iam_policy_document.ecs_trust.json  # this is the policy we provide by using datasource module and it will convert as a json format and send to this iam.tf file
  tags = local.tags
}

# resource "aws_iam_policy" "api_role_task_execution" {
#   name  = "${local.tags.Name}-task-execution"
#   description = "This policy is going to be attached for the task execution role"
#   policy = data.aws_iam_policy_document.rds_secret.json
# }

resource "aws_iam_policy" "api_role_task_execution" {
  name  = "${local.tags.Name}-task-execution"
  description = "This policy is going to be attached for the task execution role"
  policy = data.aws_iam_policy_document.rds_secret.json
  tags = local.tags

}

#AWS IAM Roles and policy attachment
resource "aws_iam_role_policy_attachment" "api_role_policy" {
  role       = aws_iam_role.api_role_task_execution.name
  policy_arn = aws_iam_policy.api_role_task_execution.arn
}



#This is task role
resource "aws_iam_role" "api_role_task" {
  name = "${local.tags.Name}-task"     # it will go and fetch the name inside the node-app-backend folder Name
  assume_role_policy = data.aws_iam_policy_document.ecs_trust.json  # this is the policy we provide by using datasource module and it will convert as a json format and send to this iam.tf file
  tags = local.tags
}

#This is taskpolicy and is mandatory
#This policy will pull the images from ecr
resource "aws_iam_role_policy_attachment" "ecr_pull" {
  role       = aws_iam_role.api_role_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy" #AmazonECSTaskExecutionRolePolicy arn
}

