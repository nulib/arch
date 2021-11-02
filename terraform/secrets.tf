data "aws_region" "current" { }

locals {
  secrets = module.secrets.vars
  aws_region = data.aws_region.current.name
}

module "secrets" {
  source    = "git::https://github.com/nulib/infrastructure.git//modules/secrets"
  path      = "arch"
  defaults  = jsonencode({
    additional_hostnames    = []
    app_name                = "arch"
    arch_certificate_domain = "*.${trimsuffix(module.core.outputs.vpc.public_dns_zone.name, ".")}"
    availability_zones      = ["us-east-1a", "us-east-1b", "us-east-1c"]
    certificate_name        = "*"
    email_contact           = "repository@northwestern.edu"
    honeybadger_api_key     = ""
  })
}
