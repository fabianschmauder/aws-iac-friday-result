resource "aws_vpc" "web-server-vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.web-server-vpc.id
  availability_zone = "us-west-2a"
  cidr_block        = "10.0.1.0/24"
}