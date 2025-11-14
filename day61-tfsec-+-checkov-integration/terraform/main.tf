
resource "random_id" "rand" { byte_length = 3 }

resource "aws_s3_bucket" "demo" {
  bucket = "devopsninja-day61-demo-${random_id.rand.hex}"
  tags = { project = "day61" }
}

resource "aws_security_group" "open_ssh" {
  name        = "open-ssh"
  description = "Allow SSH from anywhere (insecure demo)"
  vpc_id      = "vpc-xxxxxxxx"
  ingress { from_port=22 to_port=22 protocol="tcp" cidr_blocks=["0.0.0.0/0"] }
  egress  { from_port=0  to_port=0  protocol="-1" cidr_blocks=["0.0.0.0/0"] }
  tags = { project = "day61" }
}

data "aws_iam_policy_document" "wild" {
  statement { actions=["s3:*"] resources=["*"] effect="Allow" }
}

resource "aws_iam_policy" "wild_policy" {
  name   = "day61-wild-policy"
  policy = data.aws_iam_policy_document.wild.json
}
