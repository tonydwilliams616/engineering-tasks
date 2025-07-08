An example scripts to deploy three AWS s3 buckets with versioning disabled/enabled and allow cloudfront logs ingestion:

 * Terraform

Prerequisites
-----

LocalStack Installed locally

See the [LocalStack](https://github.com/localstack/localstack) for installation instructions.


See the [LocalStack Terraform Integration](https://docs.localstack.cloud/aws/integrations/infrastructure-as-code/terraform/) for installation instructions. for installation instructions.

Deployment
-----

Steps to Deploy S3 Buckets:

1. cd localstack

2. tflocal init

4. tflocal apply

5. tflocal destroy (destroy local infrastructure)
