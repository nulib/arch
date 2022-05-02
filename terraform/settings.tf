locals {
  settings_prefix = "/${local.secrets.app_name}/Settings"
}

resource "aws_ssm_parameter" "arch-contact_email" {
  type    = "String"
  name    = "${local.settings_prefix}/arch/contact_email"
  value   = local.secrets.email_contact
  tags    = local.tags
}

resource "aws_ssm_parameter" "aws-buckets-archives" {
  type    = "String"
  name    = "${local.settings_prefix}/aws/buckets/archives"
  value   = aws_s3_bucket.arch_archive_bucket.bucket
  tags    = local.tags
}

resource "aws_ssm_parameter" "aws-buckets-dropbox" {
  type    = "String"
  name    = "${local.settings_prefix}/aws/buckets/dropbox"
  value   = aws_s3_bucket.arch_dropbox_bucket.bucket
  tags    = local.tags
}

resource "aws_ssm_parameter" "aws-queues-encode" {
  type    = "String"
  name    = "${local.settings_prefix}/aws/queues/encode"
  value   = "encode"
  tags    = local.tags
}

resource "aws_ssm_parameter" "doi_credentials-default_shoulder" {
  type    = "String"
  name    = "${local.settings_prefix}/doi_credentials/default_shoulder"
  value   = local.secrets.doi_shoulder
  tags    = local.tags
}

resource "aws_ssm_parameter" "doi_credentials-host" {
  type    = "String"
  name    = "${local.settings_prefix}/doi_credentials/host"
  value   = local.secrets.doi_host
  tags    = local.tags
}

resource "aws_ssm_parameter" "doi_credentials-password" {
  type    = "String"
  name    = "${local.settings_prefix}/doi_credentials/password"
  value   = local.secrets.doi_password
  tags    = local.tags
}

resource "aws_ssm_parameter" "doi_credentials-port" {
  type    = "String"
  name    = "${local.settings_prefix}/doi_credentials/port"
  value   = "443"
  tags    = local.tags
}

resource "aws_ssm_parameter" "doi_credentials-use_ssl" {
  type    = "String"
  name    = "${local.settings_prefix}/doi_credentials/use_ssl"
  value   = "1"
  tags    = local.tags
}

resource "aws_ssm_parameter" "doi_credentials-user" {
  type    = "String"
  name    = "${local.settings_prefix}/doi_credentials/user"
  value   = local.secrets.doi_username
  tags    = local.tags
}

resource "aws_ssm_parameter" "geonames_username" {
  type    = "String"
  name    = "${local.settings_prefix}/geonames_username"
  value   = local.secrets.geonames_username
  tags    = local.tags
}

resource "aws_ssm_parameter" "domain-host" {
  type    = "String"
  name    = "${local.settings_prefix}/domain/host"
  value   = aws_route53_record.app_hostname.fqdn
  tags    = local.tags
}

resource "aws_ssm_parameter" "email-mailer" {
  type    = "String"
  name    = "${local.settings_prefix}/email/mailer"
  value   = "aws_sdk"
  tags    = local.tags
}

resource "aws_ssm_parameter" "nusso-base_url" {
  type    = "String"
  name    = "${local.settings_prefix}/nusso/base_url"
  value   = "https://northwestern-prod.apigee.net/agentless-websso/"
  tags    = local.tags
}

resource "aws_ssm_parameter" "nusso-consumer_key" {
  type    = "String"
  name    = "${local.settings_prefix}/nusso/consumer_key"
  value   = local.secrets.agentless_sso_key
  tags    = local.tags
}

resource "aws_ssm_parameter" "proquest-dissertation_depositor" {
  type    = "String"
  name    = "${local.settings_prefix}/proquest/dissertation_depositor"
  value   = local.secrets.dissertation_depositor
  tags    = local.tags
}

resource "aws_ssm_parameter" "recaptcha-secret_key" {
  type    = "String"
  name    = "${local.settings_prefix}/recaptcha/secret_key"
  value   = local.secrets.recaptcha_secret_key
  tags    = local.tags
}

resource "aws_ssm_parameter" "recaptcha-site_key" {
  type    = "String"
  name    = "${local.settings_prefix}/recaptcha/site_key"
  value   = local.secrets.recaptcha_site_key
  tags    = local.tags
}

resource "aws_ssm_parameter" "solr-url" {
  type    = "String"
  name    = "${local.settings_prefix}/solr/url"
  value   = "${module.solrcloud.outputs.solr.endpoint}/arch"
  tags    = local.tags
}

resource "aws_ssm_parameter" "solrcloud" {
  type    = "String"
  name    = "${local.settings_prefix}/solrcloud"
  value   = "true"
  tags    = local.tags
}

resource "aws_ssm_parameter" "zookeeper-connection_str" {
  type    = "String"
  name    = "${local.settings_prefix}/zookeeper/connection_str"
  value   = local.zookeeper_endpoint
  tags    = local.tags
}
