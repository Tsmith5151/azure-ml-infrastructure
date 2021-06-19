output "project" {
	value = var.projectName
}

output "subscription" {
	value = var.subscriptionID
}

output "resource_group" {
	value = var.resourceGroupName
}

output "location" {
	value = var.location
}

output "environment" {
	value = var.environment
}

output "azure-ml-workspace" {
	value = azurerm_machine_learning_workspace.example.name
}