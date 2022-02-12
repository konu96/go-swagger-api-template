resource "aws_security_group" "atplace-security-group-stepping" {
  vpc_id = aws_vpc.atplace-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-security-group-stepping"
  }
}

resource "aws_key_pair" "atplace-key-pair" {
  key_name   = "common-key-pair"
  public_key = file("~/.ssh/atplace_rsa.pub")
}

resource "aws_instance" "atplace-stepping-instance" {
  ami = "ami-011facbea5ec0363b"
  instance_type = "t2.micro"
  key_name   = "common-key-pair"
  vpc_security_group_ids = [
    aws_security_group.atplace-security-group-stepping.id
  ]
  subnet_id = aws_subnet.atplace-subnet-1a.id
  associate_public_ip_address = "true"

  ebs_block_device {
    device_name    = "/dev/xvda"
    volume_type = "gp2"
    volume_size = 30
  }

  user_data = file("./cloud-init.tpl")

  tags  = {
    Name = "${var.app_name}-instance-stepping"
  }
}

# Output
output "public_ip_of_webserver" {
  value = aws_instance.atplace-stepping-instance.public_ip
}