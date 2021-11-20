output "name" {
  value = aws_key_pair.ilearning-wordpress.key_name
}
output "id" {
  value = aws_key_pair.ilearning-wordpress.key_pair_id
}
output "region" {
  value = "${data.aws_region.current.name}"
}
