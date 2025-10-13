@Library('devopslib@main') _
pipeline {
  agent { label 'docker-agent' }
  environment {
    IMAGE = "123456789012.dkr.ecr.us-east-1.amazonaws.com/sample-api"
    TAG   = "${env.GIT_COMMIT ?: env.BUILD_NUMBER}"
    AWS_REGION = "us-east-1"
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Hello from lib') { steps { hello(name: 'DevOps Ninjas') } }
    stage('Build & Push via lib') {
      steps {
        dockerBuildPush(image: env.IMAGE, tag: env.TAG, buildContext: '.', awsRegion: env.AWS_REGION, loginWithAWSCLI: true)
      }
    }
  }
}
