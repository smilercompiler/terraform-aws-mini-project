# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
  #Step 1 Create a vpc
  resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    tags={
      Name = "production"
    }
  }
  #Step 2 Create InternetGateway
  resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.myvpc.id
  }

  #Step 3 Create a custom route table
  resource "aws_route_table" "myroutetable" {
    vpc_id = aws_vpc.myvpc.id
    route {
      cidr_block="0.0.0.0/0" //default
      gateway_id = aws_internet_gateway.myigw.id
    }
    tags = {
      Name = "Prod"
    }
  }

  #Step 4 Create a subnet
  resource "aws_subnet" "subnet_1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "prod-subnet"
    }
  }
#Step 5 Associate route table to subnet
resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.myroutetable.id
}
#Step 6 Create security group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id = aws_vpc.myvpc.id
  ingress{
    description="HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    description="HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    description="SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_web"
  }
}
#Step 7 Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "mynetint" {
  subnet_id = aws_subnet.subnet_1.id
  private_ips = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}
#Step 8 Assign an elastic IP to the network interface created in step 7
resource "aws_eip" "one" {
 domain = "vpc"
 network_interface = aws_network_interface.mynetint.id
 associate_with_private_ip = "10.0.1.50"
 depends_on = [ aws_internet_gateway.myigw ,
 aws_instance.web-server-instance]
}
#Step 9 Create an ubuntu server and install/enable apache
 resource "aws_instance" "web-server-instance" {
   ami = "ami-0ecb62995f68bb549"
   instance_type = "t2.micro"
   availability_zone = "us-east-1a"
   key_name = "myprojectkeypair"
   primary_network_interface {
     network_interface_id = aws_network_interface.mynetint.id
   }
  user_data = <<-EOF
#!/bin/bash
apt update -y
apt install -y apache2
systemctl enable apache2
systemctl start apache2
echo "your very first web server" > /var/www/html/index.html
EOF


tags = {
  Name = "web-server"
}
 }
