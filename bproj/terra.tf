provider "aws" {
	region = "us-east-2"
}

data "aws_ami" "debian" { /* Image id data block */
  owners      = ["285398391915"]/*["979382823631"]*/
  most_recent = true
  filter {
    name  = "name"
    values = ["ami-ubuntu-16.04-*"]/*["bitnami-abantecart-*-linux-debian-9-x86_64-hvm-ebs"]*/
  }
}

output "debian_ami_id" { /* Image id output block (print in stdout) */
  value = data.aws_ami.debian.id
}

resource "aws_vpc" "main" { /* Vierual private cloud block */
  cidr_block        = "172.20.0.0/16"
  instance_tenancy  = "default"

  tags = {
    Name = "vpc_test"
  }
}

resource "aws_instance" "private_web" { /* Private instance block (with debian, nginx and test page) */
  ami        = data.aws_ami.debian.id
  instance_type = "t3.micro"
  user_data 		= templatefile("ws_provision.sh", {
                    target = ""
                  })
  network_interface {
    network_interface_id = aws_network_interface.private_iface.id
    device_index         = 0
  }
   
  tags = {
    Name = "Web server"
  }
}

resource "aws_instance" "public_web" {
  ami           = data.aws_ami.debian.id
  instance_type = "t3.micro"
  user_data 		= templatefile("proxy_provision.sh",{
                    target = "172.20.1.11"
                  })
  security_groups   = [aws_security_group.dflt_sg.id]

  /* this puts the instance in your public subnet, but translate to the private one */
  subnet_id                   = "${aws_subnet.public.id}"
  associate_public_ip_address = true
  tags = {
    Name = "Reverse proxy"
  }
}
