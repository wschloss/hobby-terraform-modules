variable "table_name" {
    description = "the name of the table to create"
    type = string
}

variable "hash_key_attribute" {
    description = "Name and type of the attribute to partition on"
    type = map
}

variable "environment" {
  description = "The environment name for this table (dev / prod)"
  type = string
}