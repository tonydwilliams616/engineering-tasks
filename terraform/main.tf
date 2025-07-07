module "direct" {
  source                   = "./modules"
  enable_versioning        = false
  enable_cloudfront_policy = false
  bucket_name              = var.bucket_names[0]

  tags = local.common_tags

}

module "Ferries" {
  source                   = "./modules"
  enable_versioning        = true
  enable_cloudfront_policy = false
  bucket_name              = var.bucket_names[1]

  tags = local.common_tags

}

module "cloudfront-logs" {
  source                     = "./modules"
  enable_versioning          = true
  enable_cloudfront_policy   = true
  cloudfront_distribution_id = "EDFDVBD632BHDS5"
  log_prefix                 = "cloudfront-logs/"
  bucket_name                = var.bucket_names[2]
  
  tags = local.common_tags

}
