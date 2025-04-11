terraform {
  backend "http" {
    address = "https://gitlab.com/api/v4/projects/68895536/terraform/state/${var.env_name}"
    lock_address = "https://gitlab.com/api/v4/projects/68895536/terraform/state/${var.env_name}/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/68895536/terraform/state/${var.env_name}/lock"
    username = "${var.gitlab_username}"
    password = "${var.gitlab_token}"
  }
}