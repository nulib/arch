locals {
  settings_prefix = "/${var.app_name}/Settings"
}

resource "aws_ssm_parameter" "arch-contact_email" {
  type  = "String"
  name  = "${local.settings_prefix}/arch/contact_email"
  value = var.email_contact
}

resource "aws_ssm_parameter" "aws-buckets-archives" {
  type  = "String"
  name  = "${local.settings_prefix}/aws/buckets/archives"
  value = aws_s3_bucket.arch_archive_bucket.bucket
}

resource "aws_ssm_parameter" "aws-buckets-dropbox" {
  type  = "String"
  name  = "${local.settings_prefix}/aws/buckets/dropbox"
  value = aws_s3_bucket.arch_dropbox_bucket.bucket
}

resource "aws_ssm_parameter" "doi_credentials-default_shoulder" {
  type  = "String"
  name  = "${local.settings_prefix}/doi_credentials/default_shoulder"
  value = var.doi_shoulder
}

resource "aws_ssm_parameter" "doi_credentials-host" {
  type  = "String"
  name  = "${local.settings_prefix}/doi_credentials/host"
  value = var.doi_host
}

resource "aws_ssm_parameter" "doi_credentials-password" {
  type  = "String"
  name  = "${local.settings_prefix}/doi_credentials/password"
  value = var.doi_password
}

resource "aws_ssm_parameter" "doi_credentials-port" {
  type  = "String"
  name  = "${local.settings_prefix}/doi_credentials/port"
  value = "443"
}

resource "aws_ssm_parameter" "doi_credentials-use_ssl" {
  type  = "String"
  name  = "${local.settings_prefix}/doi_credentials/use_ssl"
  value = "1"
}

resource "aws_ssm_parameter" "doi_credentials-user" {
  type  = "String"
  name  = "${local.settings_prefix}/doi_credentials/user"
  value = var.doi_username
}

resource "aws_ssm_parameter" "geonames_username" {
  type  = "String"
  name  = "${local.settings_prefix}/geonames_username"
  value = var.geonames_username
}

resource "aws_ssm_parameter" "domain-host" {
  type  = "String"
  name  = "${local.settings_prefix}/domain/host"
  value = aws_route53_record.app_hostname.fqdn
}

resource "aws_ssm_parameter" "nusso-base_url" {
  type  = "String"
  name  = "${local.settings_prefix}/nusso/base_url"
  value = "https://northwestern-prod.apigee.net/agentless-websso/"
}

resource "aws_ssm_parameter" "nusso-consumer_key" {
  type  = "String"
  name  = "${local.settings_prefix}/nusso/consumer_key"
  value = var.agentless_sso_key
}

resource "aws_ssm_parameter" "proquest-dissertation_depositor" {
  type  = "String"
  name  = "${local.settings_prefix}/proquest/dissertation_depositor"
  value = var.dissertation_depositor
}

resource "aws_ssm_parameter" "recaptcha-secret_key" {
  type  = "String"
  name  = "${local.settings_prefix}/recaptcha/secret_key"
  value = var.recaptcha_secret_key
}

resource "aws_ssm_parameter" "recaptcha-site_key" {
  type  = "String"
  name  = "${local.settings_prefix}/recaptcha/site_key"
  value = var.recaptcha_site_key
}

resource "aws_ssm_parameter" "solr-url" {
  type  = "String"
  name  = "${local.settings_prefix}/solr/url"
  value   = "${module.solrcloud.outputs.solr.endpoint}/arch"
}

resource "aws_ssm_parameter" "solrcloud" {
  type  = "String"
  name  = "${local.settings_prefix}/solrcloud"
  value = "true"
}

resource "aws_ssm_parameter" "zookeeper-connection_str" {
  type  = "String"
  name  = "${local.settings_prefix}/zookeeper/connection_str"
  value   = local.zookeeper_endpoint
}
