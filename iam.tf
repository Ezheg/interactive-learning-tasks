locals {
  common_tags = {
    //Name = "DevOps"
    Env  = "Dev"
    Team = "DevOps"
  }
}

resource "aws_iam_user_group_membership" "DevOps" {
  user = aws_iam_user.user1.name

  groups = [
    aws_iam_group.group1.name,
  ]
}

resource "aws_iam_user" "user1" {
  name = "bob"
}

resource "aws_iam_group" "group1" {
  name = "sysusers"
}