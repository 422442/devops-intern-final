job "hello-app" {
  # Specify the region and datacenter
  region = "global"
  datacenters = ["dc1"]

  # Job type - service ensures the job keeps running
  type = "service"

  # Job metadata
  meta {
    version = "1.0"
    project = "devops-intern-final"
  }

  # Define the task group
  group "app" {
    # Number of instances to run
    count = 1

    # Restart policy
    restart {
      attempts = 3
      interval = "5m"
      delay    = "25s"
      mode     = "fail"
    }

    # Update strategy for rolling deployments
    update {
      max_parallel     = 1
      min_healthy_time = "10s"
      healthy_deadline = "3m"
      auto_revert      = true
    }

    # Network configuration (if needed for port mapping)
    network {
      mode = "bridge"
    }

    # Define the task
    task "hello-devops" {
      # Use Docker driver
      driver = "docker"

      # Docker configuration
      config {
        image = "devops-hello:latest"
        
        # Force pull the latest image
        force_pull = false
        
        # Container labels
        labels {
          app     = "hello-devops"
          version = "1.0"
        }

        # Logging configuration
        logging {
          type = "json-file"
          config {
            max-file = "3"
            max-size = "10m"
          }
        }
      }

      # Environment variables
      env {
        MESSAGE = "Hello from Nomad!"
        ENVIRONMENT = "production"
      }

      # Resource allocation
      resources {
        cpu    = 100  # MHz
        memory = 128  # MB
      }

      # Service discovery and health checks (optional)
      service {
        name = "hello-devops-app"
        tags = ["devops", "hello", "production"]

        # Health check
        check {
          type     = "script"
          name     = "hello-health"
          command  = "python"
          args     = ["hello.py"]
          interval = "30s"
          timeout  = "5s"
        }
      }

      # Logs configuration
      logs {
        max_files     = 5
        max_file_size = 10
      }

      # Kill timeout
      kill_timeout = "30s"

      # Kill signal
      kill_signal = "SIGINT"
    }
  }
}
