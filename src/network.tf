resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-vpc" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-igw" })
}

resource "aws_subnet" "private_subnets" {
  count                   = var.vpc_subnet_count
  cidr_block              = var.vpc_cidr_range_private_subnets[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = var.aws_azs[count.index]

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-private-subnet-${count.index}" })
}

resource "aws_subnet" "public_subnets" {
  count                   = var.vpc_subnet_count
  cidr_block              = var.vpc_cidr_range_public_subnets[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = var.aws_azs[count.index]

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-private-subnet-${count.index}" })
}

# allocate Elastic IPs for the NAT gateways
resource "aws_eip" "nat_gateway_eips" {
  count                   = var.vpc_subnet_count
  vpc                     = true
}

resource "aws_nat_gateway" "nat_gateways" {
  count                   = var.vpc_subnet_count
  allocation_id           = aws_eip.nat_gateway_eips[count.index].id
  subnet_id               = aws_subnet.private_subnets[count.index].id
  depends_on = [aws_internet_gateway.igw]

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-nat-gateway-${count.index}" })
}

# public route table - mapping of VPC CIDR block to local is added automatically
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-public-route-table" })
}

# private route table - internet-bound traffic goes through the NAT gateway first
resource "aws_route_table" "private_route_tables" {
  count = var.vpc_subnet_count
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateways[count.index].id
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-private-route-table-${count.index}" })
}

# s3 endpoint inside VPC - routes any S3-bound traffic to this endpoint instead of through NAT->IGW
resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.us-west-2.s3"
}

# route table associations
resource "aws_route_table_association" "rta-public-subnets" {
  count          = var.vpc_subnet_count
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "rta-private-subnets" {
  count          = var.vpc_subnet_count
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}

resource "aws_vpc_endpoint_route_table_association" "rta-s3-private" {
  count = var.vpc_subnet_count
  route_table_id = aws_route_table.private_route_tables[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "rta-s3-public" {
  route_table_id = aws_route_table.public_route_table.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

# reachable-from-vpc allows full access from inside the vpc
resource "aws_security_group" "reachable_from_vpc" {
  name   = "${local.name_prefix}-reachable-from-vpc"
  vpc_id = aws_vpc.vpc.id

  # inbound - full access from inside VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # outbound - internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-reachable-from-vpc" })
}

# reachable-with-ssh allows external SSH access for a resource in a public subnet.
resource "aws_security_group" "reachable_with_ssh" {
  name   = "${local.name_prefix}-reachable-with-ssh"
  vpc_id = aws_vpc.vpc.id

  # inbound - full access from inside VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound - internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-reachable-with-ssh" })
}

# reachable-with-http allows external HTTP/HTTPS access for a resource in a public subnet. Includes other typical web server ports such as 3000, 5000, 8080
resource "aws_security_group" "reachable_with_http" {
  name   = "${local.name_prefix}-reachable-with-http"
  vpc_id = aws_vpc.vpc.id

  # inbound - HTTP
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # inbound - other typical web server ports
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound - internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${local.name_prefix}-reachable-with-http" })
}
