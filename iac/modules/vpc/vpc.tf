# Resource for VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_conf.vpc.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
              {
              "Name"        = "${var.environment}-vpc"
              "Environment" = var.environment
              },
              var.vpc_conf.vpc.additional_tags
          )
}

# Internet Gateway is used to enable connection to internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"        = "${var.environment}-igw"
    "Environment" = var.environment
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Creation of Public Subnets

resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.vpc_conf.public_subnets.public_subnet_cidr_0
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = merge(
            {
              "Name" = "${var.environment}-public-subnet-A"
              "Environment" = var.environment
            },
            var.vpc_conf.public_subnets.additional_tags
        )
}

# # Creation of APP Private Subnets

# resource "aws_subnet" "app_subnets" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = var.vpc_conf.private_app_subnets.private_subnet_cidr_0
#   availability_zone       = data.aws_availability_zones.available.names[0]
#   tags = merge(
#             {
#               "Name"        = "${var.environment}-private-subnet-A"
#               "Environment" = var.environment
#             },
#             var.vpc_conf.private_app_subnets.additional_tags
#         )
# }

# Creation of DB Private Subnets

resource "aws_subnet" "db_subnets" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.vpc_conf.private_db_subnets.private_subnet_cidr_3
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = merge(
            {
              "Name"  = "${var.environment}-private-subnet-D"
              "Environment" = var.environment
            },
            var.vpc_conf.private_db_subnets.additional_tags
        )
}

# Creation of Public route table having route to IGW

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    {
      "Name"        = "${var.environment}-public-route-table"
      "Environment" = var.environment
    },
      var.vpc_conf.public_rt.additional_tags
  )
}

# # Creation of Private route table having route to NATs

# resource "aws_route_table" "rtb_app" {
#   vpc_id = aws_vpc.vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.ngwA.id
#   }
#   tags = merge(
#     {
#       "Name"        = "${var.environment}-private-route-table"
#       "Environment" = var.environment
#     },
#       var.vpc_conf.app_rt.additional_tags
#   )
# }

resource "aws_route_table" "rtb_db" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    {
      "Name"        = "${var.environment}-private-route-table"
      "Environment" = var.environment
    },
      var.vpc_conf.db_rt.additional_tags
  )
}

# Associating subnets to a route table. 1 route table can have multiple subnets associated with it

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.public_subnets.id
  route_table_id = aws_route_table.rtb_public.id
}

# resource "aws_route_table_association" "rta_subnet_app" {
#   subnet_id      = aws_subnet.app_subnets.id
#   route_table_id = aws_route_table.rtb_app.id
# }

resource "aws_route_table_association" "rta_subnet_app" {
  subnet_id      = aws_subnet.db_subnets.id
  route_table_id = aws_route_table.rtb_db.id
}