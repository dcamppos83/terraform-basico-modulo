data "aws_vpc" "main" {
  default = true
}

data "aws_security_group" "default" {
  
  filter {
    name = "group-name"
    values = ["default"]
  }

  tags = {
    "produto" = "default"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

# data "aws_ami" "ubuntu-west" {
#   provider = aws.west

#   most_recent = true

#   filter {
#     name = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   owners = ["099720109477"]
# }

resource "aws_instance" "web" {
    #count = var.servers
    count = var.environment == "production" ? 2 : 1
    ami = data.aws_ami.ubuntu.id
    instance_type = count.index < 1 ? "t2.nano" : "t2.micro"
    #vpc_security_group_ids = var.securityGroup
    vpc_security_group_ids = var.enable_sg ? aws_security_group.main[*].id : [data.aws_security_group.default.id] // o data retorna uma string, entao coloco entre [] para virar uma lista

    ebs_block_device {
      device_name = "/dev/sdg"
      volume_size = 1
      volume_type = "gp2"
      delete_on_termination = true
    }

    tags = {
      "Name" = "HelloWorld"
      "Env" = var.environment
    }
}

# resource "aws_instance" "web2" {
#     ami = data.aws_ami.ubuntu.id
#     for_each = toset(var.instance_type) // o toset transforma o conteúdo da variavel em um set
#     instance_type = each.value // neste caso posso usar o each.value ou o each.key
#     #instance_type = "t2.micro"

#     dynamic "ebs_block_device" {
#       for_each = toset(var.blocks)
#       content {
#         device_name = ebs_block_device.value["device_name"]
#         volume_size = ebs_block_device.value["volume_size"]
#         volume_type = ebs_block_device.value["volume_type"]
#       }
#     }

#     # for_each = {
#     #   k1 = "dev"
#     #   k2 = "stg"
#     # }

#     # tags = {
#     #   "teste" = each.value
#     # }
# }

# resource "aws_instance" "web-west" {
#     provider = aws.west
#     count = var.servers
#     ami = data.aws_ami.ubuntu-west.id
#     instance_type = "t2.nano"

#     tags = {
#       "Name" = "HelloWorld"
#     }
# }

resource "aws_security_group" "main" {
  count = var.enable_sg ? 1 : 0
  name = "allow-traffic-${var.name}"
  vpc_id = data.aws_vpc.main.id

  # ingress {
  #   description = "Port 443"
  #   from_port = 443
  #   to_port = 443
  #   protocol = "tcp"
  #   cidr_blocks = [ "0.0.0.0/0" ]
  # }

  # ingress {
  #   description = "Port 80"
  #   from_port = 80
  #   to_port = 80
  #   protocol = "tcp"
  #   cidr_blocks = [ "0.0.0.0/0" ]
  # }

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port = ingress.value.port
      to_port = ingress.value.port
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_eip" "ip" {
  #count = var.servers
  count = var.environment == "production" ? 2 : 1
  vpc = true
  instance = aws_instance.web[count.index].id
}