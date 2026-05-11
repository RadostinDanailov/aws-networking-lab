resource "aws_key_pair" "this" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.public_key_path)
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

locals {
  web_user_data = <<-EOF
    #!/bin/bash
    set -e

    # Wait for apt locks
    while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
      sleep 1
    done

    apt-get update -y
    apt-get install -y nginx

    echo "Hello from ${var.project_name} web server" > /var/www/html/index.html

    systemctl restart nginx
    systemctl enable nginx
  EOF
}

# -------------------------
# WEB SERVERS (spread across 2 AZs)
# -------------------------

resource "aws_instance" "web" {
  count = 2

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = element(
    [aws_subnet.private_web_a.id, aws_subnet.private_web_b.id],
    count.index
  )

  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = false
  user_data                   = local.web_user_data

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  tags = {
    Name = "${var.project_name}-web-${count.index + 1}"
  }
}

# -------------------------
# DB SERVER (single AZ)
# -------------------------

resource "aws_instance" "db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_db.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  key_name               = aws_key_pair.this.key_name

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  tags = {
    Name = "${var.project_name}-db"
  }
}
