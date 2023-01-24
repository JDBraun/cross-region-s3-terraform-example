// Databricks Variables
databricks_account_username = ""
databricks_account_password = ""
databricks_account_id = ""
resource_owner = ""
resource_prefix = "standard-terraform-example"

// AWS Variables
aws_access_key = ""
aws_secret_key = ""
aws_account_id = ""
data_bucket = ""
cross_region_bucket = ""

// Dataplane Variables
region = "us-east-1"
cross_region = "us-west-1"
vpc_cidr_range = "10.0.0.0/18"
private_subnets_cidr = "10.0.16.0/21,10.0.24.0/21"
privatelink_subnets_cidr = "10.0.32.128/26,10.0.32.192/26"
cross_region_vpc_cidr_range  = "172.0.0.0/26"
cross_region_subnet_cidr = "172.0.0.0/27"
availability_zones = "us-east-1a,us-east-1b"

// Regional Private Link Variables: https://docs.databricks.com/administration-guide/cloud-configurations/aws/privatelink.html#regional-endpoint-reference
relay_vpce_service = ""
workspace_vpce_service = ""
