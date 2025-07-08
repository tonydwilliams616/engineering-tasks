resource "aws_s3_bucket" "direct" {
  bucket = var.direct
  # No versioning block means it's disabled

  tags   = local.common_tags
}

resource "aws_s3_bucket" "ferries" {
  bucket = var.ferries

  tags   = local.common_tags
}

resource "aws_s3_bucket" "cloudfront-logs" {
  bucket = var.cloudfront-logs

  tags   = local.common_tags
}

resource "aws_s3_bucket_versioning" "versioned" {
  bucket = aws_s3_bucket.ferries.id
  versioning_configuration {
    status = "Enabled"
  }
}
