output "sglauchtemplate" {
    value = [aws_security_group.ec2-sec-group.id, aws_security_group.ssh.id]
       

    
}
output "sg_set_elb" {
    value = [aws_security_group.ELB_allow_rule.id]
}
output "RDS_SG" {
    value = [aws_security_group.RDS_allow_rule.id]
}