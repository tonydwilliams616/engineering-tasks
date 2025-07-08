# S3 Bucket Deployment via Terraform Modules

This repository provides Terraform code to deploy **three Amazon S3 buckets** with configurable versioning settings. One of the buckets is also configured to allow access from **CloudFront logs**.

## Overview

- **Infrastructure-as-Code**: Terraform is used to define and deploy resources.
- **Modules**: The S3 bucket configurations are encapsulated in local Terraform modules.
- **Versioning**: Each bucket can have versioning enabled or disabled based on input.
- **CloudFront Access**: One bucket is configured to receive CloudFront access logs by allowing the appropriate permissions.

# REQUIREMENTS
- Terraform v1.0+
- AWS CLI configured with appropriate credentials and permissions

# NOTES
- Make sure your AWS account has permissions to create and configure S3 buckets.
- The bucket_logs module includes an IAM policy that allows CloudFront to write logs.

## Bucket Details

| Bucket Name | Versioning | CloudFront Log Access |
|-------------|------------|------------------------|
| `Direct`    | Enabled    | No                     |
| `Ferries`   | Disabled   | No                     |
| `cloudfront_logs` | Enabled | **Yes**             |

> ⚙️ All settings are configurable via input variables.

## Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/tonydwilliams616/engineering-tasks.git```

2. **move to terraform directory**
    ```cd terraform```

3. **Initialize Terraform:**
    ```terraform init```

4. **Review planned changes:**
    ```terraform plan```

5. **Apply the configuration:**
    ```terraform apply```


module "direct" {
  source     = "./modules"
  bucket_name = "direct"
  enable_versioning = true
}

