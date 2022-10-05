resource "aws_ecr_repository" "terraria_server" {
  name = "terraria-server"
  # image_tag_mutability = "IMMUTABLE"
  image_tag_mutability = "MUTABLE"
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = "arn:aws:kms:eu-west-2:099867171230:key/a1953919-fab4-4748-a0e7-8e9172676617"
  }
  image_scanning_configuration {
    scan_on_push = false
  }
}
resource "aws_ecr_registry_scanning_configuration" "terraria_server" {
  scan_type = "BASIC"
  rule {
    scan_frequency = "SCAN_ON_PUSH"
    repository_filter {
      filter      = "*"
      filter_type = "WILDCARD"
    }
  }
}
