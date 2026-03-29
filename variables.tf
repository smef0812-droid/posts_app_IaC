variable "db_password" {
  type      = string
  default   = "RDS master password"
  sensitive = true
}