def call(Map args = [:]) {
  String channel = args.get('channel', '#builds')
  String status  = args.get('status', 'INFO')
  String message = args.get('message', '')
  String color   = (status == 'SUCCESS') ? 'good' : (status == 'FAILURE' ? 'danger' : '#CCCCCC')
  try { slackSend(channel: channel, color: color, message: message ?: "Build ${status}") }
  catch (Throwable t) { echo "[slackNotify] Slack send failed: ${t.message}" }
}
