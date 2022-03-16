resource "aws_iam_role_policy" "autoscaler_policy" {
  name = "autoscaler_policy"
  role = aws_iam_role.eks_custom_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "AWSServiceRoleForAmazonEKSNodegroup_policy" {
  name = "AWSServiceRoleForAmazonEKSNodegroup_policy"
  role = aws_iam_role.eks_custom_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "SharedSecurityGroupRelatedPermissions",
        "Effect" : "Allow",
        "Action" : [
          "ec2:RevokeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:DescribeInstances",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:DeleteSecurityGroup"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringLike" : {
            "ec2:ResourceTag/eks" : "*"
          }
        }
      },
      {
        "Sid" : "EKSCreatedSecurityGroupRelatedPermissions",
        "Effect" : "Allow",
        "Action" : [
          "ec2:RevokeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:DescribeInstances",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:DeleteSecurityGroup"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringLike" : {
            "ec2:ResourceTag/eks:nodegroup-name" : "*"
          }
        }
      },
      {
        "Sid" : "LaunchTemplateRelatedPermissions",
        "Effect" : "Allow",
        "Action" : [
          "ec2:DeleteLaunchTemplate",
          "ec2:CreateLaunchTemplateVersion"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringLike" : {
            "ec2:ResourceTag/eks:nodegroup-name" : "*"
          }
        }
      },
      {
        "Sid" : "AutoscalingRelatedPermissions",
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:UpdateAutoScalingGroup",
          "autoscaling:DeleteAutoScalingGroup",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "autoscaling:CompleteLifecycleAction",
          "autoscaling:PutLifecycleHook",
          "autoscaling:PutNotificationConfiguration"
        ],
        "Resource" : "arn:aws:autoscaling:*:*:*:autoScalingGroupName/eks-*"
      },
      {
        "Sid" : "AllowAutoscalingToCreateSLR",
        "Effect" : "Allow",
        "Condition" : {
          "StringEquals" : {
            "iam:AWSServiceName" : "autoscaling.amazonaws.com"
          }
        },
        "Action" : "iam:CreateServiceLinkedRole",
        "Resource" : "*"
      },
      {
        "Sid" : "AllowASGCreationByEKS",
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:CreateOrUpdateTags",
          "autoscaling:CreateAutoScalingGroup"
        ],
        "Resource" : "*",
        "Condition" : {
          "ForAnyValue:StringEquals" : {
            "aws:TagKeys" : [
              "eks",
              "eks:cluster-name",
              "eks:nodegroup-name"
            ]
          }
        }
      },
      {
        "Sid" : "AllowPassRoleToAutoscaling",
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "iam:PassedToService" : "autoscaling.amazonaws.com"
          }
        }
      },
      {
        "Sid" : "AllowPassRoleToEC2",
        "Effect" : "Allow",
        "Action" : "iam:PassRole",
        "Resource" : "*",
        "Condition" : {
          "StringEqualsIfExists" : {
            "iam:PassedToService" : [
              "ec2.amazonaws.com",
              "ec2.amazonaws.com.cn"
            ]
          }
        }
      },
      {
        "Sid" : "PermissionsToManageResourcesForNodegroups",
        "Effect" : "Allow",
        "Action" : [
          "iam:GetRole",
          "ec2:CreateLaunchTemplate",
          "ec2:DescribeInstances",
          "iam:GetInstanceProfile",
          "ec2:DescribeLaunchTemplates",
          "autoscaling:DescribeAutoScalingGroups",
          "ec2:CreateSecurityGroup",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:RunInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:GetConsoleOutput",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSubnets"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "PermissionsToCreateAndManageInstanceProfiles",
        "Effect" : "Allow",
        "Action" : [
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:AddRoleToInstanceProfile"
        ],
        "Resource" : "arn:aws:iam::*:instance-profile/eks-*"
      },
      {
        "Sid" : "PermissionsToManageEKSAndKubernetesTags",
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateTags",
          "ec2:DeleteTags"
        ],
        "Resource" : "*",
        "Condition" : {
          "ForAnyValue:StringLike" : {
            "aws:TagKeys" : [
              "eks",
              "eks:cluster-name",
              "eks:nodegroup-name",
              "kubernetes.io/cluster/*"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "AmazonEKSClusterPolicy" {
  name = "AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_custom_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:UpdateAutoScalingGroup",
          "ec2:AttachVolume",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:CreateRoute",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteRoute",
          "ec2:DeleteSecurityGroup",
          "ec2:DeleteVolume",
          "ec2:DescribeInstances",
          "ec2:DescribeRouteTables",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:DescribeVpcs",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DetachVolume",
          "ec2:ModifyInstanceAttribute",
          "ec2:ModifyVolume",
          "ec2:RevokeSecurityGroupIngress",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
          "elasticloadbalancing:AttachLoadBalancerToSubnets",
          "elasticloadbalancing:ConfigureHealthCheck",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateLoadBalancerListeners",
          "elasticloadbalancing:CreateLoadBalancerPolicy",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteLoadBalancerListeners",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeLoadBalancerAttributes",
          "elasticloadbalancing:DescribeLoadBalancerPolicies",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeTargetGroupAttributes",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:DescribeTargetHealth",
          "elasticloadbalancing:DetachLoadBalancerFromSubnets",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyLoadBalancerAttributes",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:ModifyTargetGroupAttributes",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer",
          "elasticloadbalancing:SetLoadBalancerPoliciesOfListener",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "iam:CreateServiceLinkedRole",
        "Resource" : "*",
        "Condition" : {
          "StringLike" : {
            "iam:AWSServiceName" : "elasticloadbalancing.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "container_insights_policy" {
  name = "container_insights_policy"
  role = aws_iam_role.eks_custom_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "cloudwatch:*",
          "logs:*"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy" "efs_policy" {
  name = "efs_policy"
  role = aws_iam_role.eks_custom_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "elasticfilesystem:CreateAccessPoint"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringLike" : {
            "aws:RequestTag/efs.csi.aws.com/cluster" : "true"
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : "elasticfilesystem:DeleteAccessPoint",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "aws:ResourceTag/efs.csi.aws.com/cluster" : "true"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "eks_custom_role" {
  name = "eks_custom_role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}