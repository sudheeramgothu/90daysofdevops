pipeline {
  agent { label 'docker-agent' }
  stages {
    stage('Parallel Fan-Out') {
      parallel {
        stage('Lint') { steps { sh 'echo lint && sleep 1' } }
        stage('Unit Tests') { steps { sh 'echo unit && sleep 1' } }
        stage('Integration') { steps { sh 'echo integ && sleep 1' } }
      }
    }
  }
}
