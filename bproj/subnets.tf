resource "aws_subnet" "public" { /* Public subnet block */
  vpc_id      = aws_vpc.main.id
  cidr_block  = "172.20.0.0/24"

  tags = {
    Name = "subnet_test_priv"
  }
}

resource "aws_subnet" "private" { /* Private subnet block */
  vpc_id      = aws_vpc.main.id
  cidr_block  = "172.20.1.0/24"

  tags = {
    Name = "subnet_test_pub"
  }
}

#resource "aws_internet_gateway" "ig" { /* Internet gateway for public subnet */
#vpc_id = aws_vpc.main.id
  
#  tags = {
#    Name = "Internet gateway"
#  }
#}

resource "aws_nat_gateway" "nat" { /* NAT block */
  allocation_id = aws_eip.public_address.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.ig]
  
  tags = {
    Name        = "nat"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Private routing table"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Public routing table"
  }
}

resource "aws_route" "public_igw" {
  route_table_id          = aws_route_table.public_rt.id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.ig.id
}

resource "aws_route" "private_ngw" {
  route_table_id          = aws_route_table.private_rt.id
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public_rta" {
  count          = length("172.20.1.0/24")
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
resource "aws_route_table_association" "private_rta" {
  count           = length("172.20.0.0/24")
  subnet_id       = aws_subnet.public.id
  route_table_id  = aws_route_table.public_rt.id
}

resource "aws_network_interface" "private_iface" {
  subnet_id   = aws_subnet.private.id
  private_ips = ["172.20.1.11"]

  tags = {
    Name = "private_network_interface"
  }
}

resource "aws_security_group" "dflt_sg" {
  name = "Defautl VPC Security Group"
  vpc_id = aws_vpc.main.id
  depends_on = [aws_vpc.main]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
}

resource "aws_eip" "public_address" { /* Elastic ip block */
  vpc = true
  instance = aws_instance.public_web.id
  #associate_with_private_ip = "190.160.1.1"
  #depends_on = ["aws_internet_gateway.ig"]
}
