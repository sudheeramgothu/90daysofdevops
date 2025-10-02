output "repository_urls" {
  value = { for k, r in aws_ecr_repository.this : k => r.repository_url }
}

output "ecr_push_policy_json" {
  value       = data.aws_iam_policy_document.ecr_push.json
  description = "Attach to CI/agents that need to push images"
}

output "ecr_pull_policy_json" {
  value       = data.aws_iam_policy_document.ecr_pull.json
  description = "Attach to runtimes that only need pull access"
}
