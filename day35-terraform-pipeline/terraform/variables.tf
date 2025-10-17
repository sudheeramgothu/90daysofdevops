variable "aws_region" { type=string default="us-east-1" }
variable "env" { type=string default="dev" }
variable "tags" { type=map(string) default={ project="90daysofdevops" owner="sudheeramgothu" } }
