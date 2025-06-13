variable "name" {}
variable "traffic_routing_method" {}
variable "resource_group_name" {}
variable "dns_relative_name" {}
variable "dns_ttl" {}
variable  "monitor_config_protocol"{}
variable  "monitor_config_port"{}
variable  "monitor_config_path"{}
variable  "monitor_config_interval_in_seconds"{}
variable  "monitor_config_timeout_in_seconds"{}
variable  "monitor_config_tolerated_number_of_failures"{}
variable "endpoints" {
    type = list(object({
      name = string
      target_resource_id = string
      weight = string
    })) 
}