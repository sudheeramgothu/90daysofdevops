pipeline {
  agent { label 'docker-agent' }
  options {
    buildDiscarder(logRotator(numToKeepStr: '20'))
    timestamps()
    ansiColor('xterm')
    disableConcurrentBuilds()
    timeout(time: 20, unit: 'MINUTES')
  }
  parameters {
    choice(name: 'ENV', choices: ['dev', 'staging', 'prod'], description: 'Target environment')
    booleanParam(name: 'RUN_TESTS', defaultValue: true, description: 'Run unit tests')
  }
  environment {
    APP_NAME = 'sample-api'
    REGISTRY = 'example.com/org'
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Install') {
      steps { sh 'echo install deps' }
    }
    stage('Build') {
      steps { sh 'echo build artifacts' }
    }
    stage('Test') {
      when { expression { return params.RUN_TESTS } }
      steps { sh 'echo run unit tests' }
    }
    stage('Package Docker') {
      steps {
        writeFile file: 'Dockerfile', text: 'FROM alpine:3.20\nCMD ["sh","-lc","echo ${APP_NAME} on $HOSTNAME"]\n'
        sh 'docker build -t ${REGISTRY}/${APP_NAME}:${env.BUILD_NUMBER} .'
      }
    }
  }
  post {
    success { echo "OK" }
    always  { cleanWs() }
  }
}
