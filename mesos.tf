# mesos master
resource "aws_instance" "mesos_master" {
  ami           = "${var.aws_master_ami}"
  instance_type = "t2.micro"

  tags {
    Name = "mesos_master"
  }

  subnet_id  = "${aws_subnet.mesos.id}"
  depends_on = ["aws_internet_gateway.gw", "aws_route53_zone.private"]
  key_name   = "${var.aws_key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.mesos.id}",
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_outbound.id}",
  ]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv DF7D54CBE56151BF",
      "echo deb http://repos.mesosphere.com/debian jessie main | sudo tee /etc/apt/sources.list.d/mesos.list",
      "sudo apt update",
      "sudo apt install -y --force-yes --no-install-recommends mesos",
      "echo ${self.private_ip} | sudo tee /etc/mesos-master/advertise_ip",
      "echo zk://zookeeper.${var.domain_name}:2181/mesos | sudo tee /etc/mesos/zk",
      "sudo systemctl start mesos-master",
      "sudo systemctl enable mesos-master",
      "sudo apt install -y -t jessie-backports  openjdk-8-jre-headless",
      "sudo mkdir -p /etc/marathon/conf",
      "echo gpu_resources | sudo tee /etc/marathon/conf/enable_features",
      "sudo apt install -y --no-install-recommends marathon",
      "sudo systemctl start marathon",
      "sudo systemctl enable marathon",
    ]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = "${file("${var.ssh_key_path}")}"
    }
  }
}

# mesos agent
resource "aws_instance" "mesos_agent" {
  ami           = "${var.aws_node_ami}"
  instance_type = "t2.micro"

  tags {
    Name = "mesos_agent"
  }

  subnet_id  = "${aws_subnet.mesos.id}"
  depends_on = ["aws_internet_gateway.gw", "aws_route53_zone.private"]
  key_name   = "${var.aws_key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.mesos.id}",
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_outbound.id}",
  ]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv DF7D54CBE56151BF",
      "echo deb http://repos.mesosphere.com/debian jessie main | sudo tee /etc/apt/sources.list.d/mesos.list",
      "sudo apt update",
      "sudo apt install -y --force-yes --no-install-recommends mesos",
      "echo ${self.private_ip} | sudo tee /etc/mesos-slave/advertise_ip",
      "echo appc,docker | sudo tee /etc/mesos-slave/image_providers",
      "echo zk://zookeeper.${var.domain_name}:2181/mesos | sudo tee /etc/mesos/zk",
      "echo docker/runtime,filesystem/linux,cgroups/devices | sudo tee /etc/mesos-slave/isolation",
      "sudo systemctl start mesos-slave",
      "sudo systemctl enable mesos-slave",
    ]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = "${file("${var.ssh_key_path}")}"
    }
  }

  count = "${var.mesos_regular_nodes}"
}

resource "aws_instance" "mesos_agent_gpu" {
  ami           = "${var.aws_node_gpu_ami}"
  instance_type = "${var.aws_node_gpu_size}"

  tags {
    Name = "mesos_agent_gpu"
  }

  subnet_id  = "${aws_subnet.mesos.id}"
  depends_on = ["aws_internet_gateway.gw", "aws_route53_zone.private"]
  key_name   = "${var.aws_key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.mesos.id}",
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_outbound.id}",
  ]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv DF7D54CBE56151BF",
      "echo deb http://repos.mesosphere.com/debian jessie main | sudo tee /etc/apt/sources.list.d/mesos.list",
      "sudo apt update",
      "sudo apt install -y --force-yes --no-install-recommends mesos",
      "echo ${self.private_ip} | sudo tee /etc/mesos-slave/advertise_ip",
      "echo appc,docker | sudo tee /etc/mesos-slave/image_providers",
      "echo zk://zookeeper.${var.domain_name}:2181/mesos | sudo tee /etc/mesos/zk",
      "echo docker/runtime,filesystem/linux,cgroups/devices,gpu/nvidia | sudo tee /etc/mesos-slave/isolation",
      "sudo systemctl start mesos-slave",
      "sudo systemctl enable mesos-slave",
    ]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = "${file("${var.ssh_key_path}")}"
    }
  }

  root_block_device = {
    volume_size = 30
  }

  count = "${var.mesos_gpu_nodes}"
}
