# ============================================================================
# Outputs
# ============================================================================
# These outputs expose important resource information that other systems
# or guild members might need to reference.
#
# Note: Only enabled districts will have their resources included in outputs.
# Disabled districts are excluded since their resources don't exist.
# ============================================================================

# ----------------------------------------------------------------------------
# Storage Vault Outputs
# ----------------------------------------------------------------------------
output "vault_names" {
  description = "Names of the storage vault buckets for each enabled district"
  value = {
    for key, bucket in google_storage_bucket.vault : key => bucket.name
    if local.districts[key].enabled
  }
}

output "vault_urls" {
  description = "URLs of the storage vault buckets for each enabled district"
  value = {
    for key, bucket in google_storage_bucket.vault : key => bucket.url
    if local.districts[key].enabled
  }
}

# ----------------------------------------------------------------------------
# Ledger Database Outputs
# ----------------------------------------------------------------------------
# output "ledger_instance_names" {
#   description = "Names of the ledger database instances for each enabled district"
#   value = {
#     for key, db in google_sql_database_instance.ledger : key => db.name
#     if local.districts[key].enabled
#   }
# }
#
# output "ledger_connection_names" {
#   description = "Connection names for the ledger databases (used by applications)"
#   value = {
#     for key, db in google_sql_database_instance.ledger : key => db.connection_name
#     if local.districts[key].enabled
#   }
# }

# ----------------------------------------------------------------------------
# Summary Output
# ----------------------------------------------------------------------------
output "district_summary" {
  description = "Summary of all districts and their infrastructure status"
  value = {
    for key, district in local.districts : key => {
      district_name = district.name
      enabled       = district.enabled
      vault_bucket  = district.enabled ? google_storage_bucket.vault[key].name : null
      ledger_db     = district.enabled ? google_sql_database_instance.ledger[key].name : null
      status        = district.enabled ? "operational" : "not provisioned"
    }
  }
}

