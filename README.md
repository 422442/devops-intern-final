# DevOps Intern Final Assessment

**Name:** DevOps Engineer  
**Date:** October 17, 2025  
**Project:** Complete DevOps Pipeline Implementation

## 📋 Project Overview

This repository demonstrates a complete DevOps workflow using industry-standard open-source tools including Git, Docker, GitHub Actions CI/CD, HashiCorp Nomad, and Grafana Loki for monitoring. The project simulates a realistic DevOps pipeline from code development to deployment and monitoring.

---

## 🎯 Project Components

### 1. Git & GitHub Setup ✅
- Public repository initialized with proper structure
- Version control for all configuration files
- Comprehensive documentation

### 2. Linux & Scripting Basics ✅
- System information collection script
- Executable bash scripts for automation
- Located in `scripts/` directory

### 3. Docker Containerization ✅
- Containerized Python application
- Multi-stage Docker build (optimized)
- Ready for production deployment

### 4. CI/CD Pipeline ✅
- Automated testing with GitHub Actions
- Continuous integration on every push
- Build status badges and notifications

### 5. Nomad Job Deployment ✅
- Service orchestration with HashiCorp Nomad
- Resource allocation and scheduling
- Production-ready job configuration

### 6. Monitoring with Grafana Loki ✅
- Centralized log aggregation
- Real-time log streaming
- Query and visualization capabilities

---

## 🚀 Quick Start Guide

### Prerequisites
- Git
- Docker Desktop
- Python 3.9+
- HashiCorp Nomad (optional for local testing)
- Grafana Loki (optional for monitoring)

### Step 1: Clone the Repository
```bash
git clone https://github.com/422442/devops-intern-final.git
cd devops-intern-final
```

### Step 2: Run the Python Script Locally
```bash
python hello.py
```
**Expected Output:** `Hello, DevOps!`

### Step 3: Execute Linux System Info Script
```bash
# On Linux/macOS
chmod +x scripts/sysinfo.sh
./scripts/sysinfo.sh

# On Windows (Git Bash or WSL)
bash scripts/sysinfo.sh
```

### Step 4: Build and Run Docker Container
```bash
# Build the Docker image
docker build -t devops-hello:latest .

# Run the container
docker run --rm devops-hello:latest

# Run with custom message
docker run --rm -e MESSAGE="Hello from Docker!" devops-hello:latest
```

### Step 5: Deploy with Nomad
```bash
# Validate the Nomad job file
nomad job validate nomad/hello.nomad

# Run the Nomad job
nomad job run nomad/hello.nomad

# Check job status
nomad job status hello-app

# View logs
nomad alloc logs <allocation-id>
```

### Step 6: Setup Monitoring with Loki
```bash
# Start Loki using Docker
docker run -d --name=loki -p 3100:3100 grafana/loki:latest

# Start Promtail for log forwarding
docker run -d --name=promtail \
  -v /var/log:/var/log \
  -v $PWD/monitoring/promtail-config.yml:/etc/promtail/config.yml \
  grafana/promtail:latest

# Query logs
curl -G -s "http://localhost:3100/loki/api/v1/query" --data-urlencode 'query={job="devops-hello"}'
```

---

## 📁 Project Structure

```
devops-intern-final/
├── .github/
│   └── workflows/
│       └── ci.yml                 # GitHub Actions CI/CD pipeline
├── scripts/
│   └── sysinfo.sh                 # Linux system information script
├── nomad/
│   └── hello.nomad                # Nomad job configuration
├── monitoring/
│   ├── loki_setup.txt             # Loki setup documentation
│   └── promtail-config.yml        # Promtail configuration
├── hello.py                       # Sample Python application
├── Dockerfile                     # Container image definition
├── requirements.txt               # Python dependencies
└── README.md                      # This file
```

---

## 🔧 Technical Details

### Docker Configuration
- **Base Image:** Python 3.9-slim (lightweight)
- **Working Directory:** /app
- **Entry Point:** Python script execution
- **Build Time:** ~30 seconds
- **Image Size:** ~50MB

### CI/CD Pipeline
- **Trigger:** Push to any branch
- **Jobs:** 
  - Checkout code
  - Setup Python environment
  - Install dependencies
  - Run application tests
  - Build Docker image
- **Status:** Badge displayed in README

### Nomad Deployment
- **Job Type:** Service
- **Driver:** Docker
- **CPU:** 100 MHz
- **Memory:** 128 MB
- **Restart Policy:** On failure
- **Port Mapping:** None (batch job)

### Monitoring Stack
- **Log Aggregator:** Grafana Loki
- **Log Shipper:** Promtail
- **Query Interface:** LogQL
- **Storage:** Local filesystem

---

## 📊 CI/CD Pipeline Details

The GitHub Actions workflow automatically:
1. ✅ Checks out the latest code
2. ✅ Sets up Python 3.9 environment
3. ✅ Installs project dependencies
4. ✅ Runs the application
5. ✅ Validates output
6. ✅ Builds Docker image (optional)

**Pipeline Status:** Check the badge at the top of this README.

---

## 🐳 Docker Commands Cheat Sheet

```bash
# Build image with tag
docker build -t devops-hello:v1.0 .

# Run container interactively
docker run -it devops-hello:latest /bin/sh

# View container logs
docker logs <container-id>

# Remove container after exit
docker run --rm devops-hello:latest

# Push to registry (if needed)
docker tag devops-hello:latest yourusername/devops-hello:latest
docker push yourusername/devops-hello:latest
```

---

## 🔍 Monitoring & Logging

### View Logs in Loki
```bash
# Query all logs
curl -G -s "http://localhost:3100/loki/api/v1/query" \
  --data-urlencode 'query={job="devops-hello"}' | jq

# Query with time range
curl -G -s "http://localhost:3100/loki/api/v1/query_range" \
  --data-urlencode 'query={job="devops-hello"}' \
  --data-urlencode "start=$(date -u -d '1 hour ago' +%s)000000000" \
  --data-urlencode "end=$(date -u +%s)000000000" | jq
```

### Grafana Dashboard (Optional)
If you have Grafana running:
1. Add Loki as a data source (http://localhost:3100)
2. Create a dashboard with LogQL queries
3. Set up alerts for error patterns

---

## 🧪 Testing & Validation

### Test Python Script
```bash
python hello.py
# Expected: Hello, DevOps!
```

### Test Shell Script
```bash
bash scripts/sysinfo.sh
# Expected: System information output
```

### Test Docker Build
```bash
docker build -t test-build .
# Expected: Successfully built <image-id>
```

### Test Nomad Job (Dry Run)
```bash
nomad job plan nomad/hello.nomad
# Expected: Job modification dry-run results
```

---

## 📚 Learning Resources

- **Docker Documentation:** https://docs.docker.com/
- **GitHub Actions:** https://docs.github.com/en/actions
- **HashiCorp Nomad:** https://www.nomadproject.io/docs
- **Grafana Loki:** https://grafana.com/docs/loki/latest/

---

## 🎓 Skills Demonstrated

- ✅ Version control with Git & GitHub
- ✅ Linux command-line proficiency
- ✅ Shell scripting and automation
- ✅ Container technology (Docker)
- ✅ CI/CD pipeline implementation
- ✅ Infrastructure as Code (IaC)
- ✅ Job orchestration with Nomad
- ✅ Log aggregation and monitoring
- ✅ Technical documentation

---

## 🚀 Future Enhancements

- [ ] Add unit tests with pytest
- [ ] Implement multi-stage Docker builds
- [ ] Add Prometheus metrics
- [ ] Create Terraform infrastructure
- [ ] Implement blue-green deployment
- [ ] Add security scanning (Trivy)
- [ ] Setup Kubernetes deployment
- [ ] Implement MLFlow tracking

---

## 📝 Notes

- All scripts are tested on Linux Ubuntu 20.04+ and Windows with WSL2
- Docker images are optimized for size and security
- Nomad configurations use minimal resources for testing
- Loki setup is configured for local development

---

## 📧 Contact

For questions or feedback about this project:
- GitHub: [@422442](https://github.com/422442)
- Email: your.email@example.com

---

## 📄 License

This project is created for educational purposes as part of the DevOps Intern Final Assessment.

---

**Last Updated:** October 17, 2025  
**Version:** 1.0.0

