resource "aws_vpc" "web-server-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.web-server-vpc.id
  availability_zone = "us-west-2a"
  cidr_block        = "10.0.1.0/24"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.web-server-vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.web-server-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_subnet_rout_table_association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow Http traffic"
  vpc_id      = aws_vpc.web-server-vpc.id

  ingress {
    description = "Http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}



resource "aws_instance" "webserver" {
  ami                         = "ami-0341aeea105412b57"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_http.id]
  user_data                   = file("userdata.sh")
}
