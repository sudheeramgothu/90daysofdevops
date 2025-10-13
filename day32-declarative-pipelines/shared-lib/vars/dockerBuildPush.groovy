def call(Map args = [:]) {
  String image = args.image
  String tag = args.get('tag', 'latest')
  String ctx = args.get('buildContext', '.')
  String region = args.get('awsRegion', 'us-east-1')
  boolean loginAWS = args.get('loginWithAWSCLI', false)
  if (!image) { error 'dockerBuildPush: image is required' }
  sh "docker build -t ${image}:${tag} ${ctx}"
  if (loginAWS) { sh "aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${image}" }
  sh "docker push ${image}:${tag}"
}
