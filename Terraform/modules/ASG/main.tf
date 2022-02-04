
resource "aws_key_pair" "mykey-pair" {
  key_name   = "zcloudskey"
  public_key = var.instance.keypair
}
##################################################


data "aws_ssm_parameter" "password_retrive" {
  name        = "/password/rds"
}
data "template_file" "userdata" {
  template = file("${path.module}/user-data.tpl")
  vars = {
    db_username      = var.instance.database_user 
    db_user_password = data.aws_ssm_parameter.password_retrive.value
    db_name          = var.instance.database_name
    db_RDS =          var.DbEndPoint
   
  }

}
resource "aws_launch_template" "Launch_template" {
 name_prefix      = "${terraform.workspace}-launch-template"
  image_id        = var.instance.image_id
  instance_type   = var.instance.flavor
  user_data       = base64encode(data.template_file.userdata.rendered)
  key_name        = aws_key_pair.mykey-pair.id
  vpc_security_group_ids = var.security_ec2template
  iam_instance_profile {
  name     = var.iam_instance_profile
}
 tags = {
    Name = "${terraform.workspace}-launchTemplate"
}
 
}

resource "aws_autoscaling_group" "Practice_ASG" {
  max_size                  = var.instance.maxsize
  min_size                  = var.instance.minsize
  desired_capacity          = var.instance.desire_capacity
  health_check_grace_period = var.instance.health_check_period
  enabled_metrics           = var.instance.metrics_enabled
  health_check_type         = var.instance.health_check
  vpc_zone_identifier       = flatten([var.PrivateSubnet_get])
  target_group_arns         = [var.alb_target_id]
  launch_template {
    id                      = aws_launch_template.Launch_template.id
    version                 = "$Latest"
  }
  tags = [
    {
      name                = "${terraform.workspace}-zohaib-ASG"
      propagate_at_launch = true
    },
    {
      key                 = "Developer"
      value               = "zohaib"
      propagate_at_launch = true
    },
  ]
}
#------------------------------------------------------------------------------
# AUTOSCALING POLICIES
#------------------------------------------------------------------------------
# Scaling UP - CPU High
resource "aws_autoscaling_policy" "cpu_high" {
  name                   = "${terraform.workspace}-cpu-high"
  autoscaling_group_name = aws_autoscaling_group.Practice_ASG.name
  adjustment_type        = var.instance.asg_adjustment
  policy_type            = var.instance.scaling_policy
  scaling_adjustment     = var.instance.scaling_adjustment
  cooldown               = var.instance.cooldown_period
}
# Scaling DOWN - CPU Low
resource "aws_autoscaling_policy" "cpu_low" {
  name                   = "${terraform.workspace}-cpu-low"
  autoscaling_group_name = aws_autoscaling_group.Practice_ASG.name
  adjustment_type        = var.instance.asg_adjustment
  policy_type            = var.instance.scaling_policy
  scaling_adjustment     = "-1"
  cooldown               = var.instance.cooldown_period
}
#------------------------------------------------------------------------------
# CLOUDWATCH METRIC ALARMS
#------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "cpu_high_alarm" {
  alarm_name          = "${terraform.workspace}-cpu-high-alarm"
  comparison_operator = var.instance.scaling_Threshold
  evaluation_periods  = var.instance.evalution_period
  metric_name         = var.instance.metric_name
  namespace           = var.instance.scaling_namespace
  period              = var.instance.scaling_period
  statistic           = var.instance.scaling_statistic
  threshold           = var.instance.cloudwatch_threshold
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.cpu_high.arn]
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.Practice_ASG.name
  }
}
resource "aws_cloudwatch_metric_alarm" "cpu_low_alarm" {
  alarm_name          = "${terraform.workspace}-cpu-low-alarm"
  comparison_operator = var.instance.lesscaling_Threshold
  evaluation_periods  = "2"
  metric_name         = var.instance.lowmetrics_name
  namespace           = var.instance.scaling_namespace
  period              = var.instance.scaling_period
  statistic           = var.instance.scaling_statistic
  threshold           = var.instance.cloudwatch_threshold
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.cpu_low.arn]
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.Practice_ASG.name
  }
}















