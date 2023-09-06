resource "aws_security_group" "vprofile-ELB-SG" {
  name        = "vprofile-ELB-SG"
  description = "SG for vprof prod ELB"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ELB-SG"
  }
}
resource "aws_security_group" "vprofile-app-SG" {
  name        = "vprofile-app-SG"
  description = "SG for Tomcat instances"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow traffic from ELB"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.vprofile-ELB-SG.id]
  }
  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.MYIP]
  }
  ingress {
    description = "Allow HTTP from my IP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.MYIP]
  }
  tags = {
    Name = "app-SG"
  }
}
resource "aws_security_group" "vprofile-backend-SG" {
  name        = "vprofile-backend-SG"
  description = "SG for vprof backend svc"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 3306 from app servers"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.vprofile-app-SG.id]
  }
  ingress {
    description = "Allow 11211 from app servers"
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    security_groups = [aws_security_group.vprofile-app-SG.id]
  }
  ingress {
    description = "Allow 5672 from app servers"
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    security_groups = [aws_security_group.vprofile-app-SG.id]
  }
  ingress {
     description = "Allow internal traffic"
     from_port   = 0
     to_port     = 0
     protocol    = "tcp"
     self = true
  #   cidr_blocks = [aws_security_group.vprofile-backend-SG.id]
  }
  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.MYIP]
  }
  tags = {
    Name = "backend-svc-SG"
  }
}