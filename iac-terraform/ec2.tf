resource "aws_instance" "api_vm" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.api_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "api-gateway-vm"
  }
}

resource "aws_instance" "caller_worker_vm" {
  ami                    = var.ami_id
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.api_sg.id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "caller-worker-vm"
  }
}

resource "aws_instance" "inference_worker_vm" {
  ami                    = var.ami_id
  instance_type          = "t3.large"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.api_sg.id]
  key_name               = var.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "inference-worker-vm"
  }
}