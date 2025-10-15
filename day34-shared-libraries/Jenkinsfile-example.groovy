@Library('devopslib@main') _

pipeline {
  agent { label 'docker-agent' }
  environment {
    IMAGE = "123456789012.dkr.ecr.us-east-1.amazonaws.com/demo/api"
    AWS_REGION = "us-east-1"
    SLACK_CHAN = "#devops-updates"
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Build & Test') {
      steps {
        sh '''
          cat > Dockerfile <<'EOF'
          FROM alpine:3.20
          RUN adduser -D app
          USER app
          CMD ["sh","-c","echo demo api on $HOSTNAME"]
          EOF
          echo "[test] run unit tests (placeholder)"
        '''
      }
    }
    stage('Docker Build & Push') {
      steps {
        script {
          def tag = org.devopsninja.Semver.shaOrBuild(env)
          dockerBuildPush(image: env.IMAGE, tag: tag, push: true, buildContext: '.')
        }
      }
    }
  }
  post {
    success { slackNotify(channel: env.SLACK_CHAN, status: 'SUCCESS', message: "Build #${env.BUILD_NUMBER} OK") }
    failure { slackNotify(channel: env.SLACK_CHAN, status: 'FAILURE', message: "Build #${env.BUILD_NUMBER} FAILED") }
  }
}
