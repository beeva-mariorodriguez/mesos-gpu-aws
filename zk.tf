# zookeeper server
resource "aws_instance" "zk" {
  ami           = "${var.aws_zk_ami}"
  instance_type = "t2.micro"

  tags {
    Name = "zookeeper"
  }

  subnet_id  = "${aws_subnet.mesos.id}"
  depends_on = ["aws_internet_gateway.gw"]
  key_name   = "${var.aws_key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.zookeeper.id}",
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_outbound.id}",
  ]

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y zookeeperd",
    ]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = "${file("${var.ssh_key_path}")}"
    }
  }
}
