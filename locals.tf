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

locals {
  default_tags = {
    provisioner = "Terraform"
  }
  tags = merge(local.default_tags, var.tags)

  grafana_name        = var.grafana_name != null ? var.grafana_name : var.resource_names_map["grafana"].minimal_random_suffix_without_any_separators
  resource_group_name = var.resource_group_name != null ? var.resource_group_name : module.resource_group[0].name
}
