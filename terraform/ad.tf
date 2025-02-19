

# Create Azure AD Group for AKS Administrators
resource "azuread_group" "aks_admins" {
    display_name     = "AKS-Cluster-Administrators-${var.aks_cluster_name}"
    security_enabled = true
    description      = "Administrators for AKS cluster management"
}

# Add members to the group
resource "azuread_group_member" "aks_admins_members" {
    for_each         = toset(var.aks_admin_emails)
    group_object_id  = azuread_group.aks_admins.object_id
    member_object_id = data.azuread_user.admin_users[each.key].object_id
}

# Get user objects from their email addresses
data "azuread_user" "admin_users" {
    for_each            = toset(var.aks_admin_emails)
    mail = each.key
}