module "avm-res-containerservice-managedcluster" {
  source  = "Azure/avm-res-containerservice-managedcluster/azurerm"
  version = "0.1.3"
  resource_group_name = azurerm_resource_group.rg.name
  name = var.aks_cluster_name
  location = var.aks_location
  default_node_pool = (
    {
      name     = "default"
      node_count = var.aks_default_node_pool_node_count
      vm_size   = var.aks_default_node_pool_vm_size
    })
  managed_identities = {
    system_assigned = true
  }
  azure_active_directory_role_based_access_control = (
    { 
        admin_group_object_ids = [azuread_group.aks_admins.object_id]
        azure_rbac_enabled = true 
    })
  depends_on = [ azuread_group.aks_admins ]
}
