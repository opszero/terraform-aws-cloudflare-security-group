data "http" "ipv4" {
  url = "https://www.cloudflare.com/ips-v4"
}

data "http" "ipv6" {
  url = "https://www.cloudflare.com/ips-v6"
}

resource "aws_security_group" "cloudflare" {
  name        = "cloudflare-ingress"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "cloudflare-ingress"
  }
}

resource "aws_security_group_rule" "cloudflare" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = split("\n", data.http.ipv4.response_body)
  ipv6_cidr_blocks  = split("\n", data.http.ipv6.response_body)
  security_group_id = aws_security_group.cloudflare.id
}
