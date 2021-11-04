resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.link.zone_id
  name    = var.host_name
  type    = "A"
  ttl     = "300"
  records = [aws_eip.jenkins_static_ip.public_ip]
}