variable "repo_uri" {
  type    = string
  default = "099867171230.dkr.ecr.eu-west-2.amazonaws.com"
}
variable "image_target" {
  type    = string
  default = "terraria-server:latest"
}
locals {
  image_uri = "${var.repo_uri}/${var.image_target}"
}

# build docker image
resource "docker_image" "terraria_server" {
  name = "terraria-server"
  build {
    path = "."
    tag  = [local.image_uri, var.image_target]
    label = {
      author : "thomas"
    }
  }
  triggers = {
    file_sha1 = filesha1("${path.module}/Dockerfile")
  }
  depends_on = [
    aws_ecr_repository.terraria_server
  ]
}

# deploy docker image
resource "null_resource" "terraria_server_deploy" {
  triggers = {
    image_id = docker_image.terraria_server.image_id
  }
  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.region} --profile ${var.profile} | docker login -u AWS --password-stdin ${var.repo_uri} && docker push ${local.image_uri}"
  }
  depends_on = [
    docker_image.terraria_server
  ]
}
