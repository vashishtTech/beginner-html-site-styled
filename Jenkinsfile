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
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh """
                        docker build -t ${USERNAME}/${DOCKERHUB_REPO}:${imageTag} .
                        echo "${PASSWORD}" | docker login -u "${USERNAME}" --password-stdin
                        docker push ${USERNAME}/${DOCKERHUB_REPO}:${imageTag}
                        """
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    def imageTag = "v${env.BUILD_NUMBER}"
                    sh """
                    kubectl apply -f Deployment.yaml
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
