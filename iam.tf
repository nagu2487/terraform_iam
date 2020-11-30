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

output "warning" {
    value = "WARNING: make sure you're not using the AdministratorAccess policy for other users/groups/roles. If this is the case, don't run terraform destroy, but manually unlink the created resources"
}