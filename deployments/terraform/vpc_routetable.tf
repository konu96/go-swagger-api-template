# ====================
# Subnet
# ====================
resource "aws_route_table" "atplace-route-table" {
  vpc_id = aws_vpc.atplace-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.atplace-gateway.id
  }

  tags = {
    Name = "${var.app_name}-route-table"
  }
}

resource "aws_route_table_association" "atplace-route-table-association-1a" {
  subnet_id = aws_subnet.atplace-subnet-1a.id
  route_table_id = aws_route_table.atplace-route-table.id
}

resource "aws_route_table_association" "atplace-route-table-association-1c" {
  subnet_id = aws_subnet.atplace-subnet-1c.id
  route_table_id = aws_route_table.atplace-route-table.id
}
