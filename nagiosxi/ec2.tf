locals {
  common_tags = {
    Name = "Jenkins"
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
    from_port   = 8080
    to_port     = 8080
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

resource "aws_route53_record" "www" {
  zone_id = "Z0195983MG9WNG6OJ115"
  name    = "jenkins.timgrib.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.web.public_ip]
}
# resource "null_resource" "web" {
#   # Changes to any instance of the cluster requires re-provisioning
#   triggers =   {
#     aws_instance_ids =  "aws_instance.web.id"
#   }
#   }
resource "null_resource" "example" {
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
      "sudo wget -O /etc/yum.repos.d/jenkins.repo  https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
       "sudo amazon-linux-extras install epel -y",
       "sudo yum upgrade -y",
      "sudo yum install jenkins java-1.8.0-openjdk-devel -y",
      "sudo yum install jenkins -y",
      "sudo systemctl daemon-reload",
      "sudo systemctl start jenkins", ]

  }
  # connection {
  #   type        = "ssh"
  #   user        = "ec2-user"
  #   private_key = file("~/.ssh/id_rsa")
  #   port = "22"
  #   host        = "aws_instance.web.public_ip"
  #   agent = "true"
  #   timeout = "10m"

  # }



  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum install wget -y",
  #     "sudo wget -O /etc/yum.repos.d/jenkins.repo  https://pkg.jenkins.io/redhat-stable/jenkins.repo",
  #     "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
  #     "sudo yum upgrade",
  #     "sudo yum install epel-release java-11-openjdk-devel",
  #     "sudo yum install jenkins",
  #     "sudo systemctl daemon-reload",
  #     "sudo systemctl start jenkins",
  #   ]
}