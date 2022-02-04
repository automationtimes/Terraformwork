resource "aws_iam_role" "IamRole" {
  name     = "${terraform.workspace}-${var.iamval.role_name_ssm}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },     
    ]
  })
tags = {
    Name = "${terraform.workspace}-${var.iamval.role_name_ssm}"
}
}
resource "aws_iam_policy" "ec2_policy" {
  name =  "${terraform.workspace}-ec2_policy"
  path  =  "/"
  description =  "policy set for ssm permission"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:PutParameter",
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_iam_policy_attachment" "ec2_policy_role" {
  name =  "ec2_attachment"
  roles    = [aws_iam_role.IamRole.name]
  policy_arn = aws_iam_policy.ec2_policy.arn
  
}

resource "aws_iam_instance_profile" "ec2InstanceProfile" {
  role                 = aws_iam_role.IamRole.name
  name                 = "${terraform.workspace}-Instance"
  tags = {
    Name               = "${terraform.workspace}-${var.iamval.instance_profile_name}"
  }
}