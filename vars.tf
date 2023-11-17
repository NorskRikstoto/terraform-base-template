variable "environment" {
    type = string
}

variable "service_name" {
    type = string
    default = "${{ shortname }}"
}

variable "location" {
    type = string
    default = "Norway East"
}