locals {
  common_tags = {
    Name = "HelloWorld"
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
    from_port   = 3306
    to_port     = 3306
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


resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 100
  tags              = local.common_tags
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.web.id
}


resource "aws_instance" "web" {
  ami                    = "ami-ae6272b8"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name               = aws_key_pair.edv.key_name
  availability_zone      = "us-east-1a"
  user_data              = file("userdata.sh")
  tags                   = local.common_tags
}

resource "aws_route53_record" "wordpress" {
  zone_id = "Z0195983MG9WNG6OJ115"
  name    = "wordpress.timgrib.com"
   type    = "A"
   ttl     = "300"
   records = [aws_instance.web.public_ip]
}