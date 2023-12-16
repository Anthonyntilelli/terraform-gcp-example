/*
CREATE:
 - ELB
 - CloudFront
 */

module "network" {
  source = "./modules/network"
}

# resource "aws_s3_bucket" "static_content" {
#   bucket_prefix = "static"
#   tags          = { Name = "static_content" }
# }

# TODO: UPDATE rules to restrict ip addresses
resource "aws_security_group" "ec2" {
  name        = "ec2"
  description = "EC2 security group"
  vpc_id      = module.network.vpc.id

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

  tags = { Name = "ec2_security_group" }
}

resource "aws_security_group" "backend" {
  name        = "backend"
  description = "backend security group"
  vpc_id      = module.network.vpc.id

  ingress {
    description = "MySQL port"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.network.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "backend_security_group" }
}

resource "aws_security_group" "elb" {
  name        = "elb-gs"
  description = "elb security group"
  vpc_id      = module.network.vpc.id

  ingress {
    description = "http from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "elb_security_group" }
}

resource "aws_launch_template" "web_servers" {
  name_prefix                          = "web_servers"
  description                          = "Basic webserver, stand in for dynamic content."
  image_id                             = "ami-0fc5d935ebf8bc3bc"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "web_servers" }
  }
  user_data = filebase64("files/cluster_webpage.sh")
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2.id]
  }
}

resource "aws_autoscaling_group" "web_servers" {
  name                      = "web_server_as_group"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = [module.network.subnets[0].id]
  health_check_grace_period = 500

  launch_template {
    id      = aws_launch_template.web_servers.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "web_servers" {
  name        = "web_server_as_policy"
  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
  autoscaling_group_name = aws_autoscaling_group.web_servers.name
}

/*
resource "random_string" "password" {
  length           = 20
  special          = false
}

resource "aws_db_subnet_group" "group" {
  name       = "main"
  subnet_ids = [aws_subnet.a.id, aws_subnet.b.id]

  tags = { Name = "Subnet group" }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "backend"
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  username             = "admin"
  db_subnet_group_name = aws_db_subnet_group.group.id
  password             = random_string.password.result
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.backend.id]
}
*/

resource "aws_lb" "frontend" {
  name               = "frontend-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb.id]
  subnets            = [for subnet in module.network.subnets : subnet.id]
}

resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.web_servers.id
  lb_target_group_arn    = aws_lb_target_group.frontend.id
}

resource "aws_lb_target_group" "frontend" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc.id
  slow_start = 300
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}
