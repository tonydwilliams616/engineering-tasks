pipeline {
    agent any

    environment {
        // Define environment variables
        DOTNET_VERSION = '8.0'
        PROJECT_NAME = 'nunit-1'
        DOCKER_IMAGE = "${PROJECT_NAME}:${BUILD_NUMBER}"
        DOCKER_REGISTRY = 'your-registry.com'
        SONAR_PROJECT_KEY = 'nunit-1'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
                script {
                    // Get commit info for tagging
                    env.GIT_COMMIT_SHORT = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Build') {
            steps {
                echo 'Building the .NET application...'
                script {
                    // Restore NuGet packages
                    sh 'dotnet restore'

                    // Build the solution
                    sh 'dotnet build --configuration Release --no-restore'

                    // Publish the application
                    sh 'dotnet publish --configuration Release --output ./publish --no-build'
                }
            }
            post {
                success {
                    echo 'Build completed successfully!'
                }
                failure {
                    echo 'Build failed!'
                }
            }
        }

        stage('Test') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        echo 'Running unit tests...'
                        script {
                            // Run NUnit tests with coverage
                            sh '''
                                dotnet test --configuration Release --no-build \
                                    --logger trx --results-directory ./TestResults \
                                    --collect:"XPlat Code Coverage" \
                                    --settings coverlet.runsettings
                            '''
                        }
                    }
                    post {
                        always {
                            // Publish test results
                            publishTestResults(
                                testResultsPattern: 'TestResults/**/*.trx',
                                testResultsFormat: 'VSTest'
                            )
                            // Publish code coverage
                            publishCoverage(
                                adapters: [
                                    coberturaAdapter('TestResults/**/coverage.cobertura.xml')
                                ],
                                sourceFileResolver: sourceFiles('STORE_LAST_BUILD')
                            )
                        }
                    }
                }

                stage('Code Quality') {
                    steps {
                        echo 'Running code quality analysis...'
                        script {
                            // SonarQube analysis
                            withSonarQubeEnv('SonarQube') {
                                sh '''
                                    dotnet sonarscanner begin \
                                        /k:"${SONAR_PROJECT_KEY}" \
                                        /d:sonar.host.url="${SONAR_HOST_URL}" \
                                        /d:sonar.login="${SONAR_AUTH_TOKEN}" \
                                        /d:sonar.cs.nunit.reportsPaths="TestResults/**/*.trx" \
                                        /d:sonar.cs.opencover.reportsPaths="TestResults/**/coverage.opencover.xml"

                                    dotnet build --configuration Release

                                    dotnet sonarscanner end /d:sonar.login="${SONAR_AUTH_TOKEN}"
                                '''
                            }
                        }
                    }
                }
            }
        }

        stage('Security Scan') {
            steps {
                echo 'Running security vulnerability scan...'
                script {
                    // OWASP Dependency Check
                    sh '''
                        dotnet list package --vulnerable --include-transitive \
                            --format json > vulnerability-report.json
                    '''

                    // Docker image security scan (if using Docker)
                    sh '''
                        docker build -t ${DOCKER_IMAGE} .
                        docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
                            -v $(pwd):/root/.cache/ aquasec/trivy:latest \
                            image --format json --output trivy-report.json ${DOCKER_IMAGE}
                    '''
                }
            }
            post {
                always {
                    // Archive security reports
                    archiveArtifacts artifacts: '*-report.json', allowEmptyArchive: true
                }
            }
        }

        stage('Package') {
            steps {
                echo 'Creating deployment packages...'
                script {
                    // Create NuGet package if it's a library
                    sh 'dotnet pack --configuration Release --no-build --output ./packages'

                    // Create Docker image
                    sh '''
                        docker build -t ${DOCKER_IMAGE} .
                        docker tag ${DOCKER_IMAGE} ${DOCKER_IMAGE}-${GIT_COMMIT_SHORT}
                    '''

                    // Create deployment archive
                    sh '''
                        tar -czf ${PROJECT_NAME}-${BUILD_NUMBER}.tar.gz \
                            -C ./publish .
                    '''
                }
            }
            post {
                success {
                    // Archive build artifacts
                    archiveArtifacts artifacts: '**/*.nupkg,**/*.tar.gz', allowEmptyArchive: true
                }
            }
        }

        stage('Deploy') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                    branch 'release/*'
                }
            }
            stages {
                stage('Deploy to Staging') {
                    when {
                        anyOf {
                            branch 'develop'
                            branch 'release/*'
                        }
                    }
                    steps {
                        echo 'Deploying to staging environment...'
                        script {
                            // Deploy to staging
                            sh '''
                                # Push Docker image to registry
                                docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}

                                # Deploy using your deployment method (e.g., Kubernetes, Docker Compose, etc.)
                                # Example with kubectl:
                                # kubectl set image deployment/${PROJECT_NAME} ${PROJECT_NAME}=${DOCKER_REGISTRY}/${DOCKER_IMAGE}

                                # Or with Docker Compose:
                                # docker-compose -f docker-compose.staging.yml up -d
                            '''
                        }
                    }
                }

                stage('Deploy to Production') {
                    when {
                        branch 'main'
                    }
                    steps {
                        echo 'Deploying to production environment...'
                        script {
                            // Manual approval for production deployment
                            input message: 'Deploy to production?', ok: 'Deploy',
                                  submitterParameter: 'APPROVER'

                            // Deploy to production
                            sh '''
                                # Push Docker image to registry
                                docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}

                                # Deploy to production
                                # kubectl set image deployment/${PROJECT_NAME} ${PROJECT_NAME}=${DOCKER_REGISTRY}/${DOCKER_IMAGE}

                                # Or with Docker Compose:
                                # docker-compose -f docker-compose.prod.yml up -d
                            '''
                        }
                    }
                    post {
                        success {
                            echo "Successfully deployed to production by ${env.APPROVER}"
                            // Send notifications
                            emailext (
                                subject: "${PROJECT_NAME} - Production Deployment Successful",
                                body: "Build ${BUILD_NUMBER} has been successfully deployed to production.",
                                to: "${env.CHANGE_AUTHOR_EMAIL},devops@company.com"
                            )
                        }
                        failure {
                            echo 'Production deployment failed!'
                            // Send failure notifications
                            emailext (
                                subject: "${PROJECT_NAME} - Production Deployment Failed",
                                body: "Build ${BUILD_NUMBER} failed to deploy to production.",
                                to: "${env.CHANGE_AUTHOR_EMAIL},devops@company.com"
                            )
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed!'
            // Clean up workspace
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded!'
            // Send success notifications for main branch
            script {
                if (env.BRANCH_NAME == 'main') {
                    slackSend(
                        channel: '#deployments',
                        color: 'good',
                        message: ":white_check_mark: ${PROJECT_NAME} - Build ${BUILD_NUMBER} completed successfully!"
                    )
                }
            }
        }
        failure {
            echo 'Pipeline failed!'
            // Send failure notifications
            emailext (
                subject: "${PROJECT_NAME} - Build ${BUILD_NUMBER} Failed",
                body: "Build ${BUILD_NUMBER} failed. Please check the Jenkins logs for details.",
                to: "${env.CHANGE_AUTHOR_EMAIL},team@company.com"
            )
            slackSend(
                channel: '#ci-cd',
                color: 'danger',
                message: ":x: ${PROJECT_NAME} - Build ${BUILD_NUMBER} failed!"
            )
        }
        unstable {
            echo 'Pipeline is unstable!'
            // Send unstable notifications
            slackSend(
                channel: '#ci-cd',
                color: 'warning',
                message: ":warning: ${PROJECT_NAME} - Build ${BUILD_NUMBER} is unstable!"
            )
        }
    }
}