resource "aws_key_pair" "ssh_key" {
  key_name   = "mza-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "tls_private_key" "ssh_key_pair" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "generated_ssh_key" {
  key_name   = "bastion-key"
  public_key = tls_private_key.ssh_key_pair.public_key_openssh
}

resource "aws_security_group" "sg" {
  name   = var.sg_name
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.sg_ingress_list
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu_arm" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "public_instance" {
  ami                         = data.aws_ami.ubuntu_arm.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = data.terraform_remote_state.vpc.outputs.public_subnet_id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh_key.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo "${tls_private_key.ssh_key_pair.private_key_openssh}" > /home/ubuntu/bastion-key
              chmod 400 /home/ubuntu/bastion-key
              chown ubuntu:ubuntu /home/ubuntu/bastion-key
              EOF


  tags = {
    Name = var.public_instance_name
  }
}

resource "aws_instance" "private_instance" {
  ami                         = data.aws_ami.ubuntu_arm.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = data.terraform_remote_state.vpc.outputs.private_subnet_id
  associate_public_ip_address = false
  key_name                    = aws_key_pair.generated_ssh_key.key_name


  tags = {
    Name = var.private_instance_name
  }
}
