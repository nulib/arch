terraform {
  backend "s3" {
    key    = "arch.tfstate"
  }
}

provider "aws" { }

data "aws_region" "current" { }

locals {
  aws_region            = data.aws_region.current.name
  namespace             = module.core.outputs.stack.namespace
  domain_host           = "${var.app_name}.${module.core.outputs.vpc.public_dns_zone.name}"
  zookeeper_endpoint    = "${element(module.solrcloud.outputs.zookeeper.servers, 0)}/configs"

  tags = merge(
    module.core.outputs.stack.tags, 
    {
      Component   = "arch"
      Git         = "github.com/nulib/arch"
      Project     = "Arch"
    }
  )
}

module "core" {
  source = "git::https://github.com/nulib/infrastructure.git//modules/remote_state"
  component = "core"
}

module "data_services" {
  source = "git::https://github.com/nulib/infrastructure.git//modules/remote_state"
  component = "data_services"
}

module "fcrepo" {
  source = "git::https://github.com/nulib/infrastructure.git//modules/remote_state"
  component = "fcrepo"
}

module "solrcloud" {
  source = "git::https://github.com/nulib/infrastructure.git//modules/remote_state"
  component = "solrcloud"
}

resource "aws_efs_file_system" "arch_derivatives_volume" {
  encrypted      = false
  tags           = merge(local.tags, { Name = "stack-${var.app_name}-derivatives"})
}

resource "aws_efs_mount_target" "arch_derivatives_mount_target" {
  for_each          = toset(module.core.outputs.vpc.private_subnets.ids)
  file_system_id    = aws_efs_file_system.arch_derivatives_volume.id
  security_groups   = [
    aws_security_group.arch_derivatives_access.id
  ]
  subnet_id         = each.key
}

resource "aws_security_group" "arch_derivatives_access" {
  name        = "${local.namespace}-arch-derivatives"
  description = "Arch derivatives Volume Security Group"
  vpc_id      = module.core.outputs.vpc.id

  tags = local.tags
}

resource "aws_security_group_rule" "arch_derivatives_egress" {
  security_group_id   = aws_security_group.arch_derivatives_access.id
  type                = "egress"
  from_port           = 0
  to_port             = 65535
  protocol            = -1
  cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "arch_derivatives_ingress" {
  security_group_id           = aws_security_group.arch_derivatives_access.id
  type                        = "ingress"
  from_port                   = 2049
  to_port                     = 2049
  protocol                    = "tcp"
  source_security_group_id    = aws_security_group.arch.id
}

resource "aws_security_group_rule" "arch_derivatives_ingress_bastion" {
  security_group_id           = aws_security_group.arch_derivatives_access.id
  type                        = "ingress"
  from_port                   = 2049
  to_port                     = 2049
  protocol                    = "tcp"
  source_security_group_id    = module.core.outputs.bastion.security_group
}

resource "aws_efs_file_system" "arch_working_volume" {
  encrypted      = false
  tags           = merge(local.tags, { Name = "stack-${var.app_name}-working"})
}

resource "aws_efs_mount_target" "arch_working_mount_target" {
  for_each          = toset(module.core.outputs.vpc.private_subnets.ids)
  file_system_id    = aws_efs_file_system.arch_working_volume.id
  security_groups   = [
    aws_security_group.arch_working_access.id
  ]
  subnet_id         = each.key
}

resource "aws_security_group" "arch_working_access" {
  name        = "${local.namespace}-arch-working"
  description = "Arch Working Volume Security Group"
  vpc_id      = module.core.outputs.vpc.id

  tags = local.tags
}

resource "aws_security_group_rule" "arch_working_egress" {
  security_group_id   = aws_security_group.arch_working_access.id
  type                = "egress"
  from_port           = 0
  to_port             = 65535
  protocol            = -1
  cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "arch_working_ingress" {
  security_group_id           = aws_security_group.arch_working_access.id
  type                        = "ingress"
  from_port                   = 2049
  to_port                     = 2049
  protocol                    = "tcp"
  source_security_group_id    = aws_security_group.arch.id
}

resource "aws_security_group_rule" "arch_working_ingress_bastion" {
  security_group_id           = aws_security_group.arch_working_access.id
  type                        = "ingress"
  from_port                   = 2049
  to_port                     = 2049
  protocol                    = "tcp"
  source_security_group_id    = module.core.outputs.bastion.security_group
}

resource "aws_s3_bucket" "arch_archive_bucket" {
  bucket = "${local.namespace}-arch-archives"
  acl    = "private"
  tags   = local.tags

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 3
    enabled                                = true
    id                                     = "auto-delete-after-15-days"

    expiration {
      days                         = 7
      expired_object_delete_marker = false
    }
  }

  lifecycle {
    ignore_changes = [bucket]
  }  
}

resource "aws_s3_bucket" "arch_dropbox_bucket" {
  bucket = "${local.namespace}-arch-dropbox"
  acl  = "private"
  tags = local.tags

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 3
    enabled                                = true
    id                                     = "auto-delete-after-15-days"

    expiration {
      days                         = 15
      expired_object_delete_marker = false
    }
  }

  lifecycle {
    ignore_changes = [bucket]
  }  
}

data "aws_iam_policy_document" "this_bucket_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:CreateBucket",
      "s3:ListAllMyBuckets"
    ]
    resources = ["arn:aws:s3:::*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy"
    ]

    resources = [
      aws_s3_bucket.arch_archive_bucket.arn,
      aws_s3_bucket.arch_dropbox_bucket.arn
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = [
      "${aws_s3_bucket.arch_archive_bucket.arn}/*",
      "${aws_s3_bucket.arch_dropbox_bucket.arn}/*"
    ]
  }
}

resource "aws_security_group" "arch" {
  name        = var.app_name
  description = "The Arch Application"
  vpc_id      = module.core.outputs.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_security_group_rule" "allow_alb_access" {
  type              = "ingress"
  from_port         = "3000"
  to_port           = "3000"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.arch.id
}

resource "aws_route53_record" "app_hostname" {
  zone_id = module.core.outputs.vpc.public_dns_zone.id
  name    = var.app_name
  type    = "A"

  alias {
    name                   = aws_lb.arch_load_balancer.dns_name
    zone_id                = aws_lb.arch_load_balancer.zone_id
    evaluate_target_health = true
  }
}
