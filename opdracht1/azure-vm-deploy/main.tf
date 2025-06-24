provider "azurerm" {
  features {}
  subscription_id = "c064671c-8f74-4fec-b088-b53c568245eb"
  resource_provider_registrations = "none"
}

resource "azurerm_resource_group" "S1202816" {
  name     = "S1202816"
  location = "West Europe"
}

resource "azurerm_virtual_network" "iac_vnet" {
  name                = "iac-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.S1202816.location
  resource_group_name = azurerm_resource_group.S1202816.name
}

resource "azurerm_subnet" "iac_subnet" {
  name                 = "iac-subnet"
  resource_group_name  = azurerm_resource_group.S1202816.name
  virtual_network_name = azurerm_virtual_network.iac_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "webvm_nic" {
  name                = "webvm-nic"
  location            = azurerm_resource_group.S1202816.location
  resource_group_name = azurerm_resource_group.S1202816.name

  ip_configuration {
    name                          = "webvm-ipconfig"
    subnet_id                     = azurerm_subnet.iac_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.10"
    public_ip_address_id          = azurerm_public_ip.webvm_public_ip.id
  }
}

resource "azurerm_public_ip" "webvm_public_ip" {
  name                = "webvm-public-ip"
  location            = azurerm_resource_group.S1202816.location
  resource_group_name = azurerm_resource_group.S1202816.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_public_ip" "dbvm_public_ip" {
name                = "dbvm-public-ip"
  location            = azurerm_resource_group.S1202816.location
  resource_group_name = azurerm_resource_group.S1202816.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "dbvm_nic" {
  name                = "dbvm-nic"
  location            = azurerm_resource_group.S1202816.location
  resource_group_name = azurerm_resource_group.S1202816.name

  ip_configuration {
    name                          = "dbvm-ipconfig"
    subnet_id                     = azurerm_subnet.iac_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.11"
    public_ip_address_id          = azurerm_public_ip.dbvm_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "webvm" {
  name                = "webvm"
  resource_group_name = azurerm_resource_group.S1202816.name
  location            = azurerm_resource_group.S1202816.location
  size                = "Standard_B1s"
  admin_username      = "iac"
  network_interface_ids = [
    azurerm_network_interface.webvm_nic.id,
  ]
  admin_ssh_key {
    username   = "iac"
    public_key = file("~/skylab.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "dbvm" {
  name                = "dbvm"
  resource_group_name = azurerm_resource_group.S1202816.name
  location            = azurerm_resource_group.S1202816.location
  size                = "Standard_B1s"
  admin_username      = "iac"
  network_interface_ids = [
    azurerm_network_interface.dbvm_nic.id,
  ]
  admin_ssh_key {
    username   = "iac"
    public_key = file("~/skylab.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
}