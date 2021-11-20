output "id" {
  value = aws_security_group.external_by_terraform.id
}
output "owner_id" {
  value = aws_security_group.external_by_terraform.owner_id
}
# output "region" {
#   value = "us-east-1"
# }
output "arn" {
  value = aws_security_group.external_by_terraform.arn
}
