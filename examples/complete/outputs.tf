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

output "grafana_id" {
  description = "Resource ID of the managed grafana instance"
  value       = module.grafana_workspace.grafana_id
}

output "grafana_name" {
  description = "Name of the managed grafana instance"
  value       = module.grafana_workspace.grafana_name
}

output "grafana_principal_id" {
  description = "Principal ID of the managed grafana instance"
  value       = module.grafana_workspace.grafana_principal_id
}

output "grafana_endpoint" {
  description = "Name of the managed grafana instance"
  value       = module.grafana_workspace.grafana_endpoint
}

output "grafana_outbound_ip" {
  description = "Outbound IP of the managed grafana instance if `deterministic_outbound_ip_enabled` is true"
  value       = module.grafana_workspace.grafana_outbound_ip
}

output "monitor_workspace_id" {
  description = "Resource ID of the Azure Monitor workspace"
  value       = module.grafana_workspace.monitor_workspace_id
}

output "monitor_workspace_name" {
  description = "Name of the Azure Monitor workspace"
  value       = module.grafana_workspace.monitor_workspace_name
}

output "resource_group_name" {
  description = "Name of the resource group created by this module"
  value       = module.grafana_workspace.resource_group_name
}
