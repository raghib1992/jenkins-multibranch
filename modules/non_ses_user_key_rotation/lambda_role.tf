data "aws_caller_identity" "current" {}

resource "aws_iam_role" "iamUserAccessKeyRotation-sc-saas-global-role" {
  name = "iamUserAccessKeyRotation-sc-saas-global-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "iamUserAccessKeyRotation_attach_policy" {
  name       = "iamUserAccessKeyRotation_sc_saas_global_attach_policy"
  roles      = [aws_iam_role.iamUserAccessKeyRotation-sc-saas-global-role.name]
  policy_arn = aws_iam_policy.iamUserAccessKeyRotation-sc-saas-global-policy.arn
}

resource "aws_iam_policy" "iamUserAccessKeyRotation-sc-saas-global-policy" {
  name = "iamUserAccessKeyRotation-sc-saas-global-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:*"
            ],
            "Resource": "*"
        },
        {
            "Action": [
                "sns:*"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:sns:${var.aws_region}:${var.caller_id}:${var.sns_topic.name}"
        },
        {
            "Sid": "CloudWatchEventsFullAccess",
            "Effect": "Allow",
            "Action": "events:*",
            "Resource": "*"
        },
        {
            "Sid": "IAMPassRoleForCloudWatchEvents",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::${var.caller_id}:role/AWS_Events_Invoke_Targets"
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs::${var.aws_region}:${var.caller_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs::${var.aws_region}:${var.caller_id}:log-group:/aws/lambda/iamUserAccessKeyRotation:*"
            ]
        }

    ]
}
EOF
}