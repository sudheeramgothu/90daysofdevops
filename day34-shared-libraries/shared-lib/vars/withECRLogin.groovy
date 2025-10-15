def call(Map args = [:], Closure body = null) {
  String region = args.get('region', 'us-east-1')
  String registry = args.get('registry', '')
  if (!registry) { error 'withECRLogin: `registry` is required' }
  try {
    sh "aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${registry}"
    if (body != null) { body() }
  } finally {
    sh 'docker logout || true'
  }
}
