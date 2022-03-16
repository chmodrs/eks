variable "private_subnets_ids" {
  type    = list(any)
  default = ["subnet-0ab107cfe864fd9b2", "subnet-0f97b775d930e9607", "subnet-069ea007cd2595024"]
}

variable "name" {
  default = "MPCE-POC-EKS"
}

variable "sufixo" {
  default = ""
}

variable "tags" {
  type = map(any)
  default = {
    TERRAFORM   = "true",
    ENVIRONMENT = "prd",
    CentroCusto = "EKS"
  }
}

variable "keypair_name" {
  type        = string
  description = "Keypair name"
  default     = "pgmbox-prod"
}

variable "nodesize" {
  default = "t3a.medium"
}

variable "node_disksize" {
  default = "30"
}

variable "eks_version" {
  default = "1.22"
}

variable "asg_max_size" {
  default = 60
}

variable "asg_min_size" {
  default = 1
}

variable "asg_desired_capacity" {
  default = 1
}

variable "nodesize_tools" {
  default = "t3a.medium"
}

variable "node_disksize_tools" {
  default = "30"
}


variable "asg_max_size_tools" {
  default = 1
}

variable "asg_min_size_tools" {
  default = 1
}

variable "asg_desired_capacity_tools" {
  default = 1
}

variable "eks_key_name" {
  default = "pgmbox-prod"
}

variable "vpc_id" {
  type        = string
  description = "VPC Id"
  default     = "vpc-0ee268f0f0b64d43f"
}

variable "vpc_security_group_ingress_cidr" {
  type        = list(string)
  description = "Security Groups List of VPC ingress CIDR"
  default     = []
}