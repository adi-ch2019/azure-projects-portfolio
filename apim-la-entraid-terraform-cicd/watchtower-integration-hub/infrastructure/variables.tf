variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}