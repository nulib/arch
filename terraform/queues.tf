locals {
  queues = {
    # queue name => visibility timeout in seconds
    default = 300
  }
}

resource "aws_sqs_queue" "arch_dead_letter_queue" {
  name    = "${var.app_name}-dead_letter_queue"
  tags    = local.tags
}

resource "aws_sqs_queue" "active_job_queue" {
  for_each                      = local.queues
  name                          = "${var.app_name}-${each.key}"
  visibility_timeout_seconds    = each.value
  tags                          = local.tags

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.arch_dead_letter_queue.arn
    maxReceiveCount     = 5
  })
}