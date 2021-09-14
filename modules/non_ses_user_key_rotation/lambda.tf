data "archive_file" "code_deactivate" {
  type        = "zip"
  source_file = "../../modules/non_ses_user_key_rotation/lambda_function.py"
  output_path = "../../modules/non_ses_user_key_rotation/lambda_function.zip"
}

resource "aws_lambda_permission" "allow_cloudwatch_event" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.iamUserAccessKeyRotation.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduleLambda.arn
}

resource "aws_lambda_function" "iamUserAccessKeyRotation" {
  filename      = data.archive_file.code_deactivate.output_path
  function_name = "iamUserAccessKeyRotation"
  role          = aws_iam_role.iamUserAccessKeyRotation-sc-saas-global-role.arn
  handler       = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.code_deactivate.output_base64sha256
  runtime = "python3.7"
  timeout = 63
  environment {
    variables = {
      snsTopicArn = "${var.sns_topic}".arn
    }
  }
}