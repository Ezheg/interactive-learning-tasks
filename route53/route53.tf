resource "aws_route53_record" "www" {
  zone_id = "Z0195983MG9WNG6OJ115"
  name    = "blog.timgrib.com"
   type    = "A"
   ttl     = "300"
   records = ["127.0.0.1"]

}



