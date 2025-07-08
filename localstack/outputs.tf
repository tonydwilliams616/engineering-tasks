output "direct_bucket" {
  value = aws_s3_bucket.direct.bucket
}
output "ferries_bucket" {
  value = aws_s3_bucket.ferries.bucket
}

output "cloudfront_bucket" {
  value = aws_s3_bucket.cloudfront-logs.bucket
}

output "direct_arn" {
  value = aws_s3_bucket.direct.arn
}
output "ferries_arn" {
  value = aws_s3_bucket.ferries.arn
}

output "cloudfront_arn" {
  value = aws_s3_bucket.cloudfront-logs.arn
}