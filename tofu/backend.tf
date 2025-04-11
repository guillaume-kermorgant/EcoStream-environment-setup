terraform {
# variables are passed in from .gitlab-ci.yml
  backend "http" {
    address = ""
    lock_address = ""
    unlock_address = ""
    username = ""
    password = ""
    lock_method    = "POST"
    unlock_method  = "DELETE"
  }
}