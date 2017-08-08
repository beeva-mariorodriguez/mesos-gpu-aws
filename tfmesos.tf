# tfmesos framework

resource "aws_instance" "tfmesos_framework" {
  ami           = "${var.aws_master_ami}"
  instance_type = "t2.micro"

  tags {
    Name = "tfmesos_framework"
  }

  subnet_id  = "${aws_subnet.mesos.id}"
  depends_on = ["aws_internet_gateway.gw"]
  key_name   = "${var.aws_key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.mesos.id}",
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_outbound.id}",
  ]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common git",
      "curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -",
      "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv DF7D54CBE56151BF",
      "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/debian jessie stable'",
      "sudo apt update",
      "sudo apt install -y docker-ce",
      "echo ${aws_instance.mesos_master.private_ip} mesos-master | sudo tee -a /etc/hosts",
      "git clone https://github.com/douban/tfmesos",
    ]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = "${file("${var.ssh_key_path}")}"
    }
  }
}
