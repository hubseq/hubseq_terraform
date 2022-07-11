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
