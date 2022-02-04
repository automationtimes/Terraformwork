aws-region = "us-east-1"

vpc = {
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
  name                 = "znclouds"
  env                  = "dev"

}
instance = {
  image_id             = "ami-0231217be14a6f3ba"
  flavor               = "t2.micro"
  maxsize              = "2"
  minsize              = "2"
  desire_capacity      = "2"
  health_check         = "ELB"
  health_check_period  = "300"
  asg_tag              = "zprofile_ASG"
  keypair              = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpVPBdAePpal28/G3MJEXx7F8V+HczMrC/MPuu88P0YBG2EuNYvGtslEPnfmWkVsOnUYmx8KMgAr8neMBDoN0KnDQZKLSI0CszdPL+DhyU83fxpw9+XXP09QWvIuYaOg5H9EtcG7HVcAOK/KVHy1BbwhfBPDivVb8y8KvA646Bgy4LEZVWUgxUdO5M7rhmCcLLNP0yNAjgSOk85KGpBV6wNQ2bD7assrBnH+RLi5UFuQ1hMxDp4SWBomjAlUPO3MTIiX7qKzbYCt2z13Kh/5MoxmqdjiBG/PLcV7vTxt7L+A1aCJ/A1jSdPPJbHTxXiJw+GjUXnYqP+YClvdcdXbep3UOxozv+n4sLRpyxjPDX4z6CDwyr4AijiM5AWGkbs+Co54u5WNahilc630zDGNVK4UWwaAoVObWWD9l39fSoTk1ZCN3RVOlLdch//TC887GIwN+JstNAULtPdWW9ZOKMv59zs4WX0umf9Z6Uc7VfYZ8crEyq7q2uqwdv6ar/nnE= zohaib@zohaib-ThinkPad-T560"
  metrics_enabled      = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances", ]
  asg_adjustment       = "ChangeInCapacity"
  scaling_policy       = "SimpleScaling"
  scaling_adjustment   = "1"
  cooldown_period      = "300"
  scaling_Threshold    = "GreaterThanOrEqualToThreshold"
  evalution_period     = "2"
  metric_name          = "highalarm-CPUUtilization"
  scaling_namespace    = "AWS/EC2"
  scaling_period       = "60"
  scaling_statistic    = "Average"
  cloudwatch_threshold = "80"
  lesscaling_Threshold = "LessThanOrEqualToThreshold"
  lowmetrics_name      = "lowalarm-CPUUtilization"
  database_name        = "zohaibdb"
  database_user        = "zohaibashraf"


}

ELB = {
  aws_lb_name         = "terraform-asg-zprofile"
  lb_type             = "application"
  listner_port        = "80"
  protocol            = "HTTP"
  lb_protocol         = "HTTP"
  lb_target_matcher   = "200"
  interval            = "40"
  healthy_threshold   = "2"
  unhealthy_threshold = "6"
  lb_tg_group         = "asg-zprofile"
  lb_listner_rule     = "100"
  aws_elb_tag         = "zohaib_elb"
  alb_target_type     = "instance"
  alb_port            = "80"
  timeout             = "30"
  lb_target_path      = "/"
 

}
RDS = {
  database_name        = "zohaibdb"
  database_user        = "zohaibashraf"
  database_password    = "zohaibpassword"
  dbinstance           = "db.t2.micro"
  dbstorage            = "20"
  engine_version       = "5.7"
  engine_db            = "mysql"
  parameter_group_name = "default.mysql5.7"
  mysql_subnet_name    = "mysqlsubnetgroup"
  ssm_type             = "SecureString"
  ssm_name             = "/password/rds"
  passwd_length        =  "12"
  special_char         =  "%@"
}
iamval = {

    role_name_ssm               = "wordpress_ec2_policy"
    instance_profile_name       = "ssm_instance_profile"
    ssm_policy_name             = "wordpress_ssm_policy"
   


}
security_group = {

}




 