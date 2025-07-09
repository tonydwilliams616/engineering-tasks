resource "aws_s3_bucket_server_side_encryption_configuration" "direct" {
  bucket = aws_s3_bucket.direct.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "ferries" {
  bucket = aws_s3_bucket.ferries.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudfront-logs" {
  bucket = aws_s3_bucket.cloudfront-logs.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}