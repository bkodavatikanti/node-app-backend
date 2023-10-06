
#Task definition , Service  : we need to write these two here

#Taskdefinition
resource "aws_ecs_task_definition" "api" {
  family = "${local.tags.Name}"  # we need to provide some name to the task definition.
  #for any ECS task definitions the below roles are mandatory so that the container will go and work with rds and other services

  execution_role_arn = aws_iam_role.api_role_task_execution.arn
  task_role_arn = aws_iam_role.api_role_task.arn
  network_mode  = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = 1024
  memory = 2048
  # you need to provide like how many containers or list of containers
  container_definitions = <<TASK_DEFINITION
    [
        {
        
            "essential": true,
            "image": "566981454850.dkr.ecr.ap-south-1.amazonaws.com/node-app-backend:latest",
            "name": "${local.container_name}",
            "portMappings": [
                {
                    "containerPort": 3000
                }
            ],
            "environment" : ${jsonencode(local.env_vars)},
            "secrets": ${jsonencode(local.application_secrets)}
            
        }
    ]
    TASK_DEFINITION
}

# THIS IS THE ECS SERVICE
resource "aws_ecs_service" "api" {
  name       = "${local.tags.Name}"
  cluster    = local.ecs_cluster_id
  task_definition = aws_ecs_task_definition.api.arn  #the above task definition arn
  desired_count = 4 # for high availibilty purpose we need 2 tasks
  launch_type = "FARGATE"
  network_configuration {
    subnets = local.private_subnet_ids
    security_groups = [aws_security_group.api_ecs.id] 
  }
  
   load_balancer {
    target_group_arn = local.app_target_group_arns
    container_name   = local.container_name  # this container is same as the above target group and this service
    container_port   = 3000
  }

}
