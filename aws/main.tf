locals {
  subnet_ids = [for subnet in module.network.subnets : subnet.id]
}

module "network" {
  source = "./modules/network"
}

module "backend" {
  source         = "./modules/backend"
  vpc_id         = module.network.vpc.id
  vpc_cidr       = module.network.vpc.cidr_block
  subnet_ids     = local.subnet_ids
  frontend_sg_id = aws_security_group.elb.id
}

resource "aws_security_group" "elb" {
  name        = "elb-sg"
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

/*
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
*/
