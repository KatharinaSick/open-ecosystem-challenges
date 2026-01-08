# ============================================================================
# CloudHaven Infrastructure - Merchant Districts
# ============================================================================
# This configuration provisions infrastructure for two merchant districts:
# - North Market: The bustling northern trading hub
# - South Bazaar: The vibrant southern marketplace
#
# Each district requires:
# - A storage vault (bucket) for storing merchant goods
# - A ledger database for tracking inventory (depends on vault for backups)
#
# Districts can be enabled/disabled individually using the `enabled` flag.
# ============================================================================

locals {
  districts = {
    north-market = {
      name        = "North Market"
      description = "The bustling northern trading hub"
      enabled     = true
    }
    south-bazaar = {
      name        = "South Bazaar"
      description = "The vibrant southern marketplace"
      enabled     = true
    }
  }
}

# ----------------------------------------------------------------------------
# Storage Vaults (Buckets)
# One per district, used for storing merchant goods and database backups
# ----------------------------------------------------------------------------
resource "google_storage_bucket" "vault" {
  for_each = local.districts
  enabled = each.value.enabled

  name     = "cloudhaven-${each.key}-vault"
  location = "EU"

  labels = {
    district    = each.key
    purpose     = "merchant-storage"
    managed-by  = "opentofu"
    environment = "production"
  }
}

# ----------------------------------------------------------------------------
# Ledger Databases
# One per district, used for tracking merchant inventory
# Depends on the storage vault for backup storage
# ----------------------------------------------------------------------------
# resource "google_sql_database_instance" "ledger" {
#   for_each = local.districts
#   enabled = each.value.enabled
#
#   name             = "cloudhaven-${each.key}-ledger"
#   database_version = "POSTGRES_15"
#   region           = "europe-west1"
#
#   settings {
#     tier = "db-f1-micro"
#
#     backup_configuration {
#       enabled            = true
#       binary_log_enabled = false
#       # Reference the vault bucket for backup storage
#       backup_retention_settings {
#         retained_backups = 7
#       }
#     }
#
#     database_flags {
#       name  = "backup_bucket"
#       value = google_storage_bucket.vault[each.key].name
#     }
#   }
#
#   labels = {
#     district    = each.key
#     purpose     = "inventory-ledger"
#     managed-by  = "opentofu"
#     environment = "production"
#   }
#
#   # Explicit dependency: database needs the vault bucket to exist first
#   depends_on = [google_storage_bucket.vault]
# }
#
