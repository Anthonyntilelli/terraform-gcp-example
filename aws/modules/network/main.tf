resource "aws_vpc" "primary" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = var.network_name }
}

resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id
  tags   = { Name = "${var.network_name}-igw" }
}

resource "aws_route" "primary" {
  route_table_id         = aws_vpc.primary.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.primary.id
}

resource "aws_subnet" "subnets" {
  count             = length(var.subnet_cidrs)
  vpc_id            = aws_vpc.primary.id
  cidr_block        = var.subnet_cidrs[count.index].cidr
  availability_zone = var.subnet_cidrs[count.index].avz
  tags              = { Name = "${var.network_name}-subnet-${count.index}" }
}

