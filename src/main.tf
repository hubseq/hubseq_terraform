/* testuser1 has read-only access to all S3 buckets and full access to
   bucket s3://hubseq-test-policy
*/

// IAM user
/*
resource "aws_iam_user" "testuser1" {
  name = "testuser1"
}
*/

// policy document
data "aws_iam_policy_document" "more_access" {
  statement {
    actions   = ["s3:ListAllMyBuckets", "s3:GetBucketLocation", "s3:ListBucket"]
    resources = ["arn:aws:s3:::*"]
    effect = "Allow"
  }
  statement {
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::hubseq-test-policy/*"]
    effect = "Allow"
  }
}

// policy
resource "aws_iam_policy" "more_access_policy" {
   name        = "test-policy-more"
   description = "My test policy more access"
   policy = data.aws_iam_policy_document.more_access.json
}

// policy attachment
resource "aws_iam_user_policy_attachment" "more_access_policy_attachment" {
  user       = "testuser1" # aws_iam_user.testuser1.name
  policy_arn = aws_iam_policy.more_access_policy.arn
}

// output
output "rendered_policy_more_access" {
  value = data.aws_iam_policy_document.more_access.json
}

/* testuser2 has read-only access to all S3 buckets
*/

// IAM user
/*
resource "aws_iam_user" "testuser2" {
  name = "testuser2"
}
*/

// policy document
data "aws_iam_policy_document" "read_access" {
  statement {
    actions   = ["s3:ListAllMyBuckets", "s3:GetBucketLocation", "s3:ListBucket"]
    resources = ["arn:aws:s3:::*"]
    effect = "Allow"
  }
}

// policy
resource "aws_iam_policy" "read_access_policy" {
   name        = "test-policy-read"
   description = "My test policy read access"
   policy = data.aws_iam_policy_document.read_access.json
}

// policy attachment
resource "aws_iam_user_policy_attachment" "read_access_policy_attachment" {
  user       = "testuser2" # aws_iam_user.testuser2.name
  policy_arn = aws_iam_policy.read_access_policy.arn
}

// output
output "rendered_policy_read_access" {
  value = data.aws_iam_policy_document.read_access.json
}

/* role for read-access test identity pool in Cognito -
read-only access to S3
*/
/*
// policy document
data "aws_iam_policy_document" "read_access_cognito" {
  statement {
    actions   = ["s3:ListAllMyBuckets", "s3:GetBucketLocation", "s3:ListBucket"]
    resources = ["arn:aws:s3:::*"]
    effect = "Allow"
  }
  statement {
    actions   = ["mobileanalytics:PutEvents",
                "cognito-sync:*",
                "cognito-identity:*"]
    resources = ["*"]
    effect = "Allow"
  }
}

// policy
resource "aws_iam_policy" "read_access_cognito_policy" {
   name        = "cognito-test-policy-read"
   description = "Cognito test policy read access"
   policy = data.aws_iam_policy_document.read_access_cognito.json
}

// role
resource "aws_iam_role" "cognito_role" {
  name = "cognito-role"

  assume_role_policy = <<EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Principal": {
                  "Federated": "cognito-identity.amazonaws.com"
              },
              "Action": "sts:AssumeRoleWithWebIdentity",
              "Condition": {
                  "StringEquals": {
                      "cognito-identity.amazonaws.com:aud": "us-west-2:51196d02-5075-4e91-8a8a-34a72fb1feec"
                  },
                  "ForAnyValue:StringLike": {
                      "cognito-identity.amazonaws.com:amr": "authenticated"
                  }
              }
          }
      ]
  }
EOF
}

// policy attachment to role
resource "aws_iam_role_policy_attachment" "attached_policy_to_role_read_access" {
  role       = aws_iam_role.cognito_role.name
  policy_arn = aws_iam_policy.read_access_cognito_policy.arn
}
*/

/* role for more-access test identity pool in Cognito -
read access to S3 + write access to s3://hubseq-test-policy/
*/
data "aws_iam_policy_document" "more_access_cognito" {
  statement {
    actions   = ["s3:ListAllMyBuckets", "s3:GetBucketLocation"]
    resources = ["arn:aws:s3:::*"]
    effect = "Allow"
  }
  statement {
    actions = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::hubgenomes"]
    effect = "Allow"
  }
  // users have read-access to all team data
  statement {
    actions = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::hubtenants"]
    effect = "Allow"
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values = ["$${aws:PrincipalTag/teamid}/*"]
    }
  }
  statement {
    actions   = ["s3:GetObject*"]
    resources = ["arn:aws:s3:::hubtenants/$${aws:PrincipalTag/teamid}/*"]
    effect = "Allow"
  }
  statement {
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::hubtenants/$${aws:PrincipalTag/teamid}/$${aws:PrincipalTag/userid}/*"]
    effect = "Allow"
  }
  statement {
    actions   = ["mobileanalytics:PutEvents",
                "cognito-sync:*",
                "cognito-identity:*"]
    resources = ["*"]
    effect = "Allow"
  }
}

// policy
resource "aws_iam_policy" "more_access_cognito_policy" {
   name        = "cognito-test-policy-more"
   description = "Cognito test policy more access"
   policy = data.aws_iam_policy_document.more_access_cognito.json
}

// role
resource "aws_iam_role" "cognito_role_more_access" {
  name = "cognito-role-more-access"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "Federated": "cognito-identity.amazonaws.com"
        },
        "Action": ["sts:AssumeRoleWithWebIdentity",
                   "sts:TagSession"
        ],
        "Condition": {
            "StringEquals": {
                "cognito-identity.amazonaws.com:aud": "us-west-2:51196d02-5075-4e91-8a8a-34a72fb1feec"
            },
            "ForAnyValue:StringLike": {
                "cognito-identity.amazonaws.com:amr": "authenticated"
            }
        }
    }
  ]
}
EOF
}

// policy attachment to role
resource "aws_iam_role_policy_attachment" "attached_policy_to_role_more_access" {
  role       = aws_iam_role.cognito_role_more_access.name
  policy_arn = aws_iam_policy.more_access_cognito_policy.arn
}
