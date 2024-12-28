pipeline {
    agent {
        label 'k8-master'
    }
    environment {
        DOCKERHUB_USERNAME = 'rupindervashisht'
        DOCKERHUB_REPO = 'beginner-html-site'
        KUBECONFIG = '/home/ubuntu/.kube/config'
    }
    triggers {
        pollSCM('* * * * *')
    }
    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = "v${env.BUILD_NUMBER}"
                    sh """
                    docker build -t ${DOCKERHUB_USERNAME}/${DOCKERHUB_REPO}:${imageTag} .
                    docker login -u ${DOCKERHUB_USERNAME} -p ${env.DOCKERHUB_PASSWORD}
                    docker push ${DOCKERHUB_USERNAME}/${DOCKERHUB_REPO}:${imageTag}
                    """
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    def imageTag = "v${env.BUILD_NUMBER}"
                    sh """
                    kubectl apply -f deployment.yaml
                    kubectl set image deployment/beginner-html-site beginner-html-site=${DOCKERHUB_USERNAME}/${DOCKERHUB_REPO}:${imageTag}
                    """
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
