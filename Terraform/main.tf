module "NetworkModules" {
  source = "./modules/vpc/"
  vpc    = var.vpc
}

module "SecurityGroup" {
  security_group = var.security_group
  source = "./modules/securitygroup"
  vpc_id_get = module.NetworkModules.vpc_id
  depends_on = [module.NetworkModules]
 
  

  
  
}
module "RDS" {
  source            = "./modules/RDS"
  RDS               = var.RDS
  PrivateSubnet_get = module.NetworkModules.private_subnets
  vpc_id_get        = module.NetworkModules.vpc_id
  rds_sg_get        = module.SecurityGroup.RDS_SG


}



module "ASG" {
  source        = "./modules/ASG"
  instance      = var.instance
  # subnet_id_get = module.NetworkModules.public_subnets
  DbEndPoint    = module.RDS.DB_EndPoint
  alb_target_id = module.ELB.aws_lb_target
  PrivateSubnet_get = module.NetworkModules.private_subnets
  iam_instance_profile = module.iam.iam_output
  # Rds_Pass            =  module.RDS.rds_passwd
  security_ec2template = module.SecurityGroup.sglauchtemplate
  depends_on = [module.RDS]
  


}
module "ELB" {
  source        = "./modules/ELB"
  ELB           = var.ELB
  subnet_id_get = module.NetworkModules.public_subnets
  vpc_id_get    = module.NetworkModules.vpc_id
  elb_get_sg    = module.SecurityGroup.sg_set_elb


}

module "iam" {
  source = "./modules/iam"
  iamval = var.iamval
  
}
