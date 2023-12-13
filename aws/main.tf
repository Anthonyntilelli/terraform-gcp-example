/*
CREATE:
 - ELB
 - CloudFront
 - EC2 auto scalling group -> instance template
 - RDS
 */

resource "aws_vpc" "primary" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "demo" }
}

resource "aws_subnet" "frontend" {
  vpc_id     = aws_vpc.primary.id
  cidr_block = "10.0.1.0/24"
  tags       = { Name = "front" }
}

resource "aws_subnet" "backend" {
  vpc_id     = aws_vpc.primary.id
  cidr_block = "10.0.2.0/24"
  tags       = { Name = "backend" }
}

resource "aws_s3_bucket" "static_content" {
  bucket_prefix = "static"
  tags          = { Name = "static_content" }
}

# TODO: UPDATE rules to restrict ip addresses
resource "aws_security_group" "frontend" {
  name        = "frontend"
  description = "frontend security group"
  vpc_id      = aws_vpc.primary.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    # cidr_blocks      = [aws_vpc.main.cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks      = [aws_vpc.main.cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "frontend_security_group" }
}

# TODO: UPDATE rules to restrict ip addresses
resource "aws_security_group" "backend" {
  name        = "backend"
  description = "backend security group"
  vpc_id      = aws_vpc.primary.id

  ingress {
    description      = "PostGres port"
    from_port        = 1486
    to_port          = 1486
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    # cidr_blocks      = [aws_vpc.main.cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "backend_security_group" }
}

