# Create resource groups for each region
resource "azurerm_resource_group" "eastus" {
  name     = "traffic-manager-eastus-rg"
  location = "East US"
}

resource "azurerm_resource_group" "westeurope" {
  name     = "traffic-manager-we-rg"
  location = "West Europe"
}

resource "azurerm_resource_group" "southeastasia" {
  name     = "traffic-manager-sea-rg"
  location = "Southeast Asia"
}

module "vnet_eastus" {
  source              = "./modules/vnet"
  name                = "eastus-vnet"
  address_space       = ["10.1.0.0/16"]
  resource_group_name = azurerm_resource_group.eastus.name
  location            = azurerm_resource_group.eastus.location
  subnets = [
    {
      name             = "default"
      address_prefixes = ["10.1.1.0/24"]
    }
  ]
}

module "vnet_westeurope" {
  source              = "./modules/vnet"
  name                = "westeurope-vnet"
  address_space       = ["10.2.0.0/16"]
  resource_group_name = azurerm_resource_group.westeurope.name
  location            = azurerm_resource_group.westeurope.location
  subnets = [
    {
      name             = "default"
      address_prefixes = ["10.2.1.0/24"]
    }
  ]
}

module "vnet_southeastasia" {
  source              = "./modules/vnet"
  name                = "southeastasia-vnet"
  address_space       = ["10.3.0.0/16"]
  resource_group_name = azurerm_resource_group.southeastasia.name
  location            = azurerm_resource_group.southeastasia.location
  subnets = [
    {
      name             = "default"
      address_prefixes = ["10.3.1.0/24"]
    }
  ]
}

# Create public IPs for each web server
resource "azurerm_public_ip" "eastus" {
  name                = "eastus-web-pip"
  location            = azurerm_resource_group.eastus.location
  resource_group_name = azurerm_resource_group.eastus.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "westeurope" {
  name                = "we-web-pip"
  location            = azurerm_resource_group.westeurope.location
  resource_group_name = azurerm_resource_group.westeurope.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "southeastasia" {
  name                = "sea-web-pip"
  location            = azurerm_resource_group.southeastasia.location
  resource_group_name = azurerm_resource_group.southeastasia.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create network interfaces
resource "azurerm_network_interface" "eastus" {
  name                = "eastus-nic"
  location            = azurerm_resource_group.eastus.location
  resource_group_name = azurerm_resource_group.eastus.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet_eastus.subnets[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.eastus.id
  }
}

resource "azurerm_network_interface" "westeurope" {
  name                = "we-nic"
  location            = azurerm_resource_group.westeurope.location
  resource_group_name = azurerm_resource_group.westeurope.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet_westeurope.subnets[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.westeurope.id
  }
}

resource "azurerm_network_interface" "southeastasia" {
  name                = "sea-nic"
  location            = azurerm_resource_group.southeastasia.location
  resource_group_name = azurerm_resource_group.southeastasia.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet_southeastasia.subnets[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.southeastasia.id
  }
}

module "nsg_eastus" {
  source              = "./modules/nsg"
  name                = "eastus-nsg"
  location            = azurerm_resource_group.eastus.location
  resource_group_name = azurerm_resource_group.eastus.name
  security_rules = [
    {
      name                       = "allow-http"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-ssh"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
  associations = [
    azurerm_network_interface.eastus.id
  ]
}

module "nsg_westeurope" {
  source              = "./modules/nsg"
  name                = "we-nsg"
  location            = azurerm_resource_group.westeurope.location
  resource_group_name = azurerm_resource_group.westeurope.name
  security_rules = [
    {
      name                       = "allow-http"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-ssh"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
  associations = [
    azurerm_network_interface.westeurope.id
  ]
}

module "nsg_southeastasia" {
  source              = "./modules/nsg"
  name                = "sea-nsg"
  location            = azurerm_resource_group.southeastasia.location
  resource_group_name = azurerm_resource_group.southeastasia.name
  security_rules = [
    {
      name                       = "allow-http"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-ssh"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
  associations = [
    azurerm_network_interface.southeastasia.id
  ]
}

# Create Linux VMs with NGINX web server
resource "azurerm_linux_virtual_machine" "eastus" {
  name                = "eastus-web-vm"
  resource_group_name = azurerm_resource_group.eastus.name
  location            = azurerm_resource_group.eastus.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "Demo12345!"
  network_interface_ids = [
    azurerm_network_interface.eastus.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # Install NGINX via cloud-init
  custom_data = base64encode(<<-EOF
    #cloud-config
    package_upgrade: true
    packages:
      - nginx
    runcmd:
      - [systemctl, enable, nginx]
      - [systemctl, start, nginx]
      - [sh, -c, "echo '<html><body><h1>East US Region</h1><p>This is the East US web server</p></body></html>' > /var/www/html/index.nginx-debian.html"]
  EOF
  )
}

resource "azurerm_linux_virtual_machine" "westeurope" {
  name                = "we-web-vm"
  resource_group_name = azurerm_resource_group.westeurope.name
  location            = azurerm_resource_group.westeurope.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "Demo12345!"
  network_interface_ids = [
    azurerm_network_interface.westeurope.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    #cloud-config
    package_upgrade: true
    packages:
      - nginx
    runcmd:
      - [systemctl, enable, nginx]
      - [systemctl, start, nginx]
      - [sh, -c, "echo '<html><body><h1>West Europe Region</h1><p>This is the West Europe web server</p></body></html>' > /var/www/html/index.nginx-debian.html"]
  EOF
  )
}

resource "azurerm_linux_virtual_machine" "southeastasia" {
  name                = "sea-web-vm"
  resource_group_name = azurerm_resource_group.southeastasia.name
  location            = azurerm_resource_group.southeastasia.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  admin_password      = "Demo12345!"
  network_interface_ids = [
    azurerm_network_interface.southeastasia.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    #cloud-config
    package_upgrade: true
    packages:
      - nginx
    runcmd:
      - [systemctl, enable, nginx]
      - [systemctl, start, nginx]
      - [sh, -c, "echo '<html><body><h1>Southeast Asia Region</h1><p>This is the Southeast Asia web server</p></body></html>' > /var/www/html/index.nginx-debian.html"]
  EOF
  )
}

module "traffic_manager" {
  source                                      = "./modules/traffic-manager"
  name                                        = "traffic-manager"
  resource_group_name                         = azurerm_resource_group.eastus.name
  traffic_routing_method                      = "Performance"
  dns_relative_name                           = "traffic-manager"
  dns_ttl                                     = 30
  monitor_config_protocol                     = "HTTP"
  monitor_config_port                         = 80
  monitor_config_path                         = "/"
  monitor_config_interval_in_seconds          = 30
  monitor_config_timeout_in_seconds           = 10
  monitor_config_tolerated_number_of_failures = 3
  endpoints = [
    {
      name               = "eastus-endpoint"
      target_resource_id = azurerm_public_ip.eastus.id
      weight             = 1
    },
    {
      name               = "westeurope-endpoint"
      target_resource_id = azurerm_public_ip.westeurope.id
      weight             = 1
    },
    {
      name               = "southeastasia-endpoint"
      target_resource_id = azurerm_public_ip.southeastasia.id
      weight             = 1
    }
  ]
}

