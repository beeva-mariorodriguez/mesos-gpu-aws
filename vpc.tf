resource "aws_vpc" "mesos_vpc" {
  cidr_block           = "${var.aws_cidr_block}"
  enable_dns_hostnames = true

  tags {
    Terraformed = "true"
    Cluster     = "${var.cluster_name}"
  }
}

resource "aws_security_group" "allow_outbound" {
  vpc_id      = "${aws_vpc.mesos_vpc.id}"
  name        = "allow_outbound"
  description = "allow all outbound"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "mesos" {
  vpc_id      = "${aws_vpc.mesos_vpc.id}"
  name        = "mesos"
  description = "mesos"

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }
}

resource "aws_security_group" "allow_ssh" {
  vpc_id      = "${aws_vpc.mesos_vpc.id}"
  name        = "allow_ssh"
  description = "allow_ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "zookeeper" {
  vpc_id      = "${aws_vpc.mesos_vpc.id}"
  name        = "zookeeper"
  description = "zookeeper"

  # client communication from mesos sg
  ingress {
    from_port       = 2181
    to_port         = 2181
    protocol        = "tcp"
    security_groups = ["${aws_security_group.mesos.id}"]
    self            = true
  }

  # zookeeper cluster communication from zookeeper sg
  ingress {
    from_port = 2883
    to_port   = 2883
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port = 3883
    to_port   = 3883
    protocol  = "tcp"
    self      = true
  }
}

resource "aws_subnet" "mesos" {
  vpc_id                  = "${aws_vpc.mesos_vpc.id}"
  cidr_block              = "${var.aws_cidr_block}"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.mesos_vpc.id}"
}

resource "aws_route" "r" {
  route_table_id         = "rtb-4fbb3ac4"
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_vpc.mesos_vpc.default_route_table_id}"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}
