vpc_cidr             = "10.0.0.0/16"
enable_dns_hostnames = true
enable_dns_support   = true
Environment          = "Dev"
public_cidr          = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_cidr         = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
azs                  = ["us-east-1a", "us-east-1b"]
ami                  = ["ami-0889a44b331db0194", "ami-007855ac798b5175e", "ami-016eb5d644c333ccb"]
key_name             = ["", ""]
instance_type        = ["t2.micro", "t2.small"]
