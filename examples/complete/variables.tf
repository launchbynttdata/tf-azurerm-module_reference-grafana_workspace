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

# COMMON

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
  }))

  default = {
    resource_group = {
      name       = "rg"
      max_length = 80
    }
    grafana = {
      name       = "graf"
      max_length = 22
    }
    monitor_workspace = {
      name       = "amw"
      max_length = 80
    }
  }
}

variable "instance_env" {
  type        = number
  description = "Number that represents the instance of the environment."
  default     = 0

  validation {
    condition     = var.instance_env >= 0 && var.instance_env <= 999
    error_message = "Instance number should be between 0 to 999."
  }
}

variable "instance_resource" {
  type        = number
  description = "Number that represents the instance of the resource."
  default     = 0

  validation {
    condition     = var.instance_resource >= 0 && var.instance_resource <= 100
    error_message = "Instance number should be between 0 to 100."
  }
}

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "redis"
}

variable "class_env" {
  type        = string
  description = "(Required) Environment where resource is going to be deployed. For example. dev, qa, uat"
  nullable    = false
  default     = "dev"

  validation {
    condition     = length(regexall("\\b \\b", var.class_env)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

variable "location" {
  description = "Location where the managed grafana instance will be created"
  type        = string
  default     = "eastus"
}

variable "grafana_name" {
  description = "Name of the managed grafana instance"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]+[a-z0-9]$", var.grafana_name))
    error_message = "The name can only contain lowercase letters, numbers and dashes, and it must begin with a letter and end with a letter or digit."
  }

  validation {
    condition     = length(var.grafana_name) < 23 && length(var.grafana_name) > 2
    error_message = "The name length must be from 2 to 23 characters"
  }
}

variable "grafana_api_key_enabled" {
  description = "Whether to enable API keys for the managed grafana instance. Defaults to false"
  type        = bool
  default     = false
}

variable "grafana_deterministic_outbound_ip_enabled" {
  description = "Whether to enable deterministic outbound IP for the managed grafana instance. Defaults to false"
  type        = bool
  default     = false
}

variable "grafana_major_version" {
  description = "Major version of Grafana to deploy"
  type        = string
  default     = "10"

  validation {
    condition     = contains(["9", "10"], var.grafana_major_version)
    error_message = "Major version can be either '9' or '10'"
  }
}

variable "public_network_access_enabled" {
  description = "Whether to enable public network access for the managed grafana instance. Defaults to true"
  type        = bool
  default     = true
}

variable "grafana_sku" {
  description = "SKU of the managed grafana instance. Possible values are 'Standard' and 'Essential'"
  type        = string
  default     = "Standard"

  validation {
    condition     = var.grafana_sku == "Standard" || var.grafana_sku == "Essential"
    error_message = "Invalid SKU. Possible values are 'Standard' and 'Essential'"
  }
}

variable "grafana_zone_redundancy_enabled" {
  description = "Whether to enable zone redundancy for the managed grafana instance. Defaults to false"
  type        = bool
  default     = false
}

variable "identity_ids" {
  description = <<EOT
    Specifies a list of user managed identity ids to be assigned.
  EOT
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Custom tags for the Grafana workspace"
  type        = map(string)
  default     = {}
}
