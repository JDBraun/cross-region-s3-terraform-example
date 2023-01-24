// Requestor route
resource "aws_route" "requestor_route" {
  provider                  = aws.source
  count                     = length(var.source_route_table_ids)
  route_table_id            = tolist(var.source_route_table_ids)[count.index]
  destination_cidr_block    = var.cross_region_vpc_cidr
  vpc_peering_connection_id = var.requester_connection
}

// Accepter route
resource "aws_route" "accepter_route" {
  provider                  = aws.peer
  count                     = length(var.peer_route_table_ids)
  route_table_id            = tolist(var.peer_route_table_ids)[count.index]
  destination_cidr_block    = var.dataplane_vpc_cidr
  vpc_peering_connection_id = var.accepter_connection
}

// PHZ
resource "aws_route53_zone" "private" {
  provider = aws.source
  name = "s3.${var.cross_region}.amazonaws.com"

  vpc {
    vpc_id = var.dataplane_vpc
  }
}

// Get ENI values
data "aws_network_interface" "endpoint" {
  provider = aws.peer
  count    =  length(var.s3_interface_id)
  id       =  sort(var.s3_interface_id)[count.index]
}

// S3 A name record 
resource "aws_route53_record" "s3" {
  provider = aws.source
  count     = length(data.aws_network_interface.endpoint)
  zone_id  = aws_route53_zone.private.id
  name     = "s3.${var.cross_region}.amazonaws.com"
  type     = "A"
  ttl      = "300"
  records  = [data.aws_network_interface.endpoint[count.index].private_ip]
  depends_on = [
    data.aws_network_interface.endpoint, aws_route53_zone.private
  ]
}

// S3 wildcard record 
resource "aws_route53_record" "s3_wildcard" {
  provider = aws.source  
  count     = length(data.aws_network_interface.endpoint)
  zone_id = aws_route53_zone.private.id
  name    = "*.s3.${var.cross_region}.amazonaws.com"
  type    = "A"
  ttl     = "300"
  records  = [data.aws_network_interface.endpoint[count.index].private_ip]
  depends_on = [
    data.aws_network_interface.endpoint, aws_route53_zone.private
  ]
}
