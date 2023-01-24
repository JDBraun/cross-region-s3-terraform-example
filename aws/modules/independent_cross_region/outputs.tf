output "source_route_table_ids" {
  value       = data.aws_route_tables.source.ids
}

output "peer_route_table_ids" {
  value       = data.aws_route_tables.peer.ids
}

output "s3_interface_id" {
  value       = aws_vpc_endpoint.s3.network_interface_ids
}

output "requester_connection" {
  value       = aws_vpc_peering_connection.requester_connection.id
}

output "accepter_connection" {
  value       = aws_vpc_peering_connection_accepter.accepter_connection.id
}

