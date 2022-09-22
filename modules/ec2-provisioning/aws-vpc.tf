#1. create vpc
resource "aws_vpc" "prod-vpc" {
  cidr_block =var.subnet_cidr
  tags = {
    "Name" = "production"
  }
}

#3. create Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "main"
  }
}
#4 create route table
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = var.aws_route_table_cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = var.aws_route_table_ipv6_cidr_block
    gateway_id  = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Prod"
  }
}

#4.Subnet

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.prod-vpc.id
  cidr_block        = var.aws_subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    "name" = "prod-subnet"
  }
}

#5. associate subnet with route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

#6 security group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web traffic inbound traffic"
  vpc_id      = aws_vpc.prod-vpc.id


 dynamic "ingress" {
    for_each = "${var.ports}"
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = [var.ingress_cidr]
    }
  

}
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = var.egress_port
    cidr_blocks      = [var.egress_cidr]
  #  ipv6_cidr_blocks = ["::/0"]
  }
  # ingress {
  #   description      = "HTTPS"
  #   from_port        = 443
  #   to_port          = 443
  #   protocol         = "tcp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  
  # }

  # ingress {
  #   description      = "HTTP"
  #   from_port        = 80
  #   to_port          = 80
  #   protocol         = "tcp"
  #   cidr_blocks      = ["0.0.0.0/0"]
 
  # }

  # ingress {
  #   description      = "SSH"
  #   from_port        = 22
  #   to_port          = 22
  #   protocol         = "tcp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #  # ipv6_cidr_blocks = [aws_vpc.prod-vpc.ipv6_cidr_block]
  # }



  tags = {
    Name = "allow_web"
  }
}
#7. create network interface 
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = [var.aws_network_interface_private_ip]
  security_groups = [aws_security_group.allow_web.id]

}
#8 Assign an elastic Ip to the network

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = var.aws_eip_associate_with_private_ip
  depends_on                = [aws_internet_gateway.gw]

}
