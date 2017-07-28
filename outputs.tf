output "aws_cidr_block" {
  value = "${aws_vpc.mesos_vpc.cidr_block}"
}

output "aws_vpc_id" {
  value = "${aws_vpc.mesos_vpc.id}"
}

output "aws_azs" {
  value = "${var.aws_azs}"
}

output "aws_region" {
  value = "${var.aws_region}"
}
