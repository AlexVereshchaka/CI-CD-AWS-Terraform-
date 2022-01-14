provider "aws" {
  region = "eu-central-1"
  access_key = "AKIA4F6RVAJIJRGCURFU"
  secret_key = "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"
}


resource "aws_instance" "my_webserver" {
  ami                    = "ami-0d527b8c289b4af7f"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
    key_name = "Frankfurt"
  user_data              = <<EOF
      #!/bin/bash
     sudo apt install -y openjdk-8-jre-headless
      wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
      sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
      sudo apt update
      sudo apt install -y jenkins
      sudo systemctl start jenkins
      sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
      sudo sh -c \"iptables-save > /etc/iptables.rules\"
      echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
      echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
      sudo apt-get -y install iptables-persistent
      sudo ufw allow 8080
      EOF
      

  tags = {
    Name = "Web Server"
    Owner = "Alexey Vereshchaka"
  }
}


resource "aws_security_group" "my_webserver" {
  name = "WebServer Security Group"
  description = "SecurityGroup"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {   
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Server SecurityGroup"
    Owner = "Alexey Vereshchaka"
  }
}
#//
resource "aws_instance" "my_webserver2" {
  ami                    = "ami-0d527b8c289b4af7f"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  key_name = "Frankfurt"
  user_data              = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install apt-transport-https -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update -y
sudo apt install docker-ce -y
sudo systemctl status docker 
sudo usermod -aG docker $USER
EOF

  tags = {
    Name = "Web Server2"
    Owner = "Alexey Vereshchaka"
  }
}


resource "aws_security_group" "my_webserver2" {
  name = "WebServer Security Group2"
  description = "SecurityGroup"

  ingress {   
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Server SecurityGroup"
    Owner = "Alexey Vereshchaka"
  }
}
