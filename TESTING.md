# Testing Guide for DevOps Intern Final Assessment

This document provides step-by-step testing instructions for all components of the DevOps pipeline.

## Table of Contents
1. [Local Python Testing](#1-local-python-testing)
2. [Shell Script Testing](#2-shell-script-testing)
3. [Docker Testing](#3-docker-testing)
4. [CI/CD Testing](#4-cicd-testing)
5. [Nomad Testing](#5-nomad-testing)
6. [Monitoring Testing](#6-monitoring-testing)

---

## 1. Local Python Testing

### Test Basic Execution
```bash
# Run the Python script
python hello.py

# Expected output:
# Hello, DevOps!
# [2025-10-17 HH:MM:SS] Application executed successfully
```

### Test Custom Message
```bash
# Set environment variable and run
export MESSAGE="Testing Custom Message"
python hello.py

# On Windows PowerShell:
$env:MESSAGE="Testing Custom Message"
python hello.py

# Expected output:
# Testing Custom Message
# [2025-10-17 HH:MM:SS] Application executed successfully
```

### Verify Python Version
```bash
python --version
# Should be Python 3.9 or higher
```

---

## 2. Shell Script Testing

### Make Script Executable (Linux/macOS)
```bash
chmod +x scripts/sysinfo.sh
```

### Run System Info Script
```bash
# Linux/macOS:
./scripts/sysinfo.sh

# Windows (Git Bash or WSL):
bash scripts/sysinfo.sh

# Expected output sections:
# - Current User
# - Current Date and Time
# - System Uptime
# - Disk Usage
# - Memory Usage (if available)
# - CPU Information
# - Hostname
# - Current Working Directory
```

### Validate Script Syntax
```bash
bash -n scripts/sysinfo.sh
# No output means syntax is correct
```

---

## 3. Docker Testing

### Build Docker Image
```bash
# Build the image
docker build -t devops-hello:latest .

# Expected: Successfully built message with image ID
```

### Verify Image Created
```bash
docker images | grep devops-hello

# Expected output:
# devops-hello    latest    <IMAGE_ID>    <CREATED>    ~50MB
```

### Run Container (Default)
```bash
docker run --rm devops-hello:latest

# Expected output:
# Hello, DevOps!
# [2025-10-17 HH:MM:SS] Application executed successfully
```

### Run Container with Custom Message
```bash
docker run --rm -e MESSAGE="Hello from Docker!" devops-hello:latest

# Expected output:
# Hello from Docker!
# [2025-10-17 HH:MM:SS] Application executed successfully
```

### Inspect Docker Image
```bash
docker inspect devops-hello:latest

# Check for:
# - Image size
# - Labels
# - Environment variables
# - Entry point
```

### Test Container Security
```bash
# Verify non-root user
docker run --rm devops-hello:latest whoami
# Expected: appuser

# Check image vulnerabilities (if Trivy installed)
trivy image devops-hello:latest
```

### Run with Docker Compose
```bash
# Start all services
docker-compose up -d

# Check running containers
docker-compose ps

# View logs
docker-compose logs hello-app

# Stop services
docker-compose down
```

---

## 4. CI/CD Testing

### Local GitHub Actions Testing (with act)
If you have `act` installed:

```bash
# Install act (if not installed)
# brew install act  # macOS
# choco install act-cli  # Windows

# Run the CI workflow locally
act push

# Expected: All jobs pass successfully
```

### Test on GitHub
```bash
# Initialize git repository (if not done)
git init
git add .
git commit -m "Initial commit - DevOps pipeline complete"

# Create GitHub repository (via web or gh cli)
gh repo create devops-intern-final --public --source=. --remote=origin

# Push to GitHub
git push -u origin main

# Check GitHub Actions tab for pipeline status
```

### Verify CI Badge
- Go to your GitHub repository
- Check the README for the CI badge
- Click the badge to view workflow runs

---

## 5. Nomad Testing

### Install Nomad (if not installed)
```bash
# Linux
wget https://releases.hashicorp.com/nomad/1.6.3/nomad_1.6.3_linux_amd64.zip
unzip nomad_1.6.3_linux_amd64.zip
sudo mv nomad /usr/local/bin/

# macOS
brew install nomad

# Windows
choco install nomad

# Verify installation
nomad version
```

### Validate Nomad Job File
```bash
# Check syntax only
nomad job validate nomad/hello.nomad

# Expected: Job validation successful
```

### Start Nomad in Dev Mode (Local Testing)
```bash
# Start Nomad agent in dev mode (new terminal)
nomad agent -dev

# In another terminal, run the job
nomad job run nomad/hello.nomad

# Expected: Job "hello-app" submitted
```

### Check Job Status
```bash
# List all jobs
nomad job status

# Check specific job
nomad job status hello-app

# Expected: Status shows "running"
```

### View Job Logs
```bash
# Get allocation ID
nomad job status hello-app

# View logs (replace <alloc-id>)
nomad alloc logs <alloc-id>

# Stream logs
nomad alloc logs -f <alloc-id>
```

### Stop Nomad Job
```bash
nomad job stop hello-app

# Verify stopped
nomad job status hello-app
```

---

## 6. Monitoring Testing

### Start Loki
```bash
# Using Docker
docker run -d --name=loki -p 3100:3100 grafana/loki:latest

# Verify Loki is ready
curl http://localhost:3100/ready

# Expected: ready
```

### Test Loki API
```bash
# Check metrics
curl http://localhost:3100/metrics

# Push test log
curl -H "Content-Type: application/json" \
  -X POST http://localhost:3100/loki/api/v1/push \
  -d '{"streams": [{"stream": {"job": "test"}, "values": [["'"$(date +%s)000000000"'", "test log message"]]}]}'
```

### Query Logs from Loki
```bash
# Query all logs
curl -G -s "http://localhost:3100/loki/api/v1/query" \
  --data-urlencode 'query={job=~".+"}'

# Query with time range (last hour)
curl -G -s "http://localhost:3100/loki/api/v1/query_range" \
  --data-urlencode 'query={job=~".+"}' \
  --data-urlencode 'start='$(date -u -d '1 hour ago' +%s)'000000000' \
  --data-urlencode 'end='$(date -u +%s)'000000000'
```

### Start Complete Monitoring Stack
```bash
# Using Docker Compose
docker-compose up -d loki promtail grafana

# Verify all services running
docker-compose ps

# Check logs
docker-compose logs loki
docker-compose logs promtail
```

### Access Grafana
```bash
# Open browser to http://localhost:3000
# Login: admin / admin

# Add Loki data source:
# 1. Configuration → Data Sources → Add data source
# 2. Select "Loki"
# 3. URL: http://loki:3100
# 4. Save & Test (should show "Data source is working")
```

### Create Grafana Dashboard
1. Go to Dashboards → New Dashboard
2. Add new panel
3. Select Loki data source
4. Enter query: `{job="docker"}`
5. Save dashboard

---

## 7. Integration Testing

### Full Stack Test
```bash
# 1. Start monitoring stack
docker-compose up -d loki grafana

# 2. Build and run application
docker build -t devops-hello:latest .
docker run --rm --name hello-test devops-hello:latest

# 3. Check logs in Loki
curl -G -s "http://localhost:3100/loki/api/v1/query" \
  --data-urlencode 'query={container_name="hello-test"}'

# 4. Verify in Grafana
# Open http://localhost:3000 and check logs
```

---

## 8. Cleanup

### Remove Docker Containers
```bash
# Stop and remove all containers
docker-compose down

# Remove individual containers
docker stop loki grafana promtail hello-devops-app
docker rm loki grafana promtail hello-devops-app

# Remove images
docker rmi devops-hello:latest
```

### Remove Volumes
```bash
# Remove all volumes
docker-compose down -v

# Or remove specific volumes
docker volume rm devops-intern-final_loki-data
docker volume rm devops-intern-final_grafana-data
```

### Stop Nomad
```bash
# Stop the job
nomad job stop -purge hello-app

# Stop Nomad agent (Ctrl+C in terminal)
```

---

## 9. Common Issues & Solutions

### Issue: Docker build fails
**Solution:**
```bash
# Check Docker is running
docker ps

# Clear Docker cache
docker system prune -a

# Rebuild with no cache
docker build --no-cache -t devops-hello:latest .
```

### Issue: Port already in use
**Solution:**
```bash
# Check what's using the port
netstat -ano | findstr :3100  # Windows
lsof -i :3100                 # Linux/macOS

# Stop conflicting service or use different port
docker run -d -p 3101:3100 grafana/loki:latest
```

### Issue: CI/CD pipeline fails
**Solution:**
- Check GitHub Actions logs
- Verify all files are committed
- Check Python version compatibility
- Ensure requirements.txt is correct

### Issue: Nomad job won't start
**Solution:**
```bash
# Check Nomad logs
nomad job status hello-app

# View allocation events
nomad alloc status <alloc-id>

# Verify Docker image exists
docker images | grep devops-hello
```

---

## 10. Success Criteria Checklist

- [ ] Python script runs and prints "Hello, DevOps!"
- [ ] Shell script executes and shows system info
- [ ] Docker image builds successfully
- [ ] Docker container runs and produces output
- [ ] CI/CD pipeline passes on GitHub
- [ ] Nomad job file validates correctly
- [ ] Loki starts and accepts logs
- [ ] Grafana connects to Loki
- [ ] All documentation is complete
- [ ] Repository is clean and organized

---

**Testing completed successfully! 🎉**

If all tests pass, your DevOps pipeline is working correctly and ready for submission.
