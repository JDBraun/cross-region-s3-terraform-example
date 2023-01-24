data "aws_caller_identity" "current" {}

// Cross Region VPC
resource "aws_vpc" "cross_region" {
  provider             = aws.peer
  cidr_block           = var.cross_region_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.prefix}-cross-region-vpc"
  }
}

// Private Subnet for S3 Interface Endpoint
resource "aws_subnet" "cross_region_private" {
  provider                = aws.peer
  vpc_id                  = aws_vpc.cross_region.id
  cidr_block              = var.cross_region_subnet_cidr
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.prefix}-cross-region-private-subnet"
  }
}

resource "aws_security_group" "s3_interface" {
  provider    = aws.peer
  name        = "allow inbound"
  vpc_id      = aws_vpc.cross_region.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.dataplane_vpc_cidr]
  }

  tags = {
    Name = "allow_tls"
  }
}

// S3 VPC Interface 
resource "aws_vpc_endpoint" "s3" {
  provider          = aws.peer
  vpc_id            = aws_vpc.cross_region.id
  service_name      = "com.amazonaws.${var.cross_region}.s3"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.s3_interface.id,
  ]
  subnet_ids          = [aws_subnet.cross_region_private.id]

  depends_on = [
    aws_security_group.s3_interface
  ]
}

// Route Tables Source
data "aws_route_tables" "source" {
  provider = aws.source
  vpc_id   = var.dataplane_vpc
}

// Route Tables Peer
data "aws_route_tables" "peer" {
  provider = aws.peer
  vpc_id   = aws_vpc.cross_region.id
}

// Requester's side of the connection.
resource "aws_vpc_peering_connection" "requester_connection" {
  provider      = aws.source
  vpc_id        = var.dataplane_vpc
  peer_vpc_id   = aws_vpc.cross_region.id
  peer_owner_id = data.aws_caller_identity.current.account_id
  peer_region   = var.cross_region
  auto_accept   = false
  tags = {
    Side = "Requester"
  }
}

// Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "accepter_connection" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.requester_connection.id
  auto_accept               = true
  tags = {
    Side = "Accepter"
  }
}