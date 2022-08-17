# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami

# ami-01cb2ecea35798f3f = centos on cn-northwest-1a
# data "aws_ami" "pigsty_centos7" {
#   # executable_users = ["self"]
#   most_recent      = true
#   name_regex       = "^CentOS-7-2003.*"
#   owners           = ["336777782633"]
# }

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
    iops        = 3000
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
# INSTANCES 2  96C 192G 4GHz 4T
################################
# resource "aws_instance" "pg-test-1" {
#   ami                         = "ami-01cb2ecea35798f3f"
#   instance_type               = "c5d.metal"
#   key_name                    = "pigsty-key"
#   private_ip                  = "10.10.10.11"
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [aws_security_group.pigsty_sg.id]
#   subnet_id                   = aws_subnet.pigsty_subnet.id
#   user_data                   = file("userdata.tpl")

#   root_block_device {
#     volume_size = 30
#   }
#   tags = {
#     Name        = "Pigsty Test Node 1"
#     VPC         = aws_vpc.pigsty_vpc.id
#     Project     = "pigsty"
#     Environment = "dev"
#     ManagedBy   = "terraform"
#     cls         = "pg-test"
#     ins         = "pg-test-1"
#   }
# }


################################
# INSTANCES2 4c-8g
################################
# resource "aws_instance" "pg-test-1" {
#   ami                         = "ami-01cb2ecea35798f3f"
#   instance_type               = "z1d.2xlarge"
#   key_name                    = "pigsty-key"
#   private_ip                  = "10.10.10.11"
#   associate_public_ip_address = true
#   vpc_security_group_ids      = [aws_security_group.pigsty_sg.id]
#   subnet_id                   = aws_subnet.pigsty_subnet.id
#   user_data                   = file("userdata.tpl")

#   root_block_device {
#      volume_type = "io1"
#      volume_size = 640
#      iops = 32000
#   }

#   tags = {
#     Name        = "Pigsty Test Node 1"
#     VPC         = aws_vpc.pigsty_vpc.id
#     Project     = "pigsty"
#     Environment = "dev"
#     ManagedBy   = "terraform"
#     cls         = "pg-test"
#     ins         = "pg-test-1"
#   }
# }



# c5d.xlarge
# z1d.metal
# c5d.metal 
# x1.32xlarge


# mkdir /data
# mkfs -t xfs /dev/nvme1n1;
# mount -t xfs /dev/nvme1n1 /data

output "meta_ip" {
  value = aws_instance.pg-meta-1.public_ip
}

