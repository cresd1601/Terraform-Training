output "vault_id" {
  value       = azurerm_key_vault.application.id
  description = "The Azure Key Vault ID"
}

output "vault_certificate_secret_id" {
  value       = azurerm_key_vault_certificate.application.secret_id
  description = "The Azure Key Vault Cert ID"
}
