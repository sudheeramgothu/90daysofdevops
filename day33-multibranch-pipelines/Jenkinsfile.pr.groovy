
pipeline {
  agent { label 'docker-agent' }
  options { timestamps(); ansiColor('xterm') }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Lint & Unit') {
      steps { sh 'bash scripts/quality.sh && bash scripts/test.sh' }
      post { always { junit 'reports/junit/*.xml' } }
    }
  }
  post { success { echo "PR checks passed" } }
}
