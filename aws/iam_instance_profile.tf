resource "aws_iam_role" "s3_instance_profile" {
  name = "${local.prefix}-s3-instance-profile"
  description        = "Role for S3 access"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
    tags = {
    Name = "${local.prefix}-s3-instance-profile"
  }
}

resource "aws_iam_role_policy" "s3_instance-profile" {
  name   = "${local.prefix}-s3-instance-profile-policy"
  role   = aws_iam_role.s3_instance_profile.id
  policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${var.data_bucket}",
                "arn:aws:s3:::${var.cross_region_bucket}"
            ]
            },
            {
            "Effect": "Allow",
            "Action": [
                "s3:*Object",
            ],
            "Resource": [
                "arn:aws:s3:::${var.data_bucket}/*",
                "arn:aws:s3:::${var.cross_region_bucket}"
            ]
            }
        ]
        }
  )
}


resource "aws_iam_instance_profile" "s3_instance_profile" {
  name = "${local.prefix}-s3-instance-profile"
  role = aws_iam_role.s3_instance_profile.name
}