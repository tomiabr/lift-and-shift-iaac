variable "REGION" {
  default = "us-east-1"
}
variable "ZONE1" {
  default = "us-east-1a"
}
variable "ZONE2" {
  default = "us-east-1b"
}
variable "ZONE3" {
  default = "us-east-1c"
}
variable "AMIS-COS9" {
  type = map(any)
  default = {
    us-east-1 = "ami-099eb8ae347032773"
    us-east-2 = "ami-02a89066c48741345"
  }
}
variable "AMIS-UBUNTU22" {
  type = map(any)
  default = {
    us-east-1 = "ami-053b0d53c279acc90"
    us-east-2 = "ami-02a89066c48741345"
  }
}
variable "USER" {
  default = "ec2-user"
}
variable "MYIP" {
  default = "190.195.52.103/32"
}
variable "PUB_KEY" {
  default = "tf-key.pub"
}
variable "PRIV_KEY" {
  default = "tf-key"
}