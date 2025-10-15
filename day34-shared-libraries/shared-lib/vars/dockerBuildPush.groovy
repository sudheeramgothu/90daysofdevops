def call(Map args = [:], Closure body = null) {
  String image = args.image
  String tag   = args.get('tag', 'latest')
  String ctx   = args.get('buildContext', '.')
  boolean push = args.get('push', false)
  String region  = args.get('region', 'us-east-1')

  if (!image) { error 'dockerBuildPush: `image` is required' }
  if (body != null) { body() }

  sh "docker build -t ${image}:${tag} ${ctx}"

  if (push) {
    if (image.contains('.dkr.ecr.')) {
      def registry = image.substring(0, image.indexOf('/'))
      withECRLogin(region: region, registry: registry) {
        sh "docker push ${image}:${tag}"
      }
    } else {
      sh "docker push ${image}:${tag}"
    }
  }
  echo "Docker image: ${image}:${tag}"
}
