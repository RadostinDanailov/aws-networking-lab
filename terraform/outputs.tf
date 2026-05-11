output "vpc_id" {
  value = aws_vpc.main.id
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "web_private_ips" {
  value = [for i in aws_instance.web : i.private_ip]
}

output "db_private_ip" {
  value = aws_instance.db.private_ip
}
