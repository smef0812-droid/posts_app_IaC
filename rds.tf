resource "aws_db_subnet_group" "post_app_db_subnet_group" {
  name = "post-app-db-subnet-group"

  subnet_ids = [
    aws_subnet.posts_app_private_subnet_db_a.id,
    aws_subnet.posts_app_private_subnet_db_b.id
  ]

  tags = {
    Name = "post-app-db-subnet-group"
  }
}

resource "aws_db_instance" "post_app_db" {
  identifier     = "post-app-db"
  engine         = "mysql"
  engine_version = "8.0"

  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"

  db_name  = "postappdb"
  username = "admin"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.post_app_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  multi_az            = true
  publicly_accessible = false
  skip_final_snapshot = true

  tags = {
    Name = "post-app-db"
  }
}