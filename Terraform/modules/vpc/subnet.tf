
# Public Subnets

resource "aws_subnet" "public_subnets" {
  count                   = length(var.vpc.public_subnets_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc.public_subnets_cidr[count.index]
  map_public_ip_on_launch = "true"
  # availability_zone       = data.aws_availability_zones.available.names[count.index]
  availability_zone       =     data.aws_availability_zones.available.names[ count.index % length(data.aws_availability_zones.available.names) ]

  tags = {
    Name = "${terraform.workspace}-${var.vpc.name}-public_subnet-${count.index}"
  }
}


# Private Subnets

resource "aws_subnet" "private_subnets" {
  count                   = length(var.vpc.private_subnets_cidr) 
  # count                   = length(var.vpc.private-subnets-cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc.private_subnets_cidr[count.index]
  map_public_ip_on_launch = "false"
  # availability_zone       = data.aws_availability_zones.available.names[count.index]
  availability_zone       =   data.aws_availability_zones.available.names[ count.index % length(data.aws_availability_zones.available.names) ]

  tags = {
    Name = "${terraform.workspace}-${var.vpc.name}-private-subnet-${count.index}"
  }
}

# Public Subnets Route Table

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-gw.id
  }

  tags = {
    Name = "${terraform.workspace}-${var.vpc.name}-public-route-table"
  }
}

# Private Subnets Route Table

resource "aws_route_table" "private_route_table" {

  count  = length(var.vpc.private_subnets_cidr) > 0 ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
    

  }

  tags = {
    Name = "${terraform.workspace}-${var.vpc.name}-private_route_table"
  }
}

# VPC setup for NAT

resource "aws_eip" "nat" {
 
  vpc = true
}




resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.vpc.private_subnets_cidr) > 0 ? 1 : 0
  allocation_id = aws_eip.nat.id
  subnet_id  = aws_subnet.public_subnets[0].id
  depends_on = [aws_internet_gateway.vpc-gw]
 
  tags = {
    Name = "${terraform.workspace}-${var.vpc.name}-nat_gw"
  }
}


# Public Subnets Route Table Association

resource "aws_route_table_association" "public_subnets" {
  count          = length(var.vpc.public_subnets_cidr)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}





resource "aws_route_table_association" "private_subnets" {
  # count          = length(var.vpc.private-subnets-cidr)
  count =  length(var.vpc.private_subnets_cidr) > 0 ? length(var.vpc.private_subnets_cidr) : 0
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table[0].id
}




