# Configure the Microsoft Azure Provider
provider "azurerm" {
}

variable "prefix" {
  default = "tfvmex"
}

variable "location" {
  default = "australiaeast"
}

variable "admin_username" {
    default = "azureuser"
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "main" {
    name     = "${var.prefix}-resources"
    location = "${var.location}"

    tags = {
        environment = "non-prod"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "main" {
    name                = "${var.prefix}-network"
    address_space       = ["10.0.0.0/16"]
    location            = "${azurerm_resource_group.main.location}"
    resource_group_name = "${azurerm_resource_group.main.name}"

    tags = {
        environment = "non-prod"
    }
}

# Create subnet
resource "azurerm_subnet" "internal" {
    name                 = "internal"
    resource_group_name  = "${azurerm_resource_group.main.name}"
    virtual_network_name = "${azurerm_virtual_network.main.name}"
    address_prefix       = "10.0.1.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "main" {
    name                         = "${var.prefix}-publicip"
    location                     = "${azurerm_resource_group.main.location}"
    resource_group_name          = "${azurerm_resource_group.main.name}"
    allocation_method            = "Dynamic"

    tags = {
        environment = "non-prod"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "main" {
    name                = "${var.prefix}-nsg"
    location            = "${azurerm_resource_group.main.location}"
    resource_group_name = "${azurerm_resource_group.main.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "non-prod"
    }
}

# Create network interface
resource "azurerm_network_interface" "main" {
    name                      = "${var.prefix}-nic"
    location                  = "${azurerm_resource_group.main.location}"
    resource_group_name       = "${azurerm_resource_group.main.name}"
    network_security_group_id = "${azurerm_network_security_group.main.id}"

    ip_configuration {
        name                          = "${var.prefix}-nic-configuration"
        subnet_id                     = "${azurerm_subnet.internal.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.main.id}"
    }

    tags = {
        environment = "non-prod"
    }
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.main.name}"
    }
    
    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "main" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = "${azurerm_resource_group.main.name}"
    location                    = "${azurerm_resource_group.main.location}"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "non-prod"
    }
}

# Create virtual machine
resource "azurerm_virtual_machine" "main" {
    name                  = "${var.prefix}-vm"
    location              = "${azurerm_resource_group.main.location}"
    resource_group_name   = "${azurerm_resource_group.main.name}"
    network_interface_ids = ["${azurerm_network_interface.main.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "${var.prefix}osdisk1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "buildagent"
        admin_username = "${var.admin_username}"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = "${file("~/.ssh/id_rsa.pub")}"
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.main.primary_blob_endpoint}"
    }

    tags = {
        environment = "non-prod"
    }
}