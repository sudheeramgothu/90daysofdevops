pipeline {
  agent any
  parameters { string(name: 'UPSTREAM_JOB', defaultValue: 'day40-producer'); string(name: 'UPSTREAM_BUILD', defaultValue: 'lastSuccessfulBuild') }
  stages {
    stage('Copy Artifacts'){
      steps {
        copyArtifacts projectName: params.UPSTREAM_JOB,
                      selector: specific(params.UPSTREAM_BUILD),
                      filter: 'day40-artifact-archiving/dist/*, day40-artifact-archiving/reports/*',
                      fingerprintArtifacts: true
        sh 'ls -l day40-artifact-archiving/dist || true'
      }
    }
  }
}