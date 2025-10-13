pipeline {
  agent { label 'docker-agent' }
  environment {
    ECR = '123456789012.dkr.ecr.us-east-1.amazonaws.com/sample-api'
    AWS_REGION = 'us-east-1'
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Login to ECR') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'aws-ecr-userpass', usernameVariable: 'AWSUSER', passwordVariable: 'AWSPASS')]) {
          sh 'echo "$AWSPASS" | docker login --username "$AWSUSER" --password-stdin "$ECR"'
        }
      }
    }
    stage('Use Token') {
      steps {
        withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
          sh 'echo "token starts: ${SONAR_TOKEN:0:4}****"'
        }
      }
    }
    stage('Use File Credential') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig-prod', variable: 'KUBECONFIG')]) {
          sh 'kubectl --kubeconfig "$KUBECONFIG" version --client'
        }
      }
    }
  }
}
