pipeline {
    agent any

    environment {
        DOTNET_VERSION = '6.0.x'
        AWS_REGION = 'eu-west-2'
        ECR_REPO = '123456789012.dkr.ecr.eu-west-2.amazonaws.com/nunit-sample'
    }

    tools {
        dotnet "${DOTNET_VERSION}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'net6.0', url: 'https://github.com/dodyg/practical-aspnetcore.git'
                script {
                    // Extract short commit hash and set it as IMAGE_TAG
                    COMMIT_HASH = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    env.IMAGE_TAG = COMMIT_HASH
                }
            }
        }

        stage('Restore') {
            steps {
                dir('projects/testing/nunit-1') {
                    sh 'dotnet restore'
                }
            }
        }

        stage('Build') {
            steps {
                dir('projects/testing/nunit-1') {
                    sh 'dotnet build --configuration Release'
                }
            }
        }

        stage('Test') {
            steps {
                dir('projects/testing/nunit-1') {
                    sh 'dotnet test --no-build --verbosity normal'
                }
            }
        }

        stage('Publish') {
            steps {
                dir('projects/testing/nunit-1') {
                    sh 'dotnet publish -c Release -o out'
                }
            }
        }

        stage('Docker Build & Push to ECR') {
            steps {
                dir('projects/testing/nunit-1') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-credentials'
                    ]]) {
                        script {
                            def imageFullName = "${ECR_REPO}:${env.IMAGE_TAG}"

                            // Authenticate to AWS ECR
                            sh """
                                aws configure set region ${AWS_REGION}
                                aws ecr get-login-password --region ${AWS_REGION} | \
                                docker login --username AWS --password-stdin ${ECR_REPO}
                            """

                            // Build and push Docker image
                            sh "docker build -t ${imageFullName} ."
                            sh "docker push ${imageFullName}"
                        }
                    }
                }
            }
        }

        stage('Deployment') {
            steps {
                echo 'Deployment to ECS'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
        }
        failure {
            echo 'Pipeline failed.'
        }
        success {
            echo "Pipeline succeeded. Image pushed to: ${ECR_REPO}:${env.IMAGE_TAG}"
        }
    }
}