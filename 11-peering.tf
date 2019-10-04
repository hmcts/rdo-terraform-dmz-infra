
resource "azurerm_virtual_network_peering" "dmz-2-hub" {
  name                              = "dmz-2-hub"
  resource_group_name               = "${data.azurerm_resource_group.rg-dmz.name}"
  virtual_network_name              = "${data.azurerm_virtual_network.vnet-dmz.name}"
  remote_virtual_network_id         = "${data.azurerm_virtual_network.vnet.id}"
  allow_virtual_network_access      = true
  allow_forwarded_traffic           = true
  allow_gateway_transit             = false
  use_remote_gateways               = false
  depends_on                        = ["data.azurerm_virtual_network.vnet-dmz"]

}

resource "azurerm_virtual_network_peering" "hub-2-dmz" {
  name                              = "hub-2-dmz"
  resource_group_name               = "${data.azurerm_virtual_network.vnet.name}"
  virtual_network_name              = "${data.azurerm_virtual_network.vnet.name}"
  remote_virtual_network_id         = "${data.azurerm_virtual_network.vnet-dmz.id}"

  allow_virtual_network_access      = true
  allow_forwarded_traffic           = true
  allow_gateway_transit             = false
  use_remote_gateways               = false
  depends_on                        = ["data.azurerm_virtual_network.vnet-dmz"]
}
