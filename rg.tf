resource "azurerm_resource_group" "RG-Group-01" {
  name     = var.rg1-name
  location = var.location
}

resource "azurerm_storage_account" "storageacc463365785748" {
  name                     = "storageacc463365785748"
  resource_group_name      = "${azurerm_resource_group.RG-Group-01.name}"
  location                 = "${azurerm_resource_group.RG-Group-01.location}"
  account_tier             = var.accounttier
  account_replication_type = var.replicationtype

  tags = {
    environment = "staging"
  }



}


# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "myVnet"
    address_space       = ["10.0.0.0/16"]
    location                 = "${azurerm_resource_group.RG-Group-01.location}"
    resource_group_name      = "${azurerm_resource_group.RG-Group-01.name}"

}



# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "mySubnet"
    resource_group_name      = "${azurerm_resource_group.RG-Group-01.name}"
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefixes       = ["10.0.1.0/24"]
}



# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "myPublicIP"
    location                 = "${azurerm_resource_group.RG-Group-01.location}"
    resource_group_name      = "${azurerm_resource_group.RG-Group-01.name}"
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}



# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "myNetworkSecurityGroup"
    location                 = "${azurerm_resource_group.RG-Group-01.location}"
    resource_group_name      = "${azurerm_resource_group.RG-Group-01.name}"

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
        environment = "Terraform Demo"
    }
}



# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                      = "myNIC"
    location                 = "${azurerm_resource_group.RG-Group-01.location}"
    resource_group_name      = "${azurerm_resource_group.RG-Group-01.name}"

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}





# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsga" {
    network_interface_id      = azurerm_network_interface.myterraformnic.id
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}


/*# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.RG-Group-01.name}"
    }

    byte_length = 8
}
*/


# Create virtual machine
resource "azurerm_virtual_machine" "avm" {
  name                  = "avm"
  location              = azurerm_resource_group.RG-Group-01.location
  resource_group_name   = azurerm_resource_group.RG-Group-01.name
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "adminadmin"
    admin_password = "Warrior@1234"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }

}

/*
resource "azurerm_storage_account" "storageacc463366" {
  name                     = "storageacc463366"
  resource_group_name      = "${azurerm_resource_group.RG-Group-01.name}"
  location                 = "${azurerm_resource_group.RG-Group-01.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }

depends_on          = [azurerm_storage_account.storageacc463365]

}
*/


/*

terraform {
  backend "azurerm" {
    resource_group_name   = "Terraform001"
    storage_account_name  = "terraformstracc007"
    container_name        = "tstate"
    key                   = "terraform.tfstate"
  }
}

*/
