locals {
  account_id                   = var.aws_account_id
  prefix                       = var.resource_prefix
  owner                        = var.resource_owner
  vpc_cidr_range               = var.vpc_cidr_range
  private_subnets_cidr         = split(",", var.private_subnets_cidr)
  privatelink_subnets_cidr     = split(",", var.privatelink_subnets_cidr)
  sg_egress_ports              = [443, 3306, 6666]
  sg_ingress_protocol          = ["tcp", "udp"]
  sg_egress_protocol           = ["tcp", "udp"]
  availability_zones           = split(",", var.availability_zones)
  dbfsname                     = join("", [local.prefix, "-", var.region, "-", "dbfsroot"]) 
  ucname                       = join("", [local.prefix, "-", var.region, "-", "uc"]) 
}

// Cross Region Independent Assets
module "independent_cross_region_aws_assets" {
  source = "./modules/independent_cross_region"
  providers = {
    aws.source       = aws
    aws.peer         = aws.cross
  }

  prefix                         = var.resource_prefix
  dataplane_vpc                  = aws_vpc.dataplane_vpc.id
  dataplane_vpc_cidr             = var.vpc_cidr_range
  cross_region                   = var.cross_region
  cross_region_vpc_cidr          = var.cross_region_vpc_cidr_range
  cross_region_subnet_cidr       = var.cross_region_subnet_cidr
  depends_on = [aws_vpc.dataplane_vpc, aws_subnet.private, aws_route_table.private_rt]
}


// Cross Region Dependent Assets
module "dependent_cross_region_aws_assets" {
  source = "./modules/dependent_cross_region"
  providers = {
    aws.source       = aws
    aws.peer         = aws.cross
  }

  prefix                         = var.resource_prefix
  dataplane_vpc                  = aws_vpc.dataplane_vpc.id
  dataplane_vpc_cidr             = var.vpc_cidr_range
  cross_region                   = var.cross_region
  cross_region_vpc_cidr          = var.cross_region_vpc_cidr_range
  cross_region_subnet_cidr       = var.cross_region_subnet_cidr
  s3_interface_id                = module.independent_cross_region_aws_assets.s3_interface_id
  source_route_table_ids         = module.independent_cross_region_aws_assets.source_route_table_ids
  peer_route_table_ids           = module.independent_cross_region_aws_assets.peer_route_table_ids
  requester_connection           = module.independent_cross_region_aws_assets.requester_connection
  accepter_connection            = module.independent_cross_region_aws_assets.accepter_connection   
  depends_on = [module.independent_cross_region_aws_assets]
}


// Create External Databricks Workspace
module "databricks_mws_workspace" {
  source = "./modules/databricks_workspace"
  providers = {
    databricks = databricks.mws
  }

  databricks_account_id        = var.databricks_account_id
  resource_prefix              = local.prefix
  security_group_ids           = [aws_security_group.sg.id]
  subnet_ids                   = aws_subnet.private.*.id
  vpc_id                       = aws_vpc.dataplane_vpc.id
  cross_account_role_arn       = aws_iam_role.cross_account_role.arn
  bucket_name                  = aws_s3_bucket.root_storage_bucket.id
  region                       = var.region
  backend_rest                 = aws_vpc_endpoint.backend_rest.id
  backend_relay                = aws_vpc_endpoint.backend_relay.id
}

// Create Create Cluster & Instance Profile
module "cluster_configuration" {
    source = "./modules/cluster_configuration"
    providers = {
      databricks = databricks.created_workspace
    }
  
  instance_profile = aws_iam_instance_profile.s3_instance_profile.arn
  depends_on = [module.databricks_mws_workspace]
}