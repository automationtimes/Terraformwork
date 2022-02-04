

resource "aws_lb" "ELB" {
  name               = var.ELB.aws_lb_name
  load_balancer_type = var.ELB.lb_type
  internal           = false
  subnets            = flatten([var.subnet_id_get]) 
  security_groups    = var.elb_get_sg
  enable_deletion_protection = false
  tags = {
    Name = "${terraform.workspace}-${var.ELB.aws_elb_tag}"
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ELB.arn
  port              = var.ELB.listner_port
  protocol          = var.ELB.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn

  }
  tags = {
    Name = "${terraform.workspace}-alb-Listner"
  }
}



resource "aws_lb_target_group" "asg" {
  name        = "${terraform.workspace}-alb-TG" 
  protocol    = var.ELB.protocol
  vpc_id      = var.vpc_id_get
  port        = var.ELB.alb_port
  target_type = var.ELB.alb_target_type

  health_check {
    path                = var.ELB.lb_target_path
    interval            = var.ELB.interval
    timeout             = var.ELB.timeout
    healthy_threshold   = var.ELB.healthy_threshold
    unhealthy_threshold = var.ELB.unhealthy_threshold
  }
  tags = {
    Name      = "${terraform.workspace}-zohaib_web"
    Developer = "zohaib"
  }
}
