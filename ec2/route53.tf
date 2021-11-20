resource "aws_route53_record" "wordpress1" {
  zone_id = "Z0195983MG9WNG6OJ115"
  name    = "wordpress.timgrib.com"
   type    = "A"
   ttl     = "300"
   records = [aws_instance.web.public_ip]
}