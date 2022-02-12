# ====================
# Security Group (app)
# ====================
resource "aws_security_group" "atplace-security-group-app" {
  vpc_id = aws_vpc.atplace-vpc.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["10.0.0.0/16"]
    security_groups = [aws_security_group.atplace-security-group-alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-security-group-app"
  }
}



# ====================
# Security Group（ALB）
# ====================
resource "aws_security_group" "atplace-security-group-alb" {
  vpc_id      = aws_vpc.atplace-vpc.id

  ingress {
    from_port   = 80
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#  ingress {
#    from_port   = 443
#    to_port     = 443
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-security-group-alb"
  }
}

# ====================
# Security Group (RDS)
# ====================
resource "aws_security_group" "atplace-security-group-rds" {
  vpc_id      = aws_vpc.atplace-vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "${var.app_name}-security-group-rds"
    security_groups = [aws_security_group.atplace-security-group-app.id]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/28"]
    description = "${var.app_name}-security-group-rds"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.app_name}-security-group-rds"
  }
}