variable "environment" {
  description = "Environment for web cluster nodes."
}

variable "ami" {
  description = "AMI to be used for web cluster nodes."
}

variable "instance_type" {
  description = "Instance type for web cluster nodes"
}

variable "web_security_groups" {
  description = "Security groups for web cluster hosts"
  type        = "list"
}

variable "elb_security_groups" {
  description = "Security groups for elastic load balancer"
  type        = "list"
}

variable "key_name" {
  description = "The SSH keypair to be used for access"
}

variable "user_data" {
  description = "User data for web cluster node instantiation"

  default = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get -y upgrade
EOF
}

variable "subnet_ids" {
  description = "The ID of the subnet in which this host should be located"
  type        = "list"
}

variable "min_cluster_size" {
  description = "The minimum number of nodes in the cluster"
}

variable "max_cluster_size" {
  description = "The minimum number of nodes in the cluster"
}

variable "preferred_cluster_size" {
  description = "The minimum number of nodes in the cluster"
}
