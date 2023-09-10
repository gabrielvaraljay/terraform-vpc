# Create ALB Security Group
resource "aws_security_group" "alb-sg" {
    name = "alb-security-group"
    description = "ALB security group"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "alb-security-group"
    }
}

# Create ALB
resource "aws_alb" "alb" {
    name = "apache-alb"
    security_groups = [aws_security_group.alb-sg.id]
    subnets = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id]
}

# Creare target group
resource "aws_alb_target_group" "tg" {
    name = "apache-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id

    health_check {
      path = "/"
      port = 80
    }
  
}

# Create ALB listener
resource "aws_alb_listener" "https_listener" {
    load_balancer_arn = aws_alb.alb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      
      target_group_arn = aws_alb_target_group.tg.arn
      type = "forward"
    }
  
}