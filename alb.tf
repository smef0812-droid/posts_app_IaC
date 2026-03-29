resource "aws_lb" "post_app_alb" {
  name               = "post-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.posts_app_public_subnet_a.id,
    aws_subnet.posts_app_public_subnet_b.id
  ]
  ip_address_type = "ipv4"

  tags = {
    Name = "post-app-alb"
  }
}

resource "aws_lb_target_group" "post_app_tg" {
  name             = "post-app-tg"
  target_type      = "instance"
  protocol_version = "HTTP1"
  port             = 80
  protocol         = "HTTP"

  vpc_id = aws_vpc.posts_app_vpc.id

  tags = {
    Name = "post-app-tg"
  }

  health_check {
    interval            = 30
    path                = "/login"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 5
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "post_app_li" {
  load_balancer_arn = aws_lb.post_app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.post_app_tg.arn
  }
}