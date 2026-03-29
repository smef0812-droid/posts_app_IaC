# 起動テンプレート
resource "aws_launch_template" "post_app_temp" {
  name          = "post-app-temp"
  image_id      = "ami-0549d4621d686b356"
  instance_type = "t3.micro"
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg.id]
  }
  tags = {
    Name = "post-app-temp"
  }
}

resource "aws_autoscaling_group" "post_app_asg" {
  name                      = "post-app-asg"
  max_size                  = 4
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"

  vpc_zone_identifier = [
    aws_subnet.posts_app_private_subnet_a.id,
    aws_subnet.posts_app_private_subnet_b.id
  ]

  target_group_arns = [
    aws_lb_target_group.post_app_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.post_app_temp.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "post-app-ec2"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "post_app_scale_out" {
  name                   = "post-app-scale-out"
  autoscaling_group_name = aws_autoscaling_group.post_app_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}