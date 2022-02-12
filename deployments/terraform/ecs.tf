resource "aws_ecs_cluster" "atplace-cluster" {
  name = "${var.app_name}-cluster"
}

resource "aws_cloudwatch_log_group" "atplace-log-group" {
  name = "${var.app_name}-log-group"
}

resource "aws_ecs_task_definition" "atplace-task-definition" {
  family                   = "${var.app_name}-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  execution_role_arn       = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  cpu                      = 1024
  memory                   = 2048
  container_definitions    = <<TASK
  [
  {
    "image": "121409919619.dkr.ecr.ap-northeast-1.amazonaws.com/atplace:v1.0.7",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "atplace-log-group",
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "cpu": 512,
    "memory": 1024,
    "mountPoints": [],
    "environment": [
      {
        "name": "DB_HOST",
        "value": "${aws_db_instance.atplace-rds.endpoint}"
      }
    ],
    "networkMode": "awsvpc",
    "name": "atplace-container",
    "essential": true,
    "portMappings": [
      {
        "hostPort": 8080,
        "containerPort": 8080,
        "protocol": "tcp"
      }
    ],
    "secrets": [
      {
        "name": "API_TOKEN",
        "valueFrom": "arn:aws:ssm:ap-northeast-1:121409919619:parameter/API_TOKEN"
      },
      {
        "name": "CLOUDFRONT_URL",
        "valueFrom": "arn:aws:ssm:ap-northeast-1:121409919619:parameter/CLOUDFRONT_URL"
      },
      {
        "name": "DB_USER",
        "valueFrom": "arn:aws:ssm:ap-northeast-1:121409919619:parameter/DB_USER"
      },
      {
        "name": "DB_PASSWORD",
        "valueFrom": "arn:aws:ssm:ap-northeast-1:121409919619:parameter/DB_PASSWORD"
      },
      {
        "name": "DB_NAME",
        "valueFrom": "arn:aws:ssm:ap-northeast-1:121409919619:parameter/DB_NAME"
      },
      {
        "name": "DB_PORT",
        "valueFrom": "arn:aws:ssm:ap-northeast-1:121409919619:parameter/DB_PORT"
      }
    ],
    "command": [
      "./main"
    ]
  }
]
TASK
}

# ====================
# Service
# ====================
resource "aws_ecs_service" "atplace-service" {
  cluster                            = aws_ecs_cluster.atplace-cluster.id
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  name                               = "${var.app_name}-service"
  task_definition                    = aws_ecs_task_definition.atplace-task-definition.arn
  health_check_grace_period_seconds = 3600
  desired_count = 2

  /// autoscalingで動的に変化する値を無視する ///
  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.atplace-target-group.arn
    container_name   = "${var.app_name}-container"
    container_port   = 8080
  }

  network_configuration {
    subnets          = [aws_subnet.atplace-subnet-1a.id, aws_subnet.atplace-subnet-1c.id]
    security_groups  = [aws_security_group.atplace-security-group-app.id, aws_security_group.atplace-security-group-rds.id]
    assign_public_ip = "true"
  }
}