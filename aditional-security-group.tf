resource "aws_security_group" "nodegroups_aditional_sg" {
  name        = "eks-nodegroup-aditional"
  description = "Allow connection betweeen nodegroups"
  vpc_id      = var.vpc_id

  ingress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.245.0.0/16"]
    #security_groups = [aws_security_group.nodegroups_aditional_sg2.id]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description = "Acesso aos nodes pela VPN"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.253.0.0/23"]
    #security_groups = [aws_security_group.nodegroups_aditional_sg2.id]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "eks-nodegroup-aditional"
  }
}
