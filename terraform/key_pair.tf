#resource "aws_key_pair" "ssh_key" {
#  key_name   = var.ssh_key_name
#  public_key = file("${path.module}/ssh_key.pub")
#}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.ssh_key_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClMjzgoSvBe3bT7eGGJ/w7Tp2puFqjyGTAH5w4L9styxEnOTKtWvSh6QWF1fe1CoxFGMlijZCE3g1i1vfqdgk8t8O7CYS/Ge/B8jiX63ukCgUuzCSKvAiTLobq/lGQqi9/nIqz4sjXLJIR/SQKfY862oX1ZSHdhRgMwEceHDYcWAcoBiA+hudpLOXPw/Z5G0r2uCAbXISeINz0KXzTW0eyosoVI9A0vPdCs4isbfOZyy8wcqQYnzTkJfRimJlpikz/Zk4FSTmZ87XL7etUxRRjM72xHGCXbRu28cUsU59gYglxxk66fAwqplmvh/ktzaLUkNt+WFeylAthElQK954dUVVKjB9+3B/N5aLRYOSwqO0pnHnpPDWoUZtkX65CSTnMWEl2N8VNazuEa7vpiOlNF+W9TfkPFYrngaPsqUKrTfbyIRR3ETjOeLY1r+wCJNWn5D6GZZMjiDjaoRe/UA9GjNI1hqpU61oYllMJS2lgAva/OJaN9gJ7YPPu4Dya2BU= sasha@sasha-unix-machine"
}