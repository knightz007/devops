resource "null_resource" "iam_cluster_service_policy" {
  provisioner "local-exec" {
    command = "echo ${var.iam_cluster_policy} ${var.iam_service_policy}"
  }
}

resource "aws_eks_cluster" "demo" {
  name = "${var.cluster-name}"
  # role_arn = "${aws_iam_role.demo-cluster.arn}"
  role_arn = "${var.cluster-arn}"

  vpc_config {
    security_group_ids = ["${var.cluster_sg_id}"]
    # subnet_ids         = ["${aws_subnet.demo.*.id}"]
    subnet_ids = flatten("${var.aws_subnet_ids}")
  }

  depends_on = [null_resource.iam_cluster_service_policy]

}

output "cluster_version" {
  value = "${aws_eks_cluster.demo.version}"
}

output "cluster_endpoint" {
  value = "${aws_eks_cluster.demo.endpoint}"
}

output "cluster_ca_data" {
  value = "${aws_eks_cluster.demo.certificate_authority.0.data}"
}
