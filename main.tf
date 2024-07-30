// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = var.resource_names_map

  region                  = join("", split("-", var.location))
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
  use_azure_region_abbr   = true
}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  count = var.resource_group_name == null ? 1 : 0

  name     = module.resource_names["resource_group"].standard
  location = var.location

  tags = local.tags
}

module "monitor_workspace" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/monitor_workspace/azurerm"
  version = "~> 1.0"

  name                = module.resource_names["monitor_workspace"].standard
  resource_group_name = local.resource_group_name
  location            = var.location

  public_network_access_enabled = var.public_network_access_enabled

  tags = local.tags

  depends_on = [module.resource_group]
}

module "grafana" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/grafana/azurerm"
  version = "~> 1.0"

  name                = local.grafana_name
  resource_group_name = local.resource_group_name
  location            = var.location

  api_key_enabled                   = var.grafana_api_key_enabled
  deterministic_outbound_ip_enabled = var.grafana_deterministic_outbound_ip_enabled
  zone_redundancy_enabled           = var.grafana_zone_redundancy_enabled
  grafana_major_version             = var.grafana_major_version
  sku                               = var.grafana_sku

  identity_ids = var.identity_ids

  azure_monitor_workspace_ids = [module.monitor_workspace.id]

  tags = local.tags

  depends_on = [module.monitor_workspace]
}
