locals {
  common_tags = {
    Name = "r1soft"
    Env  = "Dev"
    Team = "DevOps"
  }
}




resource "aws_key_pair" "edv" {
  key_name   = "edv-key"
  public_key = file("~/.ssh/id_rsa.pub")
  tags       = local.common_tags
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}




resource "aws_instance" "web" {
  ami                    = "ami-04902260ca3d33422"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name               = aws_key_pair.edv.key_name
  availability_zone      = "us-east-1a"
  # user_data              = file("userdata.sh")
  tags = local.common_tags

}
resource "null_resource" "r1" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = aws_instance.web.public_dns
      user        = "ec2-user"
      agent       = "false"
      private_key = file("~/.ssh/id_rsa")
    }

    inline = ["echo 'connected!'",
      "sudo yum install wget -y",
      "sudo wget https://tim-repo-bucket.s3.amazonaws.com/r1soft.repo -P /etc/yum.repos.d/",
      "sudo yum install serverbackup-enterprise -y",
      "sudo serverbackup-setup --user admin --pass r1soft",
      "sudo /etc/init.d/cdp-server restart",
      "sudo serverbackup-setup --http-port 8080 --https-port 443",
    "sudo /etc/init.d/cdp-server restart"]

  }
}
