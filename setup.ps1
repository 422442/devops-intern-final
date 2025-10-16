# DevOps Intern Final Assessment - Quick Setup Script for Windows
# Run this in PowerShell

Write-Host "========================================" -ForegroundColor Blue
Write-Host "DevOps Project Setup (Windows)" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

# Check Python
Write-Host "Checking Python installation..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✅ $pythonVersion found" -ForegroundColor Green
} catch {
    Write-Host "❌ Python not found. Please install Python 3.9+" -ForegroundColor Red
    exit 1
}

# Check Docker
Write-Host "Checking Docker installation..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "✅ $dockerVersion found" -ForegroundColor Green
    
    # Check if Docker is running
    docker ps > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker daemon is running" -ForegroundColor Green
    } else {
        Write-Host "❌ Docker daemon is not running. Please start Docker Desktop." -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Docker not found. Please install Docker Desktop" -ForegroundColor Red
}

# Check Git
Write-Host "Checking Git installation..." -ForegroundColor Yellow
try {
    $gitVersion = git --version
    Write-Host "✅ $gitVersion found" -ForegroundColor Green
} catch {
    Write-Host "❌ Git not found. Please install Git" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "Setting Up Project" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""

# Test Python script
Write-Host "Testing Python application..." -ForegroundColor Yellow
try {
    python hello.py > $null 2>&1
    Write-Host "✅ Python script works correctly" -ForegroundColor Green
} catch {
    Write-Host "❌ Python script failed to run" -ForegroundColor Red
}

# Build Docker image
Write-Host ""
$buildDocker = Read-Host "Would you like to build the Docker image? (y/n)"
if ($buildDocker -eq "y" -or $buildDocker -eq "Y") {
    Write-Host "Building Docker image..." -ForegroundColor Yellow
    docker build -t devops-hello:latest .
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker image built successfully" -ForegroundColor Green
    } else {
        Write-Host "❌ Docker build failed" -ForegroundColor Red
    }
}

# Initialize Git repository
Write-Host ""
if (-not (Test-Path ".git")) {
    $initGit = Read-Host "Would you like to initialize Git repository? (y/n)"
    if ($initGit -eq "y" -or $initGit -eq "Y") {
        git init
        Write-Host "✅ Git repository initialized" -ForegroundColor Green
        
        $commitFiles = Read-Host "Add files and commit? (y/n)"
        if ($commitFiles -eq "y" -or $commitFiles -eq "Y") {
            git add .
            git commit -m "Initial commit - DevOps pipeline complete"
            Write-Host "✅ Files committed to Git" -ForegroundColor Green
        }
    }
} else {
    Write-Host "ℹ️  Git repository already initialized" -ForegroundColor Yellow
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Blue
Write-Host "Setup Complete!" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""
Write-Host "✅ Your DevOps project is ready!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Review the README.md for detailed instructions"
Write-Host "  2. Test components using TESTING.md guide"
Write-Host "  3. Create a GitHub repository and push your code"
Write-Host "  4. Update README.md with your GitHub username"
Write-Host ""
Write-Host "Quick commands:"
Write-Host "  • Run Python:     python hello.py"
Write-Host "  • Run script:     bash scripts/sysinfo.sh"
Write-Host "  • Build Docker:   docker build -t devops-hello:latest ."
Write-Host "  • Run Docker:     docker run --rm devops-hello:latest"
Write-Host "  • Start stack:    docker-compose up -d"
Write-Host ""
Write-Host "✅ Good luck with your assessment! 🚀" -ForegroundColor Green
