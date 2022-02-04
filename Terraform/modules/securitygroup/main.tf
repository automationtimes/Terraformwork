# security Groups for aws launch
resource "aws_security_group" "ec2-sec-group" {
  vpc_id = var.vpc_id_get

  dynamic "ingress" {
    for_each = var.web_ingress
    content {
      description = "TLS from vpc"
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      security_groups=  [aws_security_group.ELB_allow_rule.id]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "zprofile-group"
  }
}
#security group for ssh 
resource "aws_security_group" "ssh" {
  vpc_id = var.vpc_id_get
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ssh_SG"
  }
}
###############################

resource "aws_security_group" "ELB_allow_rule" {
  vpc_id = var.vpc_id_get
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ELB_SG"
  }
}

############ RDS #################
resource "aws_security_group" "RDS_allow_rule" {

  vpc_id = var.vpc_id_get
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = ["${aws_security_group.ec2-sec-group.id}"]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "RDS_SG"
  }

}
