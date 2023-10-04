#This security Group is attached to ECS
resource "aws_security_group" "api_ecs" {
  name = "timing-ecs-api"
  description = "This will only allow traffic from API ALB"
  vpc_id  = local.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "example" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  security_group_id = aws_security_group.api_ecs.id # ecs sg id
  source_security_group_id = local.app_alb_security_group_id #this is the loadbalancer sg id which the traffic comes to this sg.
}