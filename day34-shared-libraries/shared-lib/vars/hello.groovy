def call(Map args = [:]) {
  String name = args.get('name', 'world')
  echo "👋 Hello, ${name}! (from devopslib)"
}
