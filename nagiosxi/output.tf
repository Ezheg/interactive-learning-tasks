output "name" {
  value = aws_route53_record.www.name
}
output "namelogin" {
  value = "administrator"
  # value = "c4df25c881c34319b1aa246e85ca00c8"
}
output "pass" {
  # value = "administrator"
  value = "c4df25c881c34319b1aa246e85ca00c8"
}