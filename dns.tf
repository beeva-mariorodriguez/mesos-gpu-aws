resource "aws_route53_zone" "private" {
  name          = "${var.domain_name}"
  force_destroy = true
  vpc_id        = "${aws_vpc.mesos_vpc.id}"
}

resource "aws_route53_record" "mesos-master" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "mesos-master"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.mesos_master.private_ip}"]
}

resource "aws_route53_record" "marathon" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "marathon"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.mesos_master.private_ip}"]
}

resource "aws_route53_record" "zookeeper" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "zookeeper"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.zk.private_ip}"]
}
