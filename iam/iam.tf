locals {
  common_tags = {
    //Name = "DevOps"
    Env  = "Dev"
    Team = "DevOps"
  }
}
resource "aws_iam_user" "bob" {
  name = "bob"
  tags = {
    Name        = "DevOps"
      }
}

resource "aws_iam_group" "sysusers" {
  name = "sysusers"
}

resource "aws_iam_user_group_membership" "DevOps" {
  user = aws_iam_user.bob.name

  groups = [
    aws_iam_group.sysusers.name,
  ]
}

