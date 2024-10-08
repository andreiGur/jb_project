pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'andreigur5001/spring-petclinic'
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        SONARQUBE_HOST_URL = 'http://localhost:9000'
        SONARQUBE_TOKEN = 'sqa_7c407fba76ba23730d920d0cac9e513abc85226a'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/andreiGur/jb_project.git'
            }
        }
        stage('SonarQube Scan') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        docker.image('sonarsource/sonar-scanner-cli:latest').inside {
                            sh """
                            sonar-scanner \
                                -Dsonar.projectKey=spring-petclinic \
                                -Dsonar.sources=. \
                                -Dsonar.host.url=${SONARQUBE_HOST_URL} \
                                -Dsonar.login=${SONARQUBE_TOKEN}
                            """
                        }
                    }
                }
            }
        }
        stage('Build with Maven') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        docker.image("${DOCKER_IMAGE}:${env.BUILD_NUMBER}").push()
                        docker.image("${DOCKER_IMAGE}:${env.BUILD_NUMBER}").push('latest')
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'Build completed successfully'
        }
        failure {
            echo 'Build failed'
        }
    }
}
