
# Variable for vpc cider range
variable "vpc-cidr"{
    type = string
    default = "10.0.0.0/16"

}

# Give project a name
variable "project" {
    type = string
    default = "apache"
}

# Specify launch template AMI
variable "ami" {
    type = string
    default = "ami-0b1b00f4f0d09d131"
}

# Specify the instance type
variable "ec2_type" {
    type = string
    default = "t2.micro"
}