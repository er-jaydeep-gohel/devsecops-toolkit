#!/bin/bash
################################################################################
# DevSecOps Toolkit - Build Script
################################################################################
# Purpose: Build, scan, and optimize the DevSecOps toolkit container
# Usage: ./build.sh [options]
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
IMAGE_NAME="${IMAGE_NAME:-devsecops-toolkit}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
DOCKERFILE="${DOCKERFILE:-Dockerfile}"
BUILD_CONTEXT="${BUILD_CONTEXT:-.}"
REGISTRY="${REGISTRY:-}"
SCAN_ENABLED="${SCAN_ENABLED:-true}"
PUSH_ENABLED="${PUSH_ENABLED:-false}"

# Functions
print_header() {
    echo -e "${BLUE}=================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}=================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

check_dependencies() {
    print_header "Checking Dependencies"
    
    local missing_deps=()
    
    # Required dependencies
    if ! command -v docker &> /dev/null; then
        missing_deps+=("docker")
    fi
    
    # Optional but recommended
    if ! command -v trivy &> /dev/null; then
        print_warning "trivy not found - security scanning will be limited"
    fi
    
    if ! command -v dive &> /dev/null; then
        print_warning "dive not found - image analysis will be skipped"
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        exit 1
    fi
    
    print_success "All required dependencies found"
}

build_image() {
    print_header "Building Docker Image"
    
    local full_image="${IMAGE_NAME}:${IMAGE_TAG}"
    
    if [ -n "$REGISTRY" ]; then
        full_image="${REGISTRY}/${full_image}"
    fi
    
    print_info "Image: ${full_image}"
    print_info "Dockerfile: ${DOCKERFILE}"
    print_info "Context: ${BUILD_CONTEXT}"
    
    # Build arguments
    local build_args=""
    
    # Add build timestamp
    build_args+=" --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
    build_args+=" --build-arg VCS_REF=$(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')"
    
    # Build command
    local build_cmd="docker build ${build_args} -t ${full_image} -f ${DOCKERFILE} ${BUILD_CONTEXT}"
    
    print_info "Build command: ${build_cmd}"
    echo ""
    
    if eval "${build_cmd}"; then
        print_success "Image built successfully: ${full_image}"
        return 0
    else
        print_error "Build failed"
        return 1
    fi
}

scan_image() {
    if [ "$SCAN_ENABLED" != "true" ]; then
        print_warning "Security scanning disabled"
        return 0
    fi
    
    print_header "Security Scanning"
    
    local full_image="${IMAGE_NAME}:${IMAGE_TAG}"
    if [ -n "$REGISTRY" ]; then
        full_image="${REGISTRY}/${full_image}"
    fi
    
    # Trivy scan
    if command -v trivy &> /dev/null; then
        print_info "Running Trivy scan..."
        
        if trivy image --severity HIGH,CRITICAL --no-progress "${full_image}"; then
            print_success "Trivy scan completed - No critical vulnerabilities found"
        else
            print_warning "Trivy scan found vulnerabilities"
        fi
        echo ""
    fi
    
    # Docker Scout scan
    if command -v docker &> /dev/null && docker scout version &> /dev/null; then
        print_info "Running Docker Scout scan..."
        
        if docker scout cves "${full_image}"; then
            print_success "Docker Scout scan completed"
        else
            print_warning "Docker Scout scan found issues"
        fi
        echo ""
    fi
    
    # Generate SBOM
    if command -v syft &> /dev/null; then
        print_info "Generating SBOM..."
        local sbom_file="sbom-${IMAGE_TAG}.json"
        
        if syft "${full_image}" -o cyclonedx-json > "${sbom_file}"; then
            print_success "SBOM generated: ${sbom_file}"
        else
            print_warning "SBOM generation failed"
        fi
        echo ""
    fi
}

analyze_image() {
    print_header "Image Analysis"
    
    local full_image="${IMAGE_NAME}:${IMAGE_TAG}"
    if [ -n "$REGISTRY" ]; then
        full_image="${REGISTRY}/${full_image}"
    fi
    
    # Image size
    print_info "Image Details:"
    docker images "${full_image}" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
    echo ""
    
    # Layer analysis with dive
    if command -v dive &> /dev/null; then
        print_info "Running dive analysis..."
        print_warning "This may take a moment..."
        
        # Run dive in CI mode for non-interactive analysis
        CI=true dive "${full_image}" || true
        echo ""
    fi
    
    # Image history
    print_info "Image History (top 10 layers by size):"
    docker history "${full_image}" --no-trunc --format "table {{.Size}}\t{{.CreatedBy}}" | head -n 11
    echo ""
}

test_image() {
    print_header "Testing Image"
    
    local full_image="${IMAGE_NAME}:${IMAGE_TAG}"
    if [ -n "$REGISTRY" ]; then
        full_image="${REGISTRY}/${full_image}"
    fi
    
    print_info "Running basic tests..."
    
    # Test 1: Container starts
    if docker run --rm "${full_image}" bash -c 'echo "Container test successful"' &> /dev/null; then
        print_success "Test 1: Container starts successfully"
    else
        print_error "Test 1: Container failed to start"
        return 1
    fi
    
    # Test 2: Essential tools available
    local tools=("kubectl" "helm" "terraform" "aws" "gcloud" "az" "docker" "k9s")
    local missing_tools=()
    
    for tool in "${tools[@]}"; do
        if ! docker run --rm "${full_image}" bash -c "command -v ${tool}" &> /dev/null; then
            missing_tools+=("${tool}")
        fi
    done
    
    if [ ${#missing_tools[@]} -eq 0 ]; then
        print_success "Test 2: All essential tools found"
    else
        print_error "Test 2: Missing tools: ${missing_tools[*]}"
        return 1
    fi
    
    # Test 3: Tool versions
    print_info "Test 3: Checking tool versions..."
    docker run --rm "${full_image}" bash -c '
        echo "kubectl: $(kubectl version --client --short 2>/dev/null || echo "N/A")"
        echo "helm: $(helm version --short 2>/dev/null || echo "N/A")"
        echo "terraform: $(terraform version -json 2>/dev/null | jq -r ".terraform_version" || echo "N/A")"
    '
    print_success "Test 3: Version check completed"
    
    echo ""
}

push_image() {
    if [ "$PUSH_ENABLED" != "true" ]; then
        print_warning "Image push disabled"
        return 0
    fi
    
    if [ -z "$REGISTRY" ]; then
        print_error "REGISTRY not set - cannot push image"
        return 1
    fi
    
    print_header "Pushing Image"
    
    local full_image="${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
    
    print_info "Pushing to: ${full_image}"
    
    if docker push "${full_image}"; then
        print_success "Image pushed successfully"
        
        # Also tag and push as latest if not already
        if [ "${IMAGE_TAG}" != "latest" ]; then
            local latest_image="${REGISTRY}/${IMAGE_NAME}:latest"
            docker tag "${full_image}" "${latest_image}"
            
            if docker push "${latest_image}"; then
                print_success "Latest tag pushed successfully"
            fi
        fi
    else
        print_error "Image push failed"
        return 1
    fi
}

generate_report() {
    print_header "Build Report"
    
    local full_image="${IMAGE_NAME}:${IMAGE_TAG}"
    if [ -n "$REGISTRY" ]; then
        full_image="${REGISTRY}/${full_image}"
    fi
    
    local report_file="build-report-${IMAGE_TAG}.txt"
    
    {
        echo "================================="
        echo "DevSecOps Toolkit Build Report"
        echo "================================="
        echo ""
        echo "Build Information:"
        echo "  Image: ${full_image}"
        echo "  Build Date: $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
        echo "  Git Commit: $(git rev-parse HEAD 2>/dev/null || echo 'unknown')"
        echo ""
        echo "Image Details:"
        docker images "${full_image}" --format "  Repository: {{.Repository}}\n  Tag: {{.Tag}}\n  Size: {{.Size}}\n  Created: {{.CreatedAt}}"
        echo ""
        echo "Installed Tools (sample):"
        docker run --rm "${full_image}" bash -c '
            echo "  kubectl: $(kubectl version --client --short 2>/dev/null || echo N/A)"
            echo "  helm: $(helm version --short 2>/dev/null || echo N/A)"
            echo "  terraform: $(terraform version 2>/dev/null | head -1 || echo N/A)"
            echo "  trivy: $(trivy --version 2>/dev/null | head -1 || echo N/A)"
        '
        echo ""
        echo "================================="
    } > "${report_file}"
    
    cat "${report_file}"
    print_success "Report saved to: ${report_file}"
}

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Build the DevSecOps toolkit container image with security scanning and testing.

OPTIONS:
    -h, --help              Show this help message
    -n, --name NAME         Image name (default: devsecops-toolkit)
    -t, --tag TAG           Image tag (default: latest)
    -f, --file DOCKERFILE   Dockerfile path (default: Dockerfile)
    -r, --registry REGISTRY Registry URL for pushing
    -p, --push              Push image to registry
    -s, --skip-scan         Skip security scanning
    --skip-test             Skip image testing
    --skip-analysis         Skip image analysis

EXAMPLES:
    # Basic build
    $0

    # Build with custom tag
    $0 --tag v1.0.0

    # Build and push to registry
    $0 --tag v1.0.0 --registry docker.io/myorg --push

    # Quick build without scanning
    $0 --skip-scan --skip-test --skip-analysis

ENVIRONMENT VARIABLES:
    IMAGE_NAME              Image name
    IMAGE_TAG               Image tag
    REGISTRY                Registry URL
    SCAN_ENABLED            Enable security scanning (true/false)
    PUSH_ENABLED            Enable image push (true/false)

EOF
}

main() {
    local skip_test=false
    local skip_analysis=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -n|--name)
                IMAGE_NAME="$2"
                shift 2
                ;;
            -t|--tag)
                IMAGE_TAG="$2"
                shift 2
                ;;
            -f|--file)
                DOCKERFILE="$2"
                shift 2
                ;;
            -r|--registry)
                REGISTRY="$2"
                shift 2
                ;;
            -p|--push)
                PUSH_ENABLED=true
                shift
                ;;
            -s|--skip-scan)
                SCAN_ENABLED=false
                shift
                ;;
            --skip-test)
                skip_test=true
                shift
                ;;
            --skip-analysis)
                skip_analysis=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Print configuration
    print_header "Build Configuration"
    echo "Image Name: ${IMAGE_NAME}"
    echo "Image Tag: ${IMAGE_TAG}"
    echo "Dockerfile: ${DOCKERFILE}"
    echo "Registry: ${REGISTRY:-none}"
    echo "Scan Enabled: ${SCAN_ENABLED}"
    echo "Push Enabled: ${PUSH_ENABLED}"
    echo ""
    
    # Execute build pipeline
    check_dependencies
    
    if ! build_image; then
        print_error "Build failed!"
        exit 1
    fi
    
    if [ "$skip_test" != "true" ]; then
        test_image
    fi
    
    scan_image
    
    if [ "$skip_analysis" != "true" ]; then
        analyze_image
    fi
    
    push_image
    
    generate_report
    
    print_header "Build Complete"
    print_success "Successfully built ${IMAGE_NAME}:${IMAGE_TAG}"
    
    # Show next steps
    echo ""
    print_info "Next Steps:"
    echo "  1. Run container: docker run -it --rm ${IMAGE_NAME}:${IMAGE_TAG} bash"
    echo "  2. View report: cat build-report-${IMAGE_TAG}.txt"
    if [ "$SCAN_ENABLED" = "true" ] && command -v syft &> /dev/null; then
        echo "  3. View SBOM: cat sbom-${IMAGE_TAG}.json"
    fi
}

# Run main function
main "$@"
