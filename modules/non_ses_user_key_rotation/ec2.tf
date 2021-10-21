resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}

data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners      = ["amazon"]

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*-x86_64-ebs"]
 }
}