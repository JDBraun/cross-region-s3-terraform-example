output "databricks_host" {
  value       = module.databricks_mws_workspace.workspace_url
}

output "source_route_table_ids" {
  value       = module.independent_cross_region_aws_assets.source_route_table_ids
}

output "peer_route_table_ids" {
  value       = module.independent_cross_region_aws_assets.peer_route_table_ids
}

output "requester_connection" {
  value       = module.independent_cross_region_aws_assets.requester_connection
}

output "accepter_connection" {
  value       = module.independent_cross_region_aws_assets.accepter_connection
}