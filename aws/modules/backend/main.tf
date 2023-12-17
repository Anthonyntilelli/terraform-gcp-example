# DATABASE
resource "aws_security_group" "database" {
  name        = "database-sg"
  description = "Database security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "MySQL port"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "random_string" "database" {
  length  = 20
  special = false
}

resource "aws_db_subnet_group" "database" {
  name       = "subnet_group"
  subnet_ids = var.subnet_ids
  tags       = { Name = "Subnet group" }
}

resource "aws_db_instance" "database" {
  allocated_storage      = 10
  db_name                = "backend_db"
  engine                 = "mysql"
  engine_version         = "8.0.35"
  instance_class         = "db.t3.micro"
  username               = "admin"
  db_subnet_group_name   = aws_db_subnet_group.database.id
  password               = random_string.database.result
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database.id]
}

# WEBSERVER
resource "aws_security_group" "webserver" {
  name        = "webserver-sg"
  description = "Webserver security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "http"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.frontend_sg_id]
    cidr_blocks     = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "web_servers" {
  name_prefix                          = "web_servers"
  image_id                             = "ami-0fc5d935ebf8bc3bc"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "web_servers" }
  }
  user_data = filebase64("./modules/backend/files/cluster_webpage.sh")
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.webserver.id]
  }
}

resource "aws_autoscaling_group" "web_servers" {
  name                      = "web_server_as_group"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = [var.subnet_ids[0]]
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
