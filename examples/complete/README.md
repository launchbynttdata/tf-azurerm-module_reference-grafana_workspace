# complete

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, <= 1.5.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.113 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_grafana_workspace"></a> [grafana\_workspace](#module\_grafana\_workspace) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br>    name       = string<br>    max_length = optional(number, 60)<br>  }))</pre> | <pre>{<br>  "grafana": {<br>    "max_length": 22,<br>    "name": "graf"<br>  },<br>  "monitor_workspace": {<br>    "max_length": 80,<br>    "name": "amw"<br>  },<br>  "resource_group": {<br>    "max_length": 80,<br>    "name": "rg"<br>  }<br>}</pre> | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"redis"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location where the managed grafana instance will be created | `string` | `"eastus"` | no |
| <a name="input_grafana_name"></a> [grafana\_name](#input\_grafana\_name) | Name of the managed grafana instance | `string` | n/a | yes |
| <a name="input_grafana_api_key_enabled"></a> [grafana\_api\_key\_enabled](#input\_grafana\_api\_key\_enabled) | Whether to enable API keys for the managed grafana instance. Defaults to false | `bool` | `false` | no |
| <a name="input_grafana_deterministic_outbound_ip_enabled"></a> [grafana\_deterministic\_outbound\_ip\_enabled](#input\_grafana\_deterministic\_outbound\_ip\_enabled) | Whether to enable deterministic outbound IP for the managed grafana instance. Defaults to false | `bool` | `false` | no |
| <a name="input_grafana_major_version"></a> [grafana\_major\_version](#input\_grafana\_major\_version) | Major version of Grafana to deploy | `string` | `"10"` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether to enable public network access for the managed grafana instance. Defaults to true | `bool` | `true` | no |
| <a name="input_grafana_sku"></a> [grafana\_sku](#input\_grafana\_sku) | SKU of the managed grafana instance. Possible values are 'Standard' and 'Essential' | `string` | `"Standard"` | no |
| <a name="input_grafana_zone_redundancy_enabled"></a> [grafana\_zone\_redundancy\_enabled](#input\_grafana\_zone\_redundancy\_enabled) | Whether to enable zone redundancy for the managed grafana instance. Defaults to false | `bool` | `false` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of user managed identity ids to be assigned. | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom tags for the Grafana workspace | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_grafana_id"></a> [grafana\_id](#output\_grafana\_id) | Resource ID of the managed grafana instance |
| <a name="output_grafana_name"></a> [grafana\_name](#output\_grafana\_name) | Name of the managed grafana instance |
| <a name="output_grafana_principal_id"></a> [grafana\_principal\_id](#output\_grafana\_principal\_id) | Principal ID of the managed grafana instance |
| <a name="output_grafana_endpoint"></a> [grafana\_endpoint](#output\_grafana\_endpoint) | Name of the managed grafana instance |
| <a name="output_grafana_outbound_ip"></a> [grafana\_outbound\_ip](#output\_grafana\_outbound\_ip) | Outbound IP of the managed grafana instance if `deterministic_outbound_ip_enabled` is true |
| <a name="output_monitor_workspace_id"></a> [monitor\_workspace\_id](#output\_monitor\_workspace\_id) | Resource ID of the Azure Monitor workspace |
| <a name="output_monitor_workspace_name"></a> [monitor\_workspace\_name](#output\_monitor\_workspace\_name) | Name of the Azure Monitor workspace |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the resource group created by this module |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
