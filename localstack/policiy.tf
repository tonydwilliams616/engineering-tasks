data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "cloudfront_logs_policy" {
  bucket = aws_s3_bucket.cloudfront-logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePutObject",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "${aws_s3_bucket.cloudfront-logs.arn}/${var.log_prefix}*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.cloudfront_distribution_id}"
          }
        }
      }
    ]
  })
}