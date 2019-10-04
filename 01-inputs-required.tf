variable "subscription_id" {
  description                         = "Subscription ID to make the changes in"
}

variable "vnet-name" {
  description                         = "Name of the vnet"
}


variable "loadbalancer_username" {
  description                         = "Administrator username for the loadbalancer"
}

variable "loadbalancer_password" {
  description                         = "Administrator password for the loadbalancer"
}

variable "as3_username" {
  description                         = "Name of F5 AS3 user"  
}

variable "as3_password" {
  description                         = "F5 AS3 user password"  
}


variable "firewall_username" {
  description                         = "Administrator username for the firewall"
}
variable "firewall_password" {
  description                         = "Administrator password for the firewall"
}
variable "firewall_replicas" {
  description                         = "How many firewalls to deploy"
  default                             = 1
}
variable "firewall_name_prefix" {
  description                 = "Prefix to name the VMs with"
}

variable "environment" { }

variable "backend_storage_account_name" {
  description                             = "Storage Account Name"
}


variable "arm_client_id" { }
variable "arm_client_secret" { }
variable "arm_tenant_id" { }

variable "subscription_id" { }