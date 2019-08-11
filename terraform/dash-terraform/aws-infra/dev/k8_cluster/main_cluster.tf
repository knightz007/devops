# Specify the provider
provider "aws" {
  shared_credentials_file = "${file("~/.aws/credentials")}"
  region                  = "${var.provider_region}"
}

# Create VPC
module "dev_eks_vpc" {
  source = "../../modules/vpc"
}

# Create cluster IAM
module "cluster_iam" {
  source = "../../modules/eks_iam"
}

# Create cluster security groups
module "cluster_sg" {
  vpc_id = "${module.dev_eks_vpc.vpc_id}"
  source = "../../modules/eks_master_cluster_sg"
}

# Create cluster
module "eks_cluster" {
  cluster-arn        = "${module.cluster_iam.cluster-arn}"
  cluster_sg_id      = "${module.cluster_sg.cluster_sg_id}"
  aws_subnet_ids     = ["${module.dev_eks_vpc.aws_subnet_ids}"]
  iam_cluster_policy = "${module.cluster_iam.iam_cluster_policy}"
  iam_service_policy = "${module.cluster_iam.iam_service_policy}"
  source             = "../../modules/k8_cluster"

}

# Create worker node iam
module "worker_node_iam" {
  cluster_endpoint = "${module.eks_cluster.cluster_endpoint}"
  source           = "../../modules/eks_worker_nodes_iam"
}

# Create worker node sg
module "worker_node_sg" {
  vpc_id                    = "${module.dev_eks_vpc.vpc_id}"
  cluster-name              = "terraform-eks-demo"
  cluster_security_group_id = "${module.cluster_sg.cluster_sg_id}"
  iam_node_name             = "${module.worker_node_iam.iam_node_name}"
  source                    = "../../modules/eks_worker_nodes_sg"
}

# Create access for Worker node to master
module "worker_master_access" {
  cluster_security_group_id = "${module.cluster_sg.cluster_sg_id}"
  node_security_group_id    = "${module.worker_node_sg.node_sg_id}"
  source                    = "../../modules/eks_worker_master_access"
}

# Create worker node autoscaling group
module "worker_autoscaling_group" {
  master_cluster_version  = "${module.eks_cluster.cluster_version}"
  master_cluster_endpoint = "${module.eks_cluster.cluster_endpoint}"
  master_cluster_ca_data  = "${module.eks_cluster.cluster_ca_data}"
  cluster-name            = "terraform-eks-demo"
  node_security_group_id  = "${module.worker_node_sg.node_sg_id}"
  aws_subnet_ids          = ["${module.dev_eks_vpc.aws_subnet_ids}"]
  source                  = "../../modules/eks_worker_autoscaling_group"
}


locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${module.worker_node_iam.iam_node_arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}

output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
}



# output "cluster_master_ip" {
#   value = "${module.dev_k8_cluster.cluster_master_ip}"
# }
