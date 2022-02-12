resource "aws_db_subnet_group" "atplace-rds-subnet-group" {
  subnet_ids  = [aws_subnet.atplace-subnet-1a.id, aws_subnet.atplace-subnet-1c.id]
}

resource "aws_db_instance" "atplace-rds" {
  identifier             = "atplace-rds"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = data.aws_ssm_parameter.database_name.value
  username               = data.aws_ssm_parameter.database_user.value
  password               = data.aws_ssm_parameter.database_password.value
  parameter_group_name   = "default.mysql5.7"
  port                   = data.aws_ssm_parameter.database_port.value
  vpc_security_group_ids = [aws_security_group.atplace-security-group-rds.id]
  db_subnet_group_name   = aws_db_subnet_group.atplace-rds-subnet-group.name
  skip_final_snapshot    = true
}
