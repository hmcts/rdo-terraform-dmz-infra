
data "azurerm_resource_group" "rg-dmz" {
  name                                      = "hmcts-dmz-${var.environment}"
}

data "azurerm_virtual_network" "vnet-dmz" {
  name                                      = "hmcts-dmz-${var.environment}"
  resource_group_name                       = "${data.azurerm_resource_group.rg-dmz.name}"
}

data "azurerm_subnet" "subnet-dmz-mgmt" {
  name                                      = "dmz-mgmt"
  resource_group_name                       = "${data.azurerm_resource_group.rg-dmz.name}"
  virtual_network_name                      = "${data.azurerm_virtual_network.vnet-dmz.name}"
}

data "azurerm_subnet" "subnet-dmz-loadbalancer" {
  name                                      = "dmz-loadbalancer"
  resource_group_name                       = "${data.azurerm_resource_group.rg-dmz.name}"
  virtual_network_name                      = "${data.azurerm_virtual_network.vnet-dmz.name}"
}

data "azurerm_subnet" "subnet-dmz-proxy" {
  name                                      = "dmz-proxy"
  resource_group_name                       = "${data.azurerm_resource_group.rg-dmz.name}"
  virtual_network_name                      = "${data.azurerm_virtual_network.vnet-dmz.name}"
}


data "azurerm_subnet" "subnet-dmz-palo-private" {
  name                                      = "dmz-palo-private"
  resource_group_name                       = "${data.azurerm_resource_group.rg-dmz.name}"
  virtual_network_name                      = "${data.azurerm_virtual_network.vnet-dmz.name}"
}

data "azurerm_subnet" "subnet-dmz-palo-public" {
  name                                      = "dmz-palo-public"
  resource_group_name                       = "${data.azurerm_resource_group.rg-dmz.name}"
  virtual_network_name                      = "${data.azurerm_virtual_network.vnet-dmz.name}"
}

data "azurerm_virtual_network" "vnet" {
  name                                      = "hmcts-hub-${var.environment}"
  resource_group_name                       = "hmcts-hub-${var.environment}"
}

data "azurerm_resource_group" "rg-hub" {
  name                                      = "hmcts-hub-${var.environment}"
}

data "azurerm_network_interface" "palo-ip" {
  name                                      = "${data.azurerm_resource_group.rg-hub.name}-nic-transit-private-0"
  resource_group_name                       = "${data.azurerm_resource_group.rg-hub.name}"
}

locals {

  palo_ip                                   = "${data.azurerm_network_interface.palo-ip.private_ip_address}"
}

data "azurerm_network_interface" "palo-dmz" {
  name                                      = "${data.azurerm_resource_group.rg-dmz.name}-nic-transit-public-0"
  resource_group_name                       = "${data.azurerm_resource_group.rg-dmz.name}"
  depends_on                                = ["azurerm_network_interface.vm01_nic_vip"]
}

locals {
  palo-dmz                                   = "${data.azurerm_network_interface.palo-dmz.private_ip_address}"
}

data "azurerm_network_interface" "proxy-ip" {
  name                                      = "proxy-${var.environment}-nic"
  resource_group_name                       = "${data.azurerm_resource_group.rg-dmz.name}"
}

data "azurerm_lb" "aks-00" {
  name                                      = "kubernetes-internal"
  resource_group_name                       = "MC_sbox-00-rg_${var.environment}-00-aks_uksouth"
  provider                                  = "azurerm.dcd-cftapps-sbox"
}

data "azurerm_lb" "aks-01" {
  name                                      = "kubernetes-internal"
  resource_group_name                       = "MC_sbox-01-rg_${var.environment}-01-aks_uksouth"
  provider                                  = "azurerm.dcd-cftapps-sbox"
}


# Test Outputs

output "aks-00" {
  value                                     = "${data.azurerm_lb.aks-00.id}"
}

output "aks-01" {
  value                                     = "${data.azurerm_lb.aks-01.id}"
}