module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "0.12.0"
  count   = local.has_regions ? 1 : 0

  enable_telemetry = var.enable_telemetry
  use_cached_data  = false
}

locals {
  availability_zones = local.has_regions ? {
    for key, value in var.hub_virtual_networks : key => module.regions[0].regions_by_name[value.location].zones == null ? [] : module.regions[0].regions_by_name[value.location].zones
  } : null
  region_geo_codes = local.has_regions ? {
    for key, value in var.hub_virtual_networks : key => try(module.regions[0].regions_by_name[value.location].geo_code, null)
  } : {}
  region_short_names = local.has_regions ? {
    for key, value in var.hub_virtual_networks : key => module.regions[0].regions_by_name[value.location].short_name
  } : {}
}
