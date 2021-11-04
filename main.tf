resource "aws_security_group" "jenkins_server" {
  name = "Jenkins Security Group"

  vpc_id = data.aws_vpc.default.id

  ingress {
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  ingress {
      from_port        = 8443
      to_port          = 8443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  ingress {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  ingress {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Purpose"]} SecurityGroup" })

}

# creating EC2 instance with Jenkins
resource "aws_instance" "jenkins_server" {
  
  ami                         = "ami-0affd4508a5d2481b"
  #ami = data.aws_ami.latest_amazon_linux.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.jenkins_server.id]
  monitoring                  = var.enable_detailed_monitoring
  key_name                    = "aws_adhoc"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 12           
  }
  associate_public_ip_address = true
  
    provisioner "file" {
      source      = "${path.module}/jenkins_package.tar.gz"
      destination = "package.tar.gz"
 
      connection {
         type        = "ssh"
         user        = "centos"
         host        = "${element(aws_instance.jenkins_server.*.public_ip, 0)}"
         private_key = "${file("~/.ssh/aws_adhoc.pem")}"      
      } 
    } 

   provisioner "remote-exec" {
      connection {
         type        = "ssh"
         user        = "centos"
         host        = "${element(aws_instance.jenkins_server.*.public_ip, 0)}"
         private_key = "${file("~/.ssh/aws_adhoc.pem")}"      
      } 

    inline = [
      "tar zxvf package.tar.gz",
      "rm package.tar.gz",
      "sudo chmod +x install_jenkins.sh",
      "./install_jenkins.sh"
    ]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Project"]} Server" })

}

resource "aws_eip" "jenkins_static_ip" {
  instance = aws_instance.jenkins_server.id
  tags = merge(var.common_tags, { Name = "${var.common_tags["Purpose"]} Server IP" })
}