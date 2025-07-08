output "direct_bucket" {
  value = aws_s3_bucket.direct.bucket
}
output "ferries_bucket" {
  value = aws_s3_bucket.ferries.bucket
}

output "cloudfront_bucket" {
  value = aws_s3_bucket.cloudfront-logs.bucket
}


# output "bucket_arn" {
#   value = aws_s3_bucket.this.arn
# }