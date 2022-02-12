data "aws_ssm_parameter" "database_name" {
  name = "DB_NAME"
  with_decryption = true
}

data "aws_ssm_parameter" "database_user" {
  name = "DB_USER"
  with_decryption = true
}

data "aws_ssm_parameter" "database_password" {
  name = "DB_PASSWORD"
  with_decryption = true
}

data "aws_ssm_parameter" "database_port" {
  name = "DB_PORT"
  with_decryption = true
}