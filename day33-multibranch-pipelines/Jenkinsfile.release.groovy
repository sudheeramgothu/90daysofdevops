
pipeline {
  agent { label 'docker-agent' }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Release Build') {
      when { buildingTag() }
      steps {
        sh '''
          echo "Building release for tag ${TAG_NAME}"
          docker build -t example.com/org/demo-api:${TAG_NAME} .
          echo "Push image + create GitHub release notes (placeholder)"
        '''
      }
    }
  }
}
