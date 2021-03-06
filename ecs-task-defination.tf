resource aws_ecs_task_definition "ecs" {
  family                   = var.name
  execution_role_arn       = aws_iam_role.ecs_task_excution.arn
  task_role_arn            = try(var.task_role_arn, null)
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = var.requires_compatibilities
  container_definitions    = <<TASK_DEFINITION
[
    {
      "name": "${var.name}",
      "image": "${var.repository_name}:latest",
      "cpu": ${var.cpu},
      "memory": ${var.memory},
      "essential": true,
      "portMappings": [
            {
            "containerPort": ${var.container_port},
            "hostPort": ${var.host_port},
            "protocol": "${var.protocol}"
            }
        ],
        "logConfiguration": 
        {
            "logDriver": "awslogs",
            "options": 
            {
                "awslogs-group": "${aws_cloudwatch_log_group.default.name}",
                "awslogs-region": "${data.aws_region.current.name}",
                "awslogs-stream-prefix": "${var.name}"
            }
        }
    }
]
TASK_DEFINITION
}
