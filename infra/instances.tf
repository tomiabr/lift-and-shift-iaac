resource "aws_key_pair" "vprof-prod-key" {
  key_name   = "vprof-key-name"
  public_key = file(var.PUB_KEY)
}
resource "aws_instance" "vprof-db01" {
  ami                    = var.AMIS-COS9[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  vpc_security_group_ids = [aws_security_group.vprofile-backend-SG.id]
  key_name               = aws_key_pair.vprof-prod-key.key_name
  tags = {
    Name    = "vprof-db01"
    Project = "vprof-prod"
  }
  connection {
    user        = var.USER
    private_key = file(var.PRIV_KEY)
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "userdata/mysql.sh"
    destination = "/tmp/mysql.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/mysql.sh",
      "sudo /tmp/mysql.sh"
    ]
  }
}
resource "aws_instance" "vprof-mc01" {
  ami                    = var.AMIS-COS9[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.vprof-prod-key.key_name
  vpc_security_group_ids = [aws_security_group.vprofile-backend-SG.id]
  tags = {
    Name    = "vprof-mc01"
    Project = "vprof-prod"
  }
  connection {
    user        = var.USER
    private_key = file(var.PRIV_KEY)
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "userdata/memcache.sh"
    destination = "/tmp/memcache.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/memcache.sh",
      "sudo /tmp/memcache.sh"
    ]
  }
}
resource "aws_instance" "vprof-rmq01" {
  ami                    = var.AMIS-COS9[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.vprof-prod-key.key_name
  vpc_security_group_ids = [aws_security_group.vprofile-backend-SG.id]
  tags = {
    Name    = "vprof-rmq01"
    Project = "vprof-prod"
  }
  connection {
    user        = var.USER
    private_key = file(var.PRIV_KEY)
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "userdata/rabbitmq.sh"
    destination = "/tmp/rabbitmq.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/rabbitmq.sh",
      "sudo /tmp/rabbitmq.sh"
    ]
  }
}

resource "aws_instance" "vprof-app01" {
  ami                    = var.AMIS-UBUNTU22[var.REGION]
  instance_type          = "t2.micro"
  availability_zone      = var.ZONE1
  key_name               = aws_key_pair.vprof-prod-key.key_name
  vpc_security_group_ids = [aws_security_group.vprofile-app-SG.id]
  tags = {
    Name    = "vprof-app01"
    Project = "vprof-prod"
  }
  connection {
    user        = var.USER
    private_key = file(var.PRIV_KEY)
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "tomcat_ubuntu.sh"
    destination = "/tmp/tomcat_ubuntu.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/tomcat_ubuntu.sh",
      "sudo /tmp/tomcat_ubuntu.sh"
    ]
  }
}

output "PublicIP" {
  value = aws_instance.vprof-app01.public_ip
}

output "PrivateIP" {
  value = aws_instance.vprof-app01.private_ip
}