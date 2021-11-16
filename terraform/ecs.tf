resource "aws_ecs_cluster" "arch" {
  name = local.secrets.app_name
  tags = local.tags
}

data "aws_acm_certificate" "arch_cert" {
  domain = local.secrets.arch_certificate_domain
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "arch_role_permissions" {
  statement {
    sid    = "lambda"
    effect = "Allow"
    actions = [
      "lambda:GetFunction",
      "lambda:InvokeFunction"
    ]
    resources = ["*"]
  }
  
  statement {
    sid    = "sns"
    effect = "Allow"
    actions = [
      "sns:CreateTopic",
      "sns:GetSubscriptionAttributes",
      "sns:ListSubscriptions",
      "sns:ListTopics",
      "sns:Publish",
      "sns:SetSubscriptionAttributes",
      "sns:Subscribe",
      "sns:Unsubscribe"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "sqs"
    effect = "Allow"
    actions = [
      "sqs:CreateQueue",
      "sqs:DeleteMessage",
      "sqs:DeleteMessageBatch",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ListQueues",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
      "sqs:SendMessageBatch",
      "sqs:SetQueueAttributes"
    ]
    resources = ["arn:aws:sqs:${local.aws_region}:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    sid    = "configuration"
    effect = "Allow"
    actions = [
      "ssm:Get*"
    ]
    resources = ["arn:aws:ssm:${local.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/arch/*"]
  }

  statement {
    sid = "email"
    effect = "Allow"
    actions = [
      "ses:Send*"
    ]
    resources = ["*"]
  }
}

resource "aws_security_group" "arch_load_balancer" {
  name          = "${local.secrets.app_name}-lb"
  description   = "arch Load Balancer Security Group"
  vpc_id        = module.core.outputs.vpc.id
  tags          = local.tags
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description   = "HTTP in"
    from_port     = 80
    to_port       = 80
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    description   = "HTTPS in"
    from_port     = 443
    to_port       = 443
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }
}

data "aws_iam_policy" "ecs_exec_command" {
  name = "allow-ecs-exec"
}

resource "aws_iam_role" "arch_role" {
  name               = "${local.secrets.app_name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
  tags               = local.tags
}

resource "aws_iam_policy" "arch_role_policy" {
  name   = "${local.secrets.app_name}-policy"
  policy = data.aws_iam_policy_document.arch_role_permissions.json
  tags   = local.tags
}

resource "aws_iam_role_policy_attachment" "arch_role_policy" {
  role       = aws_iam_role.arch_role.id
  policy_arn = aws_iam_policy.arch_role_policy.arn
}

resource "aws_iam_policy" "this_bucket_policy" {
  name   = "arch-bucket-access"
  policy = data.aws_iam_policy_document.this_bucket_access.json
  tags   = local.tags
}

resource "aws_iam_role_policy_attachment" "bucket_role_access" {
  role       = aws_iam_role.arch_role.name
  policy_arn = aws_iam_policy.this_bucket_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_exec_command" {
  role       = aws_iam_role.arch_role.id
  policy_arn = data.aws_iam_policy.ecs_exec_command.arn
}

resource "aws_cloudwatch_log_group" "arch_logs" {
  name                = "/ecs/${local.secrets.app_name}"
  retention_in_days   = 30
  tags                = local.tags
}
resource "aws_lb_target_group" "arch_target" {
  port                    = 3000
  deregistration_delay    = 30
  target_type             = "ip"
  protocol                = "HTTP"
  vpc_id                  = module.core.outputs.vpc.id
  tags                    = local.tags

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }
}

resource "aws_lb" "arch_load_balancer" {
  name               = "${local.secrets.app_name}-lb"
  internal           = false
  load_balancer_type = "application"

  subnets         = module.core.outputs.vpc.public_subnets.ids
  security_groups = [aws_security_group.arch_load_balancer.id]
  tags    = local.tags
}

resource "aws_lb_listener" "arch_lb_listener_http" {
  load_balancer_arn = aws_lb.arch_load_balancer.arn
  port              = 80
  protocol          = "HTTP"
  tags              = local.tags

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "arch_lb_listener_https" {
  load_balancer_arn = aws_lb.arch_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.arch_cert.arn
  tags              = local.tags
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.arch_target.arn
  }
}

resource "random_id" "secret_key_base" {
  byte_length = 32
}
