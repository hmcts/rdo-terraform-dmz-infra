
resource "azurerm_network_interface" "ansible_server_nic" {
  name                                = "${data.azurerm_virtual_network.vnet-dmz.name}-${var.environment}-ansible-nic"
  location                            = "${data.azurerm_resource_group.rg-dmz.location}"
  resource_group_name                 = "${data.azurerm_resource_group.rg-dmz.name}"

  ip_configuration {
    name                              = "${data.azurerm_virtual_network.vnet-dmz.name}-${var.environment}-ansible-ip"
    subnet_id                         = "${data.azurerm_subnet.subnet-dmz-mgmt.id}"
    private_ip_address_allocation     = "dynamic"
    public_ip_address_id              = "${azurerm_public_ip.pip-ansible.id}"
  }
}

resource "azurerm_public_ip" "pip-ansible" {
  name                                = "${data.azurerm_virtual_network.vnet-dmz.name}-${var.environment}-ansible-pip"
  location                            = "${data.azurerm_resource_group.rg-dmz.location}"
  resource_group_name                 = "${data.azurerm_resource_group.rg-dmz.name}"
  allocation_method                   = "Static"
}

module "firewall" {
  source                              = "github.com/hmcts/rdo-terraform-azure-palo-alto.git"
  rg_name                             = "${data.azurerm_resource_group.rg-dmz.name}"
  vnet_name                           = "${data.azurerm_virtual_network.vnet-dmz.name}"
  subnet_management_id                = "${data.azurerm_subnet.subnet-dmz-mgmt.id}"
  subnet_transit_private_id           = "${data.azurerm_subnet.subnet-dmz-palo-private.id}"
  subnet_transit_public_id            = "${data.azurerm_subnet.subnet-dmz-palo-public.id}"
  replicas                            = "${var.firewall_replicas}"
  vm_name_prefix                      = "${var.firewall_name_prefix}"
  vm_username                         = "${var.firewall_username}"
  vm_password                         = "${var.firewall_password}"
  environment                         = "${var.environment}"
  pip-ansible                         = "${azurerm_public_ip.pip-ansible.ip_address}"
  ansible-nic                         = "${azurerm_network_interface.ansible_server_nic.id}"
}
