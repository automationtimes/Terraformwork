output "DB_EndPoint" {
  value = aws_db_instance.MySQL_DB_Instance.endpoint
}
output "rds_dbname" {
  value = aws_db_instance.MySQL_DB_Instance.name
}
output "rdsuser_name" {
  value = aws_db_instance.MySQL_DB_Instance.username

}
output "rds_passwd" {
  value = aws_ssm_parameter.secret.value

}


