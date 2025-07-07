variable "enable_versioning" {
  description = "Whether to enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}

variable "log_prefix" {
  description = "Prefix inside the bucket where logs will be stored"
  type        = string
  default     = "cloudfront-logs/"
}

variable "enable_cloudfront_policy" {
  description = "Create CloudFront logs bucket policy"
  type        = bool
  default     = false
}

variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID to allow writing logs"
  type        = string
  default     = null

  validation {
    condition     = var.enable_cloudfront_policy == false || (var.cloudfront_distribution_id != null && var.cloudfront_distribution_id != "")
    error_message = "cloudfront_distribution_id must be set if enable_cloudfront_policy is true."
  }
}

variable "bucket_name" {
  type      = string
}
