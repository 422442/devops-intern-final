#!/bin/bash

################################################################################
# DevOps Project Quick Setup Script
# This script helps set up the development environment
################################################################################

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main setup
main() {
    print_header "DevOps Project Setup"
    echo ""

    # Check Python
    print_info "Checking Python installation..."
    if command_exists python3 || command_exists python; then
        PYTHON_CMD=$(command_exists python3 && echo "python3" || echo "python")
        PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | cut -d' ' -f2)
        print_success "Python $PYTHON_VERSION found"
    else
        print_error "Python not found. Please install Python 3.9+"
        exit 1
    fi

    # Check Docker
    print_info "Checking Docker installation..."
    if command_exists docker; then
        DOCKER_VERSION=$(docker --version | cut -d' ' -f3 | tr -d ',')
        print_success "Docker $DOCKER_VERSION found"
        
        # Check if Docker is running
        if docker ps >/dev/null 2>&1; then
            print_success "Docker daemon is running"
        else
            print_error "Docker daemon is not running. Please start Docker."
        fi
    else
        print_error "Docker not found. Please install Docker Desktop"
    fi

    # Check Git
    print_info "Checking Git installation..."
    if command_exists git; then
        GIT_VERSION=$(git --version | cut -d' ' -f3)
        print_success "Git $GIT_VERSION found"
    else
        print_error "Git not found. Please install Git"
        exit 1
    fi

    echo ""
    print_header "Setting Up Project"
    echo ""

    # Make scripts executable
    print_info "Making scripts executable..."
    if [ -f "scripts/sysinfo.sh" ]; then
        chmod +x scripts/sysinfo.sh
        print_success "sysinfo.sh is now executable"
    fi

    # Test Python script
    print_info "Testing Python application..."
    if $PYTHON_CMD hello.py >/dev/null 2>&1; then
        print_success "Python script works correctly"
    else
        print_error "Python script failed to run"
    fi

    # Build Docker image
    echo ""
    print_info "Would you like to build the Docker image? (y/n)"
    read -r BUILD_DOCKER
    if [ "$BUILD_DOCKER" = "y" ] || [ "$BUILD_DOCKER" = "Y" ]; then
        print_info "Building Docker image..."
        if docker build -t devops-hello:latest . >/dev/null 2>&1; then
            print_success "Docker image built successfully"
        else
            print_error "Docker build failed"
        fi
    fi

    # Initialize Git repository
    echo ""
    if [ ! -d ".git" ]; then
        print_info "Would you like to initialize Git repository? (y/n)"
        read -r INIT_GIT
        if [ "$INIT_GIT" = "y" ] || [ "$INIT_GIT" = "Y" ]; then
            git init
            print_success "Git repository initialized"
            
            print_info "Add files and commit? (y/n)"
            read -r COMMIT_FILES
            if [ "$COMMIT_FILES" = "y" ] || [ "$COMMIT_FILES" = "Y" ]; then
                git add .
                git commit -m "Initial commit - DevOps pipeline complete"
                print_success "Files committed to Git"
            fi
        fi
    else
        print_info "Git repository already initialized"
    fi

    # Summary
    echo ""
    print_header "Setup Complete!"
    echo ""
    print_success "Your DevOps project is ready!"
    echo ""
    echo "Next steps:"
    echo "  1. Review the README.md for detailed instructions"
    echo "  2. Test components using TESTING.md guide"
    echo "  3. Create a GitHub repository and push your code"
    echo "  4. Update README.md with your GitHub username"
    echo ""
    echo "Quick commands:"
    echo "  • Run Python:     $PYTHON_CMD hello.py"
    echo "  • Run script:     bash scripts/sysinfo.sh"
    echo "  • Build Docker:   docker build -t devops-hello:latest ."
    echo "  • Run Docker:     docker run --rm devops-hello:latest"
    echo "  • Start stack:    docker-compose up -d"
    echo ""
    print_success "Good luck with your assessment! 🚀"
}

# Run main function
main
