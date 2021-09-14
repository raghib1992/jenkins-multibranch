locals {
  common_tags = {
    sc_purpose = "sc-saas"
  }
  region          = var.REGION
  domainname      = "us2.saas.securecircle.com"
  route53_zone_id = "Z1OKQMPVBW4QXC"
}
