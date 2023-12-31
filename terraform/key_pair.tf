resource "aws_key_pair" "ssh_key" {
  key_name   = "sasha-key"
  public_key = file("~/.ssh/id_rsa.pub")
}