resource "aws_eip" "example" {
  vpc      = true
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.public_subnet1.id
}