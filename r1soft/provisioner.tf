# provisioner "file" {
#   source      = "conf/myapp.conf"
#   destination = "/etc/myapp.conf"

#   connection {
#     type     = "ssh"
#     user     = "root"
#     password = "${var.root_password}"
#     host     = "${var.host}"
#   }
# }