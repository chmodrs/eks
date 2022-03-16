module "eks-cluster" {
  version                                            = "17.24.0"
  source                                             = "terraform-aws-modules/eks/aws"
  cluster_name                                       = "eks-${var.name}"
  subnets                                            = var.private_subnets_ids
  vpc_id                                             = var.vpc_id
  worker_create_cluster_primary_security_group_rules = true
  #cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  write_kubeconfig = false
  #worker_additional_security_group_ids = [aws_security_group.sg-eks-nodes.id]

  manage_aws_auth = false

  node_groups = {
    production = {
      desired_capacity = 1
      max_capacity     = 5
      min_capacity     = 1
      #name                          = "eks-${var.name}-ng"
      iam_role_arn                  = aws_iam_role.eks_custom_role.arn
      additional_security_group_ids = [aws_security_group.nodegroups_aditional_sg.id]

      key_name = "pgmbox-prod"

      #additional_security_group_ids = [aws_security_group.sg-eks-nodes.id]

      disk_size = var.node_disksize

      capacity_type = "SPOT"

      root_volume_type = "gp3"
      public_ip        = false

      k8s_labels = {
        Name = "eks-worker-prd-${var.name}"
        role = "production"
      }

      instance_types = [var.nodesize]
      tags = [{
        key                 = "SERVICE",
        value               = "EKS",
        propagate_at_launch = true
        }, {
        key                 = "Name",
        value               = "eks-${var.name}-node",
        propagate_at_launch = true
        }, {
        key                 = "EKS_CLUSTER",
        value               = "eks-${var.name}",
        propagate_at_launch = true
      }]
    },
  }

  cluster_version = var.eks_version

  tags = merge({
    Name = "eks-${var.name}"
    },
  var.tags)

}
