package org.devopsninja
class Semver {
  static String shaOrBuild(def env) {
    def sha = env.GIT_COMMIT
    if (sha != null && sha.length() >= 7) { return sha.take(7) }
    return env.BUILD_NUMBER ?: "local"
  }
}
