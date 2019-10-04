resource "azurerm_route_table" "rt" {
  name                              = "${var.vnet-name}-${var.environment}-udr-hub"
  location                          = "${data.azurerm_resource_group.rg-dmz.location}"
  resource_group_name               = "${data.azurerm_resource_group.rg-dmz.name}"
  disable_bgp_route_propagation     = true

  route {
    name                            = "to_hub_fw"
    address_prefix                  = "0.0.0.0/0"
    next_hop_type                   = "VirtualAppliance"
    next_hop_in_ip_address          = "${local.palo_ip}"
  }

  route {
    name                            = "to_proxy"
    address_prefix                  = "${data.azurerm_subnet.subnet-dmz-proxy.address_prefix}"
    next_hop_type                   = "VirtualAppliance"
    next_hop_in_ip_address          = "${local.palo_ip}"
  }
}


resource "azurerm_route_table" "udr-dmz-f5" {
  name                              = "${var.vnet-name}-${var.environment}-udr-dmz-palo"
  location                          = "${data.azurerm_resource_group.rg-dmz.location}"
  resource_group_name               = "${data.azurerm_resource_group.rg-dmz.name}"
  disable_bgp_route_propagation     = true

  route {
    name                            = "to_dmz_palo"
    address_prefix                  = "10.0.0.0/8"
    next_hop_type                   = "VirtualAppliance"
    next_hop_in_ip_address          = "${local.palo-dmz}"
  }

}

resource "azurerm_subnet_route_table_association" "route_association" {
  subnet_id                         = "${data.azurerm_subnet.subnet-dmz-loadbalancer.id}"
  route_table_id                    = "${azurerm_route_table.udr-dmz-f5.id}"
}

