# ====================
# VPC
# ====================
resource "aws_vpc" "atplace-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.app_name}-vpc"
  }
}