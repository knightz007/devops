resource "aws_security_group_rule" "demo-cluster-ingress-node-https" {
  description = "Allow pods to communicate with the cluster API Server"
  from_port   = 443
  protocol    = "tcp"
  # security_group_id        = "${aws_security_group.demo-cluster.id}"
  security_group_id = "${var.cluster_security_group_id}"
  # source_security_group_id = "${aws_security_group.demo-node.id}"
  source_security_group_id = "${var.node_security_group_id}"
  to_port                  = 443
  type                     = "ingress"
}
