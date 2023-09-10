
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