
resource "azurerm_network_interface" "vm01_nic_vip" {
  name                              = "f5-01-nic02-${var.environment}"
  location                          = "${data.azurerm_resource_group.rg-dmz.location}"
  resource_group_name               = "${data.azurerm_resource_group.rg-dmz.name}"
  enable_ip_forwarding              = "false"
  ip_configuration  {
    primary                         = "true"
    name                            = "ip01-${var.environment}"
    subnet_id                       = "${data.azurerm_subnet.subnet-dmz-loadbalancer.id}"
    private_ip_address_allocation   = "dynamic"
  } 
}

module "f5-01" {
  source                            = "github.com/hmcts/rdo-terraform-module-azure-f5.git"
  rg_name                           = "${data.azurerm_resource_group.rg-dmz.name}"
  vm_name                           = "f5"
  subnet_mgmt_id                    = "${data.azurerm_subnet.subnet-dmz-mgmt.id}"
  vm_username                       = "${var.loadbalancer_username}"
  vm_password                       = "${var.loadbalancer_password}"
  nic_vip_id                        = "${azurerm_network_interface.vm01_nic_vip.id}"
  selfip_private_ip                 = "${azurerm_network_interface.vm01_nic_vip.private_ip_address}"
  selfip_subnet                     = "255.255.255.0"
  as3_username                      = "${var.as3_username}"
  as3_password                      = "${var.as3_password}"
  environment                       = "${var.environment}"
  tags                              = "${var.tags}"
  backend_storage_account_name      = "${var.backend_storage_account_name}"
}


resource "azurerm_public_ip" "pip_f5-lb" {
  name                                      = "${var.vnet-name}-${var.environment}-f5-lb-pip"
  location                                  = "${data.azurerm_resource_group.rg-dmz.location}"
  resource_group_name                       = "${data.azurerm_resource_group.rg-dmz.name}"
  allocation_method                         = "Static"
  sku                                       = "Standard"	
  tags                                      = "${var.tags}"
}

resource "azurerm_lb" "f5-lb" {
  name                                              = "${var.vnet-name}-${var.environment}-f5-lb"
  location                                          = "${data.azurerm_resource_group.rg-dmz.location}"
  resource_group_name                               = "${data.azurerm_resource_group.rg-dmz.name}"
  sku                                               = "Standard"
  frontend_ip_configuration {
    name                                            = "frontend"
    public_ip_address_id                            = "${azurerm_public_ip.pip_f5-lb.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "f5-lb_backend" {
  name                                              = "${var.vnet-name}-${var.environment}-f5-lb-backend"
  resource_group_name                               = "${data.azurerm_resource_group.rg-dmz.name}"
  loadbalancer_id                                   = "${azurerm_lb.f5-lb.id}"  
}

resource "azurerm_lb_probe" "f5-lb_probe" {
  resource_group_name                               = "${data.azurerm_resource_group.rg-dmz.name}"
  loadbalancer_id                                   = "${azurerm_lb.f5-lb.id}" 
  name                                              = "probe-https"
  port                                              = "443"
  protocol                                          = "https"
  request_path                                      = "/"
}

resource "azurerm_lb_rule" "f5-lb_rule" {
  name                                              = "${var.vnet-name}-${var.environment}-f5-lbrules"
  resource_group_name                               = "${data.azurerm_resource_group.rg-dmz.name}"
  loadbalancer_id                                   = "${azurerm_lb.f5-lb.id}"  
  frontend_port                                     = "22" 
  frontend_ip_configuration_name                    = "frontend"
  backend_address_pool_id                           = "${azurerm_lb_backend_address_pool.f5-lb_backend.id}"
  backend_port                                      = "22"
  protocol                                          = "tcp"
  enable_floating_ip                                = "false"
  probe_id                                          = "${azurerm_lb_probe.f5-lb_probe.id}"
}

resource "azurerm_network_interface_backend_address_pool_association" "f5-lbmap" {
  count                                             = "${var.firewall_replicas}"
  network_interface_id                              = "${element(azurerm_network_interface.vm01_nic_vip.*.id, count.index)}"
  ip_configuration_name                             = "ip01-${var.environment}"
  backend_address_pool_id                           = "${azurerm_lb_backend_address_pool.f5-lb_backend.id}"
}
