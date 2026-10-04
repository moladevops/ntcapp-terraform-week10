// target group

resource "aws_lb_target_group" "my_target_group" {
  name        = "ntc-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.my-vpc.id

  health_check {
    enabled             = true
    port                = "traffic-port"
    protocol            = "HTTP"
    path                = "/"
    interval            = 10
    timeout             = 6
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = {
    Name = "my-target-group"
  }

  depends_on = [aws_vpc.my-vpc]
}

# attach target group to alb

resource "aws_lb_target_group_attachment" "my_target_group_attachment1" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "my_target_group_attachment2" {
  target_group_arn = aws_lb_target_group.my_target_group.arn
  target_id        = aws_instance.server2.id
  port             = 80
}

# alb

resource "aws_lb" "my_alb" {
  name                       = "ntc-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = [aws_subnet.public1.id, aws_subnet.public2.id]
  enable_deletion_protection = false

  tags = {
    Name = "ntc-alb"
  }
}

# create listener for alb
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}