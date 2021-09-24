module "core" {
  source = "git::https://github.com/nulib/infrastructure.git//modules/remote_state"
  component = "core"
}

resource "aws_ecs_task_definition" "this_task_definition" {
  family                   = "${var.app_name}-${var.container_role}"
  container_definitions    = jsonencode([
    {
      name = "arch"
      image = "${module.core.outputs.ecs.registry_url}/${var.app_name}:${var.container_config.docker_tag}"
      cpu = var.cpu * 0.9765625
      memoryReservation = var.memory * 0.9765625
      mountPoints = []
      essential = true
      environment = [
        { name = "AWS_REGION",               value = var.container_config.region },
        { name = "CONTAINER_ROLE",           value = var.container_role },
        { name = "DATABASE_URL",             value = var.container_config.database_url },
        { name = "FEDORA_BASE_PATH",         value = var.container_config.fedora_base_path },
        { name = "FEDORA_URL",               value = var.container_config.fedora_url },
        { name = "HONEYBADGER_API_KEY",      value = var.container_config.honeybadger_api_key },
        { name = "HONEYBADGER_ENV",          value = var.container_config.honeybadger_environment },
        { name = "RACK_ENV",                 value = "production" },
        { name = "RAILS_LOG_TO_STDOUT",      value = "true"},
        { name = "RAILS_LOG_WITH_LOGRAGE",   value = "true"},
        { name = "RAILS_SERVE_STATIC_FILES", value = "true"},
        { name = "REDIS_HOST",               value = var.container_config.redis_host },
        { name = "REDIS_PORT",               value = var.container_config.redis_port },
        { name = "REDIS_URL",                value = "redis://${var.container_config.redis_host}:${var.container_config.redis_port}/" },
        { name = "SECRET_KEY_BASE",          value = var.container_config.secret_key_base },
        { name = "SOLR_URL",                 value = var.container_config.solr_url },
        { name = "SSM_PARAM_PATH",           value = "/${var.app_name}" },
        {
          name  = "SETTINGS__ACTIVE_JOB__QUEUE_ADAPTER",
          value = "shoryuken"
        },
        {
          name  = "SETTINGS__ACTIVE_JOB__QUEUE_NAME_DELIMITER",
          value = "-"
        },
        {
          name  = "SETTINGS__ACTIVE_JOB__QUEUE_NAME_PREFIX",
          value = var.app_name
        },
        {
          name  = "SETTINGS__SOLR__COLLECTION_OPTIONS__AUTO_ADD_REPLICAS",
          value = "true"
        },
        {
          name  = "SETTINGS__SOLR__COLLECTION_OPTIONS__MAX_SHARDS_PER_NODE",
          value = "1"
        },
        {
          name  = "SETTINGS__SOLR__COLLECTION_OPTIONS__REPLICATION_FACTOR",
          value = var.container_config.solr_cluster_size
        },
        {
          name  = "SETTINGS__SOLR__COLLECTION_OPTIONS__RULE",
          value = "replica:<2,node:*"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = var.container_config.log_group
          awslogs-region = var.container_config.region
          awslogs-stream-prefix = var.container_role
        }
      }
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      mountPoints = [
        { 
          "sourceVolume": "arch-derivatives",
          "containerPath": "/var/arch-derivatives"
        },
        { 
          "sourceVolume": "arch-working",
          "containerPath": "/var/arch-working"
        }
      ]
    }
  ])

  volume {
    name = "arch-derivatives"
    efs_volume_configuration {
      file_system_id = var.container_config.derivatives_volume_id
    }
  }

  volume {
    name = "arch-working"
    efs_volume_configuration {
      file_system_id = var.container_config.working_volume_id
    }
  }

  task_role_arn            = var.role_arn
  execution_role_arn       = module.core.outputs.ecs.task_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  tags                     = var.tags
}
