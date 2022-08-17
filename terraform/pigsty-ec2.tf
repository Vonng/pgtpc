#################################
## SSH KEY (REPLACE THIS!!!!)
#################################
# ssh-keygen -t rsa -N '' -f ~/.ssh/pigsty-key

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "pigsty_key" {
  key_name   = "pigsty-key"
  public_key = file("~/.ssh/pigsty-key.pub")
}

#################################
## INSTANCES
#################################
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "pg-meta-1" {
  ami                         = "ami-01cb2ecea35798f3f"
  instance_type               = "z1d.2xlarge"
  key_name                    = "pigsty-key"
  private_ip                  = "10.10.10.10"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.pigsty_sg.id]
  subnet_id                   = aws_subnet.pigsty_subnet.id
  user_data                   = file("userdata.tpl")

  root_block_device {
    volume_size = 640
  }

  tags = {
    Name        = "Pigsty Meta Node"
    VPC         = aws_vpc.pigsty_vpc.id
    Project     = "pigsty"
    Environment = "dev"
    ManagedBy   = "terraform"
    cls         = "pg-meta"
    ins         = "pg-meta-1"
  }
}

################################
# INSTANCES 2  96C 192G 3.6GHz
################################
resource "aws_instance" "pg-test-1" {
  ami                         = "ami-01cb2ecea35798f3f"
  instance_type               = "c5d.metal"
  key_name                    = "pigsty-key"
  private_ip                  = "10.10.10.11"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.pigsty_sg.id]
  subnet_id                   = aws_subnet.pigsty_subnet.id
  user_data                   = file("userdata.tpl")

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name        = "Pigsty Test Node 1"
    VPC         = aws_vpc.pigsty_vpc.id
    Project     = "pigsty"
    Environment = "dev"
    ManagedBy   = "terraform"
    cls         = "pg-test"
    ins         = "pg-test-1"
  }
}


output "meta_ip" {
  value = aws_instance.pg-meta-1.public_ip
}
output "test_ip" {
  value = aws_instance.pg-test-1.public_ip
}

