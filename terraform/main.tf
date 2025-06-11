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

# Create virtual networks in each region
resource "azurerm_virtual_network" "eastus" {
  name                = "eastus-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.eastus.location
  resource_group_name = azurerm_resource_group.eastus.name
}

resource "azurerm_virtual_network" "westeurope" {
  name                = "we-vnet"
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.westeurope.location
  resource_group_name = azurerm_resource_group.westeurope.name
}

resource "azurerm_virtual_network" "southeastasia" {
  name                = "sea-vnet"
  address_space       = ["10.3.0.0/16"]
  location            = azurerm_resource_group.southeastasia.location
  resource_group_name = azurerm_resource_group.southeastasia.name
}

# Create subnets in each region
resource "azurerm_subnet" "eastus" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.eastus.name
  virtual_network_name = azurerm_virtual_network.eastus.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "westeurope" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.westeurope.name
  virtual_network_name = azurerm_virtual_network.westeurope.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_subnet" "southeastasia" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.southeastasia.name
  virtual_network_name = azurerm_virtual_network.southeastasia.name
  address_prefixes     = ["10.3.1.0/24"]
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
    subnet_id                     = azurerm_subnet.eastus.id
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
    subnet_id                     = azurerm_subnet.westeurope.id
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
    subnet_id                     = azurerm_subnet.southeastasia.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.southeastasia.id
  }
}

# Create network security groups to allow HTTP traffic
resource "azurerm_network_security_group" "eastus" {
  name                = "eastus-nsg"
  location            = azurerm_resource_group.eastus.location
  resource_group_name = azurerm_resource_group.eastus.name

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
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
}

resource "azurerm_network_security_group" "westeurope" {
  name                = "we-nsg"
  location            = azurerm_resource_group.westeurope.location
  resource_group_name = azurerm_resource_group.westeurope.name

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
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
}

resource "azurerm_network_security_group" "southeastasia" {
  name                = "sea-nsg"
  location            = azurerm_resource_group.southeastasia.location
  resource_group_name = azurerm_resource_group.southeastasia.name

  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
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
}

# Associate NSGs with NICs
resource "azurerm_network_interface_security_group_association" "eastus" {
  network_interface_id      = azurerm_network_interface.eastus.id
  network_security_group_id = azurerm_network_security_group.eastus.id
}

resource "azurerm_network_interface_security_group_association" "westeurope" {
  network_interface_id      = azurerm_network_interface.westeurope.id
  network_security_group_id = azurerm_network_security_group.westeurope.id
}

resource "azurerm_network_interface_security_group_association" "southeastasia" {
  network_interface_id      = azurerm_network_interface.southeastasia.id
  network_security_group_id = azurerm_network_security_group.southeastasia.id
}

# Create Linux VMs with NGINX web server
resource "azurerm_linux_virtual_machine" "eastus" {
  name                = "eastus-web-vm"
  resource_group_name = azurerm_resource_group.eastus.name
  location            = azurerm_resource_group.eastus.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.eastus.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

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
  network_interface_ids = [
    azurerm_network_interface.westeurope.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

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
  network_interface_ids = [
    azurerm_network_interface.southeastasia.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

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

# Create Traffic Manager Profile
resource "azurerm_traffic_manager_profile" "example" {
  name                   = "demo-traffic-manager"
  resource_group_name    = azurerm_resource_group.eastus.name
  traffic_routing_method = "Performance"

  dns_config {
    relative_name = "demo-traffic-manager"
    ttl           = 30
  }

  monitor_config {
    protocol                     = "HTTP"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }
}

# Add endpoints to Traffic Manager
resource "azurerm_traffic_manager_azure_endpoint" "eastus" {
  name               = "eastus-endpoint"
  profile_id         = azurerm_traffic_manager_profile.example.id
  target_resource_id = azurerm_public_ip.eastus.id
  weight             = 1
}

resource "azurerm_traffic_manager_azure_endpoint" "westeurope" {
  name               = "westeurope-endpoint"
  profile_id         = azurerm_traffic_manager_profile.example.id
  target_resource_id = azurerm_public_ip.westeurope.id
  weight             = 1
}

resource "azurerm_traffic_manager_azure_endpoint" "southeastasia" {
  name               = "southeastasia-endpoint"
  profile_id         = azurerm_traffic_manager_profile.example.id
  target_resource_id = azurerm_public_ip.southeastasia.id
  weight             = 1
}