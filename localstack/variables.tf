variable "log_prefix" {
  description = "Prefix inside the bucket where logs will be stored"
  type        = string
  default     = "cloudfront-logs/"
}

variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID to allow writing logs"
  type        = string
}

variable "direct" {
  description = "AWS S3 bucket name for direct objects"
  default     = "direct"
  type        = string
}

variable "ferries" {
  description = "AWS S3 bucket name for ferries objects"
  default     = "ferries"
  type        = string
}

variable "cloudfront-logs" {
  description = "AWS S3 bucket name for cloudfront-logs objects"
  default     = "cloudfront-logs"
  type        = string
}