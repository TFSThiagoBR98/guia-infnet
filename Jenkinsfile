pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        IMAGE_NAME             = 'tfsthiagobr98/guia-infnet'
        IMAGE_TAG              = 'latest'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
                echo "Codigo obtido com sucesso."
            }
        }

        stage('Build da Imagem Docker') {
            steps {
                sh """
                    docker build \
                        -t ${IMAGE_NAME}:${IMAGE_TAG} \
                        -t ${IMAGE_NAME}:build-${BUILD_NUMBER} \
                        .
                """
            }
        }

        stage('Push para Docker Hub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                sh "docker push ${IMAGE_NAME}:build-${BUILD_NUMBER}"
            }
        }

        stage('Deploy no Kubernetes') {
            steps {
                dir('k8s') {
                    sh "kubectl apply -f 2-redis-pod-service.yaml"
                    sh "kubectl apply -f 3-pvc.yaml"
                    sh "kubectl apply -f 1-app-deployment-service.yaml"
                    sh "kubectl rollout status deployment/guia-infnet-app-metadata --timeout=300s"
                    sh "kubectl get pods,svc"
                }
            }
        }

    }

    post {
        success {
            echo "Pipeline concluido com sucesso! Imagem: ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "Pipeline falhou. Verificar logs acima."
        }
        always {
            sh 'docker logout || true'
        }
    }
}
