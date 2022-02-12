# ====================
# ALB
# ====================
resource "aws_alb" "atplace-alb" {
  security_groups            = [aws_security_group.atplace-security-group-alb.id]
  subnets                    = [aws_subnet.atplace-subnet-1a.id, aws_subnet.atplace-subnet-1c.id]
  internal                   = false
  enable_deletion_protection = false
}

# ====================
# Target Group
# ====================
resource "aws_alb_target_group" "atplace-target-group" {
  depends_on  = [aws_alb.atplace-alb]
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.atplace-vpc.id
  target_type = "ip"

  health_check {
    protocol            = "HTTP"
    path                = "/healthz"
    port                = 8080
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 60
    matcher             = 200
  }
}

# ====================
# ALB Listener HTTP
# ====================
resource "aws_alb_listener" "atplace-alb-http" {
  load_balancer_arn = aws_alb.atplace-alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.atplace-target-group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "atplace-alb-listener-rule" {
  listener_arn = aws_alb_listener.atplace-alb-http.arn

  action {
    target_group_arn = aws_alb_target_group.atplace-target-group.arn
    type = "forward"
  }

  condition {
    http_header {
      http_header_name = "X-API-TOKEN"
      values           = ["ZvNTj=cMNOy40kuekk;]A~cMjCsRP2(01/4vt"]
    }
  }
}

#resource "aws_alb_listener" "atplace-alb-https" {
#  load_balancer_arn = aws_alb.atplace-alb.arn
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2015-05"
#  certificate_arn   = aws_acm_certificate.atplace-acm.arn
#
#  default_action {
#    target_group_arn = aws_alb_target_group.atplace-target-group.arn
#    type             = "forward"
#  }
#}

resource "aws_alb_listener_rule" "atplace-listener-rule" {
  depends_on   = [aws_alb_target_group.atplace-target-group]
  listener_arn = aws_alb_listener.atplace-alb-http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.atplace-target-group.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}