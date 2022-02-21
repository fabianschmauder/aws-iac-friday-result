resource "aws_vpc" "web-server-vpc" {
    cidr_block = "10.0.0.0/16"
}