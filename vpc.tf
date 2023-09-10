# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc-cidr

  tags = {
      Name = "${var.project}-vpc"
    }
}

# Create Public Subnet 1
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "${var.project}-public-subnet-1"
  }
}

# Create Public Subnet 2
resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.16.0/20"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "${var.project}-public-subnet-2"
  }
}

# Create Public Subnet 3
resource "aws_subnet" "public-subnet-3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.32.0/20"
  availability_zone = "eu-west-2c"

  tags = {
    Name = "${var.project}-public-subnet-3"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}-igw"
  }
}

# Create public route table and associate it with the Internet Gateway
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project}-public-rt"
  }
}

# Associate the public subnet to the public route table
resource "aws_route_table_association" "public-subnet-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "public-subnet-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "public-subnet-3" {
  subnet_id      = aws_subnet.public-subnet-3.id
  route_table_id = aws_route_table.main.id
}

# Create Private Subnet 1
resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.128.0/20"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "${var.project}-private-subnet-1"
  }
}

# Create Private Subnet 2
resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.144.0/20"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "${var.project}-private-subnet-2"
  }
}

# Create Private Subnet 3
resource "aws_subnet" "private-subnet-3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.160.0/20"
  availability_zone = "eu-west-2c"

  tags = {
    Name = "${var.project}-private-subnet-3"
  }
}

# Create EIP for NAT
resource "aws_eip" "nat" {
  domain = "vpc"

   tags = {
    Name = "${var.project}-nat-eip"
  }
  depends_on = [aws_internet_gateway.gw]
}

#Create NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet-1.id

  tags = {
    Name = "${var.project}-nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

# Create private route table and associate it with private subnet 1 the NAT Gateway
resource "aws_route_table" "private-subnet-1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.project}-private-subnet-1"
  }
}

# Associate the private subnet to the private route table 1
resource "aws_route_table_association" "private-subnet-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-subnet-1.id

}

# Create private route table and associate it with private subnet 2 the NAT Gateway
resource "aws_route_table" "private-subnet-2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.project}-private-subnet-2"
  }
}

# Associate the private subnet to the private route table 2
resource "aws_route_table_association" "private-subnet-2" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-subnet-2.id

}

# Create private route table and associate it with private subnet 3 the NAT Gateway
resource "aws_route_table" "private-subnet-3" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.project}-private-subnet-3"
  }
}

# Associate the private subnet to the private route table 3
resource "aws_route_table_association" "private-subnet-3" {
  subnet_id      = aws_subnet.private-subnet-3.id
  route_table_id = aws_route_table.private-subnet-3.id

}