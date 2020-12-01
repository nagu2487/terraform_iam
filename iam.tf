resource "aws_iam_group" "naag-group" {
    name = "naag-group"
}

resource "aws_iam_policy_attachment" "naag-attach" {
    name = "naag-group-policy-attach"
    groups = [
        "${aws_iam_group.naag-group.name}"
    ]
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user" "admin1" {
    name = "naag-admin-user"
}

resource "aws_iam_user" "naag-admin-user-1"{
    name = "naag-admin-user-1"
}

resource "aws_iam_group_membership" "naag_users" {
    name = "naag_admin_users"
    users = [
        "${aws_iam_user.admin1.name}",
        "${aws_iam_user.naag-admin-user-1.name}"
    ]
    group = "${aws_iam_group.naag-group.name}"
}

resource "aws_iam_role" "s3-mybucket-role" {
  name = "s3-mybucket-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "s3-mybucket-role-instanceprofile" {
    name = "s3-mybucket-role"
    role = "${aws_iam_role.s3-mybucket-role.name}"
}

resource "aws_iam_role_policy" "s3-mybucket-role-policy" {
    name ="s3-mybucket-role-policy"
    role = "${aws_iam_role.s3-mybucket-role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::mybucket-c29df1",
              "arn:aws:s3:::mybucket-c29df1/*"
            ]
        }
    ]
}
EOF

}

output "warning" {
    value = "WARNING: make sure you're not using the AdministratorAccess policy for other users/groups/roles. If this is the case, don't run terraform destroy, but manually unlink the created resources"
}