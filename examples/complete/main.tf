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

module "grafana_workspace" {
  source = "../.."

  resource_names_map      = var.resource_names_map
  location                = var.location
  class_env               = var.class_env
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service

  grafana_name                              = var.grafana_name
  grafana_api_key_enabled                   = var.grafana_api_key_enabled
  grafana_deterministic_outbound_ip_enabled = var.grafana_deterministic_outbound_ip_enabled
  grafana_zone_redundancy_enabled           = var.grafana_zone_redundancy_enabled
  grafana_major_version                     = var.grafana_major_version
  grafana_sku                               = var.grafana_sku

  identity_ids                  = var.identity_ids
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
}
