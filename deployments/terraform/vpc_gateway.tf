# ====================
# Internet Gateway
# ====================
resource "aws_internet_gateway" "atplace-gateway" {
  vpc_id = aws_vpc.atplace-vpc.id

  tags = {
    Name = "${var.app_name}-gateway"
  }
}