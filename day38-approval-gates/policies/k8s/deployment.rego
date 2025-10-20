package kubernetes.image
default allow = false
allow { startswith(input.image, "123456789012.dkr.ecr.") }
