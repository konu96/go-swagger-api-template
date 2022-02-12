# ====================
# Subnet
# ====================
resource "aws_subnet" "atplace-subnet-1a" {
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  vpc_id            = aws_vpc.atplace-vpc.id

  tags = {
    Name = "${var.app_name}-subnet-1a"
  }
}

resource "aws_subnet" "atplace-subnet-1c" {
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"
  vpc_id            = aws_vpc.atplace-vpc.id

  tags = {
    Name = "${var.app_name}-subnet-1c"
  }
}