variable "region" {}

variable "Principal_Region" {
  type = map(string)
  default = {
    eu-north-1 = "logs.eu-north-1.amazonaws.com"
    ap-south-1 = "logs.ap-south-1.amazonaws.com"
    us-west-2  = "logs.us-west-2.amazonaws.com"
  }
}

variable "SC_PURPOSE" {
  type        = string
  default     = "trial"
  description = "provide the tags of the EC2 Instance on which security update"
}
