
resource "aws_db_subnet_group" "RDS_SubnetGroup" {
  name       = var.RDS.mysql_subnet_name
  subnet_ids = flatten(var.PrivateSubnet_get)
  tags = {
    Name = "${terraform.workspace}zprofile_SubnetGroup"

  }
}
resource "random_password" "password" {
  length           = var.RDS.passwd_length
  special          = true
  override_special = var.RDS.special_char
}
resource "aws_ssm_parameter" "secret" {
  name        = var.RDS.ssm_name
  description = "RDS password store"
  type        = var.RDS.ssm_type
  value       = random_password.password.result

  tags = {
    environment = "${terraform.workspace}-Rds_ssm_parameter"
  }
}




resource "aws_db_instance" "MySQL_DB_Instance" {
  identifier             ="${terraform.workspace}-zohaibmysql2"
  name                   = var.RDS.database_name
  allocated_storage      = var.RDS.dbstorage
  instance_class         = var.RDS.dbinstance
  engine                 = var.RDS.engine_db
  engine_version         = var.RDS.engine_version
  username               = var.RDS.database_user
  password               = random_password.password.result
  publicly_accessible    = false
  parameter_group_name   = var.RDS.parameter_group_name
  db_subnet_group_name   = aws_db_subnet_group.RDS_SubnetGroup.name
  vpc_security_group_ids = var.rds_sg_get
  skip_final_snapshot    = "true"
  tags = {
    Name = "${terraform.workspace}-Zprofile_MySQL_DB"
  }
}




