variable "subscriptionID" {
	type = string
	description = "name of the subscription"
}

variable "resourceGroupName" {
	type = string
	description = "name of the resource group"
}

variable "location" {
	type = string
	description = "location of resources"
}

variable "environment" {
	type = string
	default = "dev"
	description = "name of the environment"
}
