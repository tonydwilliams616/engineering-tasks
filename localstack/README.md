An example Terraform deployment to deploy three s3 buckets with versioning disabled/enabled and allow cloudfront logs ingestion:

 * Terraform

Prerequisites
-----

LocalStack Installed locally

See the [LocalStack](https://github.com/localstack/localstack) for installation instructions.
See the [LocalStack Terraform Integration](https://docs.localstack.cloud/user-guide/integrations/terraform/) for installation instructions. for installation instructions.

Deployment
-----

Steps to Deploy S3 Buckets:

1. Initialise Terraform

        

2. 

        cd docker

4. Build the image

        docker build -t="my-app" docker-direct

    This will take a few minutes.

5. Run the image's default command, which should start everything up. The `-p` option forwards the container's port 80 to port 8000 on the host.

        docker run -p="8000:80" docker-direct

6. Once everything has started up, you should be able to access the webapp via [http://localhost:8000/](http://localhost:8000/) on your host machine.

        open http://localhost:8000/

You can also login to the image and have a look around:

    docker run -i -t my-app /bin/bash