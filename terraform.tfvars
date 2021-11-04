region                     = "us-east-1"
instance_type              = "t2.small"
enable_detailed_monitoring = true

common_tags = {
  Owner       = "Alex Tchaikovski"
  Project     = "Jenkins"
  Purpose     = "Jenkins"
}

host_name = "jenkins"