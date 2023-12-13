/*
CREATE:
 - ELB
 - CloudFront
 - EC2 auto scalling group -> instance template
 - RDS
 */

resource "aws_vpc" "primary" {
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "primary" }
}

resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id
  tags = { Name = "primary"}
}

resource "aws_route" "primary" {
  route_table_id         = aws_vpc.primary.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.primary.id
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
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
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

resource "aws_launch_template" "web_servers" {
  name_prefix                          = "web_servers"
  description                          = "Basic webserver, stand in for dynamic content."
  image_id                             = "ami-0fc5d935ebf8bc3bc"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  tag_specifications {
    resource_type = "instance"
    tags = { Name = "Frontend" }
  }
  user_data = filebase64("files/cluster_webpage.sh")
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.frontend.id]
  }
}

resource "aws_autoscaling_group" "web_servers" {
  name                      = "web_server_as_group"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = [aws_subnet.frontend.id]
  health_check_grace_period = 500

  launch_template {
    id      = aws_launch_template.web_servers.id
    version = "$Latest"
  }
}
