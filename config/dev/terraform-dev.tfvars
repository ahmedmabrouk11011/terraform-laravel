# Variables definition for the terraform code

#########################################
# CREDENTIALS AND REGION
#########################################

aws_region  = "us-east-1"
aws_profile = "personal-terraform"
environment = "dev"

tags = {
  Environment = "dev",
  ManagedBy   = "terraform",
  DeployedBy  = "AhmedMabrouk"
}


# The name of the vpc
vpc_name = "laravel-vpc"

# The cidr block of the vpc
vpc_cidr = "10.30.0.0/16"

# The cidr blocks and names of the public subnets
public_subnets = {
  "public-subnet-1" = {
    name              = "laravel-vpc-public-1",
    cidr              = "10.30.1.0/24",
    availability_zone = "us-east-1a"
  },
  "public-subnet-2" = {
    name              = "laravel-vpc-public-2",
    cidr              = "10.30.2.0/24",
    availability_zone = "us-east-1b"
  }
}

# The cidr blocks and names of the private subnets
private_subnets = {
  "private-subnet-1" = {
    name              = "laravel-vpc-private-1",
    cidr              = "10.30.14.0/24",
    availability_zone = "us-east-1a"
  },
  "private-subnet-2" = {
    name              = "laravel-vpc-private-2",
    cidr              = "10.30.12.0/24",
    availability_zone = "us-east-1b"
  }
}

# The cidr blocks and names of the database subnets
database_subnets = {
  "db-subnet-1" = {
    name              = "laravel-vpc-database-1",
    cidr              = "10.30.21.0/24",
    availability_zone = "us-east-1a"
  },
  "db-subnet-2" = {
    name              = "laravel-vpc-database-2",
    cidr              = "10.30.22.0/24",
    availability_zone = "us-east-1b"
  }
}



#########################################
#  EC2
#########################################

ec2s = {
  "Server1" = {
    name          = "MegaStarProject-Server1",
    instance_type = "t2.micro",
    instance_ami  = "ami-053b0d53c279acc90" #Ubuntu Server 22.04 LTS (HVM), SSD Volume Type  
  }
}
