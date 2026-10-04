# ec2 servers

resource "aws_instance" "server1" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  user_data    = file("setup.sh")
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id     = aws_subnet.private1.id
  tags = {
    Name = "webserver1"
    env  = "dev"
  }
}

resource "aws_instance" "server2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  user_data    = file("setup.sh")
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id     = aws_subnet.private2.id
  tags = {
    Name = "webserver2"
    env  = "dev"
  }
}