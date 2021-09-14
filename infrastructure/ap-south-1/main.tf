module "non_ses_user_key_rotation" {
  source     = "../../modules/non_ses_user_key_rotation/"
  aws_region = local.region
  caller_id  = data.aws_caller_identity.current.id
  sns_topic  = aws_sns_topic.regional_saas_alerts
}