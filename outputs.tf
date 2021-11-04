output "jenkins_server_ip" {
  value = aws_eip.jenkins_static_ip.public_ip
}

output "jenkins_instance_id" {
  value = aws_instance.jenkins_server.id
}

output "jenkins_sg_id" {
  value = aws_security_group.jenkins_server.id
}

output "public-zone-id" {
  value = aws_route53_record.jenkins.id
}
