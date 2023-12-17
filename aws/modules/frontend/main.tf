resource "aws_security_group" "frontend" {
  name        = "frontend-sg"
  description = "frontend security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "http from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "frontend" {
  name               = "frontend-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.frontend.id]
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "frontend" {
  name       = "frontend-tg"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = var.vpc_id
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

resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = var.as_ws_id
  lb_target_group_arn    = aws_lb_target_group.frontend.id
}
