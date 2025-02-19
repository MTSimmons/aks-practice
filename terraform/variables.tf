#ARM Configuration
variable "ARM_CLIENT_ID" { type = string }
variable "ARM_CLIENT_SECRET" { type = string }
variable "ARM_SUBSCRIPTION_ID" { type = string }
variable "ARM_TENANT_ID" { type = string }


# Variables declaration
variable "resource_group_name" {
    type        = string
    description = "Name of the resource group"
}

variable "resource_group_location" {
    type        = string
    description = "Location of the resource group"
}

# AKS

variable "aks_cluster_name" {
    type        = string
    description = "Name of the AKS cluster"
}

variable "aks_location" {
    type        = string
    description = "Location of the AKS cluster"  
}   

variable "aks_default_node_pool_vm_size" {
    type        = string
    description = "VM size of the default node pool"
}

variable "aks_default_node_pool_node_count" {
    type        = number
    description = "Node count of the default node pool"
}

# Variable for admin email addresses
variable "aks_admin_emails" {
    type        = list(string)
    description = "List of email addresses for AKS administrators"
}