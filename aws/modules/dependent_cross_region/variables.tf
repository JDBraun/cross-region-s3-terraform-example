variable "prefix" {
  type = string
}

variable "cross_region_vpc_cidr" {
  type = string
}

variable "cross_region_subnet_cidr" {
  type = string
}

variable "cross_region" {
  type = string
}

variable "dataplane_vpc" {
  type = string
}

variable "dataplane_vpc_cidr" {
  type = string
}

variable "source_route_table_ids" {
    type = set(string)
}

variable "peer_route_table_ids" {
    type = set(string)
}

variable "s3_interface_id" {
    type = set(string)
}

variable "accepter_connection" {
    type = string
}

variable "requester_connection" {
    type = string
}