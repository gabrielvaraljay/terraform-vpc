# Create EC2 sg

resource "aws_security_group" "ec2" {
    name = "apache-ec2-sg"
    description = "apache-ec2-sg"
    vpc_id = aws_vpc.main.id

     ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb-sg.id]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ec2-security-group"
    }
}

# Create launch templates
resource "aws_launch_template" "apache_lt" {
    name = "apache_lt"
    description = "My apache launch template"
    image_id = var.ami
    instance_type = var.ec2_type

    vpc_security_group_ids = [aws_security_group.ec2.id]
    user_data = filebase64("scripts/install_apache.sh")

    tag_specifications {
      resource_type = "instance"
      tags = {
        Name = "apache-asg"
      }
    }
}