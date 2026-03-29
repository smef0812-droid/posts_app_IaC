resource "aws_vpc" "posts_app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "posts_app_vpc"
  }
}

#ALB用サブネット
resource "aws_subnet" "posts_app_public_subnet_a" {
  vpc_id                  = aws_vpc.posts_app_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "posts_app_public_a"
  }
}

resource "aws_subnet" "posts_app_public_subnet_b" {
  vpc_id                  = aws_vpc.posts_app_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "posts_app_public_b"
  }
}

#ec2用サブネット
resource "aws_subnet" "posts_app_private_subnet_a" {
  vpc_id            = aws_vpc.posts_app_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "posts_app_private_app_a"
  }
}

resource "aws_subnet" "posts_app_private_subnet_b" {
  vpc_id            = aws_vpc.posts_app_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "posts_app_private_app_b"
  }
}

#RDS用サブネット
resource "aws_subnet" "posts_app_private_subnet_db_a" {
  vpc_id            = aws_vpc.posts_app_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "posts_app_private_db_a"
  }
}

resource "aws_subnet" "posts_app_private_subnet_db_b" {
  vpc_id            = aws_vpc.posts_app_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "posts_app_private_db_b"
  }
}

resource "aws_internet_gateway" "posts_app_igw" {
  vpc_id = aws_vpc.posts_app_vpc.id
  tags = {
    Name = "main-igw"
  }
}

#ALB用ルートテーブル
resource "aws_route_table" "posts_app_public_rt" {
  vpc_id = aws_vpc.posts_app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.posts_app_igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "posts_app_public_assoc1" {
  subnet_id      = aws_subnet.posts_app_public_subnet_a.id
  route_table_id = aws_route_table.posts_app_public_rt.id
}

resource "aws_route_table_association" "posts_app_public_assoc2" {
  subnet_id      = aws_subnet.posts_app_public_subnet_b.id
  route_table_id = aws_route_table.posts_app_public_rt.id
}

#ec2用ルートテーブル
resource "aws_route_table" "posts_app_private_rt" {
  vpc_id = aws_vpc.posts_app_vpc.id

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "posts_app_private_assoc1" {
  subnet_id      = aws_subnet.posts_app_private_subnet_a.id
  route_table_id = aws_route_table.posts_app_private_rt.id
}

resource "aws_route_table_association" "posts_app_private_assoc2" {
  subnet_id      = aws_subnet.posts_app_private_subnet_b.id
  route_table_id = aws_route_table.posts_app_private_rt.id
}

#RDS用ルートテーブル
resource "aws_route_table" "posts_app_private_rt_db" {
  vpc_id = aws_vpc.posts_app_vpc.id

  tags = {
    Name = "private-rt-db"
  }
}

resource "aws_route_table_association" "posts_app_private_assoc_db1" {
  subnet_id      = aws_subnet.posts_app_private_subnet_db_a.id
  route_table_id = aws_route_table.posts_app_private_rt_db.id
}

resource "aws_route_table_association" "posts_app_private_assoc_db2" {
  subnet_id      = aws_subnet.posts_app_private_subnet_db_b.id
  route_table_id = aws_route_table.posts_app_private_rt_db.id
}