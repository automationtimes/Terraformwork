variable "vpc_id_get" {}
variable "security_group"{}
variable "web_ingress" {
  type = map(object({
    port     = number
    protocol = string

  }))
  default = {
    "80" = {
      port     = 80
      protocol = "tcp"
    }
    "443" = {
      port     = 443
      protocol = "tcp"
    }
    "3306" = {
      port     = 3306
      protocol = "tcp"

    }
  }
}