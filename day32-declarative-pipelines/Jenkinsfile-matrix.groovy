pipeline {
  agent none
  stages {
    stage('Matrix') {
      matrix {
        axes {
          axis { name 'OS'; values 'ubuntu', 'alpine' }
          axis { name 'PY'; values '3.10', '3.12' }
        }
        agent { label 'docker-agent' }
        stages {
          stage('Prep') { steps { sh 'echo "OS=$OS PY=$PY"' } }
          stage('Run') { steps { sh 'echo "Running on $OS / Python $PY"' } }
        }
      }
    }
  }
}
