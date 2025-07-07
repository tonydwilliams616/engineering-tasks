variable "tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Owner       = "your-name"
    Project     = "terraform-demo"
  }
}

variable "bucket_names" {
  description = "List of S3 bucket names"
  type        = list(string)
  default     = ["direct", "ferries", "cloudfront-logs"]
}

variable "enable_encryption" {
  description = "Enable server-side encryption for S3 buckets"
  type        = bool
  default     = true
}

