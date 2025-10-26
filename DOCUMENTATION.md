# DevSecOps Multi-Tool Container - Complete Documentation

## 📋 Table of Contents
1. [Overview](#-overview)
2. [What's New](#-whats-new---major-enhancements)
3. [Tool Categories](#️-tool-categories--quick-reference)
4. [Usage Examples](#-usage-examples)
5. [Best Practices](#-best-practices)
6. [Build & Deployment](#️-build--deployment)
7. [Troubleshooting](#-troubleshooting)

---

## 🎯 Overview

This is a comprehensive DevSecOps toolkit packaged as a single Alpine-based Docker container. It contains **100+ tools** for cloud-native development, security scanning, infrastructure management, and operational tasks.

**Base Image:** Alpine Linux 3.20 (lightweight and secure)
**Image Size:** ~2-3GB (optimized for functionality)
**Architecture:** x86_64/amd64

---

## 🆕 What's New - Major Enhancements

### **Organizational Improvements**
| Enhancement | Description | Benefits |
|------------|-------------|----------|
| **Logical Grouping** | 21 distinct stages with clear separation | Easy to find and maintain tools |
| **Comprehensive Comments** | Every stage has detailed documentation | Better understanding and onboarding |
| **Version Pinning** | Dynamic latest version fetching | Always up-to-date tools |
| **Clean Layer Structure** | Optimized RUN commands | Smaller image layers |

### **New Tools Added (50+ Additional Tools)**

#### **IaC & Configuration Management**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **OpenTofu** | Open-source Terraform alternative | Terraform alternative after license change |
| **Terragrunt** | Terraform wrapper for DRY configs | Manage multiple environments efficiently |
| **tflint** | Terraform linter | Catch errors before apply |
| **terraform-docs** | Generate TF documentation | Auto-document modules |
| **Pulumi** | Modern IaC with real programming languages | Python/TypeScript/Go for infrastructure |

#### **Service Mesh & Networking**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **Linkerd** | Lightweight service mesh | Lower resource consumption than Istio |
| **Cilium CLI** | eBPF-based networking | Advanced network policies |
| **Calicoctl** | Calico network policies | Fine-grained network control |

#### **CI/CD & GitOps**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **Flux CLI** | GitOps toolkit | Alternative to ArgoCD |
| **Tekton (tkn)** | Cloud-native CI/CD | Kubernetes-native pipelines |
| **GitHub CLI (gh)** | GitHub operations from CLI | Automate GitHub workflows |
| **GitLab CLI (glab)** | GitLab operations from CLI | Automate GitLab operations |

#### **Security & Compliance**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **Kube-bench** | CIS Kubernetes benchmarks | Compliance scanning |
| **Checkov** | IaC security scanner | Policy as code for IaC |
| **tfsec** | Terraform security scanner | Find security issues in TF code |
| **Grype** | Vulnerability scanner | Advanced CVE detection |
| **Snyk CLI** | Developer security platform | Comprehensive security scanning |
| **Falco** | Runtime security | Detect anomalous behavior |

#### **Secret Management**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **SOPS** | Secrets encryption | Encrypt secrets in Git |
| **age** | Modern encryption | Simple file encryption |
| **Vault CLI** | HashiCorp Vault client | Enterprise secret management |
| **Kubeseal** | Sealed Secrets for K8s | Encrypted secrets in Git |

#### **Observability & Monitoring**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **Promtool** | Prometheus CLI | Validate Prometheus configs |
| **k6** | Load testing | Modern load testing |
| **OpenTelemetry CLI** | Distributed tracing | Collect telemetry data |

#### **Policy & Governance**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **OPA (Open Policy Agent)** | Policy engine | Enforce policies across stack |
| **Conftest** | Policy testing | Test configs against policies |
| **Gatekeeper CLI** | K8s policy management | Admission controller policies |
| **Kyverno CLI** | Kubernetes policy engine | Native K8s policy management |

#### **Cost Optimization**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **Kubecost CLI** | K8s cost analysis | Track cluster costs |
| **Infracost** | Cloud cost estimates | Estimate IaC changes cost |

#### **Backup & DR**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **Velero** | K8s backup & restore | Disaster recovery for K8s |
| **Restic** | Backup program | Secure backups |

#### **Developer Experience**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **lazygit** | Terminal UI for Git | Visual Git operations |
| **lazydocker** | Terminal UI for Docker | Visual Docker management |
| **dive** | Docker image analyzer | Optimize image layers |
| **bat** | Better cat with syntax | Pretty file viewing |
| **fd** | Better find | Faster file searching |
| **fzf** | Fuzzy finder | Interactive filtering |
| **HTTPie** | Modern HTTP client | Better than curl for testing |

#### **Performance & Benchmarking**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **vegeta** | HTTP load testing | High-performance load tests |
| **hey** | HTTP load generator | Simple load testing |
| **wrk** | HTTP benchmarking | Fast HTTP benchmarking |

#### **Database Tools**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **MySQL/MariaDB Client** | Database operations | Connect to MySQL databases |
| **MongoDB Tools** | MongoDB operations | Backup/restore MongoDB |
| **Redis CLI** | Redis operations | Interact with Redis |

#### **Kubernetes Development**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **kubepug** | Deprecated API scanner | Find deprecated APIs |
| **pluto** | K8s version checker | API deprecation detection |
| **kubent** | K8s trouble detector | Find compatibility issues |
| **krew** | kubectl plugin manager | Manage kubectl plugins |
| **Kubebuilder** | K8s API builder | Build custom operators |
| **Skaffold** | K8s CI/CD | Fast local development |
| **Tilt** | Local K8s development | Live update deployments |
| **Telepresence** | Remote K8s development | Debug against live cluster |
| **Kustomize** | K8s config management | Declarative config customization |

#### **Data Templating**
| Tool | Purpose | Why It's Essential |
|------|---------|-------------------|
| **Jsonnet** | Data templating | Generate configs programmatically |
| **hadolint** | Dockerfile linter | Best practices for Dockerfiles |
| **yamllint** | YAML linter | Validate YAML syntax |

---

## 📊 Complete Tool Comparison

### **Before vs After Enhancement**

| Category | Original Tools | Added Tools | Total | Improvement |
|----------|---------------|-------------|-------|-------------|
| **Cloud CLIs** | 3 (AWS, GCP, Azure) | 0 | 3 | Enhanced installation |
| **Container Tools** | 4 | 4 (lazydocker, dive, Scout, etc.) | 8 | +100% |
| **Kubernetes Core** | 5 | 10 (krew, kustomize, etc.) | 15 | +200% |
| **Kubectl Plugins** | 10 | 5 | 15 | +50% |
| **IaC Tools** | 3 (Terraform, Ansible) | 7 (OpenTofu, Terragrunt, etc.) | 10 | +333% |
| **Security Scanners** | 8 | 10 (Checkov, Snyk, Falco, etc.) | 18 | +225% |
| **Service Mesh** | 1 (Istio) | 3 (Linkerd, Cilium, Calico) | 4 | +300% |
| **GitOps/CI/CD** | 1 (ArgoCD) | 5 (Flux, Tekton, gh, glab) | 6 | +500% |
| **Secret Management** | 0 | 4 (SOPS, age, Vault, Kubeseal) | 4 | New Category |
| **Observability** | 0 | 3 (Promtool, k6, OTEL) | 3 | New Category |
| **Policy/Compliance** | 0 | 4 (OPA, Conftest, Gatekeeper, Kyverno) | 4 | New Category |
| **Cost Optimization** | 0 | 2 (Kubecost, Infracost) | 2 | New Category |
| **Backup/DR** | 0 | 2 (Velero, Restic) | 2 | New Category |
| **Developer Tools** | 3 | 8 (lazygit, bat, fd, fzf, etc.) | 11 | +367% |
| **Performance** | 0 | 3 (vegeta, hey, wrk) | 3 | New Category |
| **Database Clients** | 1 (PostgreSQL) | 3 (MySQL, MongoDB, Redis) | 4 | +300% |
| **Linters/Validators** | 2 | 3 (hadolint, yamllint, etc.) | 5 | +150% |
| **Total Tools** | **~50** | **~80** | **~130+** | **+160%** |

---

## 🗂️ Tool Categories & Quick Reference

### **1. Cloud Provider CLIs**
```bash
# AWS Operations
aws s3 ls
aws eks list-clusters
aws-iam-authenticator token -i <cluster-name>

# Google Cloud
gcloud compute instances list
gcloud container clusters get-credentials <cluster>

# Azure
az account list
az aks get-credentials --resource-group <rg> --name <cluster>
```

### **2. Container Operations**
```bash
# Docker
docker ps
docker-compose up -d

# Docker Analysis
dive <image>                    # Analyze image layers
docker scout cves <image>       # Security scanning
lazydocker                      # TUI for Docker

# Container Security
trivy image <image>
grype <image>
syft <image> -o cyclonedx      # Generate SBOM
```

### **3. Kubernetes Management**
```bash
# Context & Namespace
kubectx                         # List/switch contexts
kubens                          # List/switch namespaces
kubectl config get-contexts

# Cluster Operations
kubectl get nodes
kubectl top nodes
kube-capacity                   # Resource capacity

# Debugging
k9s                             # TUI for K8s
stern <pod-pattern>             # Multi-pod logs
kubectl-sniff <pod>             # Packet capture
```

### **4. Kubernetes Security & Compliance**
```bash
# Security Scanning
kubescape scan                  # CNCF security scan
kube-bench                      # CIS benchmarks
kube-hunter                     # Penetration testing
popeye                          # Cluster sanitizer

# Policy Enforcement
opa eval <policy>
conftest test <manifest>
kyverno apply <policy>
```

### **5. Infrastructure as Code**
```bash
# Terraform
terraform init
terraform plan
terraform apply
tflint                          # Lint TF code
terraform-docs markdown .       # Generate docs

# OpenTofu (Terraform alternative)
tofu init
tofu plan

# Terragrunt
terragrunt run-all plan

# Security Scanning
terrascan scan
tfsec .
checkov -d .

# Cost Estimation
infracost breakdown --path .
```

### **6. Service Mesh**
```bash
# Istio
istioctl analyze
istioctl dashboard grafana

# Linkerd
linkerd check
linkerd dashboard

# Cilium
cilium status
cilium connectivity test

# Calico
calicoctl get networkpolicies
```

### **7. GitOps & CI/CD**
```bash
# ArgoCD
argocd app list
argocd app sync <app>

# Flux
flux get kustomizations
flux reconcile source git <repo>

# Tekton
tkn pipeline list
tkn pipelinerun logs <run>

# GitHub
gh pr list
gh issue create

# GitLab
glab mr list
glab pipeline status
```

### **8. Secret Management**
```bash
# SOPS
sops -e secrets.yaml > secrets.enc.yaml
sops -d secrets.enc.yaml

# age
age-keygen -o key.txt
age -r <public-key> -o encrypted.txt file.txt

# Vault
vault login
vault kv get secret/data

# Sealed Secrets
kubeseal < secret.yaml > sealed-secret.yaml
```

### **9. Observability & Monitoring**
```bash
# Prometheus
promtool check config prometheus.yml
promtool query instant <url> '<query>'

# Load Testing
k6 run script.js
vegeta attack -duration=30s -rate=100 | vegeta report
hey -n 1000 -c 10 https://example.com

# Distributed Tracing
otelcol-contrib --config config.yaml
```

### **10. Cost Optimization**
```bash
# Kubernetes Costs
kubectl cost                    # Cluster cost breakdown
kubectl cost namespace <ns>     # Namespace costs

# Infrastructure Costs
infracost breakdown --path .
infracost diff --path .
```

### **11. Backup & Disaster Recovery**
```bash
# Velero (Kubernetes)
velero backup create <name>
velero restore create --from-backup <name>

# Restic
restic -r /backup init
restic -r /backup backup /data
restic -r /backup restore latest
```

### **12. Developer Productivity**
```bash
# Git Operations
lazygit                         # TUI for Git
gh repo clone <repo>            # Clone with GitHub CLI

# File Operations
bat <file>                      # Cat with syntax highlighting
fd <pattern>                    # Fast find
fzf                            # Fuzzy finder

# HTTP Testing
http GET https://api.example.com
https POST https://api.example.com key=value
```

### **13. Kubernetes Development**
```bash
# Local Development
kind create cluster
skaffold dev                    # Live development
tilt up                         # Live updates

# Remote Development
telepresence connect
telepresence intercept <service>

# Custom Resources
kubebuilder create api --group apps --version v1 --kind MyApp

# Configuration Management
kustomize build .
kubectl apply -k .

# Plugin Management
kubectl krew install <plugin>
```

### **14. API Deprecation Detection**
```bash
# Find deprecated APIs
kubepug                         # Scan cluster
pluto detect-files -d .         # Scan manifests
kubent                          # Kube no trouble
```

### **15. Linting & Validation**
```bash
# Code Quality
shellcheck script.sh            # Shell scripts
hadolint Dockerfile             # Dockerfile
yamllint config.yaml            # YAML files
```

---

## 🚀 Usage Examples

### **Scenario 1: Complete Security Audit**
```bash
# Cluster Security Scan
kubescape scan framework nsa
kube-bench run --targets master,node
kube-hunter --remote

# Container Image Security
trivy image myapp:latest
grype myapp:latest
docker scout cves myapp:latest

# Generate SBOM
syft myapp:latest -o cyclonedx > sbom.json

# IaC Security
terrascan scan -t terraform
tfsec .
checkov -d .
```

### **Scenario 2: Multi-Cloud Infrastructure Deployment**
```bash
# AWS EKS
aws eks list-clusters
aws eks update-kubeconfig --name <cluster>

# Terraform with Cost Estimation
infracost breakdown --path .
terraform plan
terraform apply

# Policy Validation
conftest test *.tf
tflint

# Deploy Application
kubectl apply -k overlays/production
argocd app sync myapp
```

### **Scenario 3: Incident Response & Debugging**
```bash
# Quick Cluster Overview
k9s

# Resource Analysis
kubectl top nodes
kubectl top pods -A
kube-capacity

# Log Aggregation
stern <app-name>
kubetail <pod-pattern>

# Network Debugging
kubectl-sniff <pod>
cilium connectivity test

# Performance Testing
vegeta attack -targets=targets.txt -rate=50 -duration=30s | vegeta report
```

### **Scenario 4: GitOps Workflow**
```bash
# Setup GitOps
flux bootstrap github \
  --owner=<org> \
  --repository=<repo> \
  --path=clusters/production

# Application Deployment
git clone <repo>
kustomize build overlays/prod > manifest.yaml
git add . && git commit -m "Deploy v1.2.3"
git push

# Monitor Deployment
flux get kustomizations --watch
argocd app get myapp --refresh

# Rollback if needed
flux suspend kustomization myapp
kubectl rollout undo deployment/myapp
```

### **Scenario 5: Local Kubernetes Development**
```bash
# Create local cluster
kind create cluster --config kind-config.yaml

# Start development loop
skaffold dev
# OR
tilt up

# Hot reload testing
# Make code changes and watch auto-deploy

# Debug remote services locally
telepresence connect
telepresence intercept myservice --port 8080:80

# Cleanup
kind delete cluster
```

---

## ⚡ Best Practices

### **Security Best Practices**

| Practice | Implementation | Tool |
|----------|---------------|------|
| **Scan all images** | Integrate into CI/CD | Trivy, Grype, Docker Scout |
| **SBOM generation** | Generate for all artifacts | Syft |
| **Secret scanning** | Pre-commit hooks | SOPS, age |
| **Policy enforcement** | Admission controllers | OPA, Kyverno, Gatekeeper |
| **Runtime security** | Deploy agents | Falco |
| **Regular audits** | Weekly scans | Kubescape, kube-bench |
| **Least privilege** | RBAC + PSPs | kubectl, OPA |

### **Cost Optimization**

| Practice | Implementation | Tool |
|----------|---------------|------|
| **Resource quotas** | Namespace limits | kubectl |
| **Right-sizing** | Monitor actual usage | kube-capacity, kubecost |
| **Spot instances** | For non-critical workloads | Cloud CLIs |
| **Auto-scaling** | HPA + VPA | kubectl |
| **Cost tracking** | Tag all resources | kubecost, infracost |
| **IaC cost review** | Pre-deployment checks | infracost |

### **Operational Excellence**

| Practice | Implementation | Tool |
|----------|---------------|------|
| **GitOps** | Git as source of truth | Flux, ArgoCD |
| **IaC everything** | No manual changes | Terraform, Pulumi |
| **Automated backups** | Daily backups | Velero, Restic |
| **Monitoring** | Comprehensive observability | Prometheus, Grafana |
| **Documentation** | Auto-generate | terraform-docs |
| **Testing** | Load & performance tests | k6, vegeta |

### **Development Workflow**

| Practice | Implementation | Tool |
|----------|---------------|------|
| **Local development** | Mimic production | kind, skaffold, tilt |
| **Fast feedback** | Live reload | skaffold, tilt |
| **Code quality** | Linting & validation | shellcheck, hadolint, yamllint |
| **Version control** | Everything in Git | git, gh, glab |
| **Collaboration** | PR workflows | GitHub CLI, GitLab CLI |

---

## 🏗️ Build & Deployment

### **Building the Image**

```bash
# Standard build
docker build -t devsecops-toolkit:latest .

# Multi-platform build
docker buildx build --platform linux/amd64,linux/arm64 -t devsecops-toolkit:latest .

# With build arguments
docker build \
  --build-arg TERRAFORM_VERSION=1.6.0 \
  -t devsecops-toolkit:latest .

# Scan after build
docker scout cves devsecops-toolkit:latest
trivy image devsecops-toolkit:latest
```

### **Running the Container**

```bash
# Interactive shell
docker run -it --rm \
  -v ~/.kube:/root/.kube \
  -v ~/.aws:/root/.aws \
  -v ~/.config/gcloud:/root/.config/gcloud \
  -v $(pwd):/workspace \
  devsecops-toolkit:latest

# With Docker socket (for Docker-in-Docker)
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.kube:/root/.kube \
  -v $(pwd):/workspace \
  devsecops-toolkit:latest

# As non-root user
docker run -it --rm \
  --user $(id -u):$(id -g) \
  -v ~/.kube:/home/user/.kube \
  -v $(pwd):/workspace \
  devsecops-toolkit:latest

# With network access
docker run -it --rm --network host \
  -v ~/.kube:/root/.kube \
  devsecops-toolkit:latest
```

### **Docker Compose Setup**

```yaml
# docker-compose.yml
version: '3.8'

services:
  devsecops:
    image: devsecops-toolkit:latest
    container_name: devsecops-workspace
    volumes:
      - ~/.kube:/root/.kube:ro
      - ~/.aws:/root/.aws:ro
      - ~/.config/gcloud:/root/.config/gcloud:ro
      - ./workspace:/workspace
      - /var/run/docker.sock:/var/run/docker.sock
    working_dir: /workspace
    stdin_open: true
    tty: true
    network_mode: host
```

```bash
# Usage
docker-compose run --rm devsecops bash
```

### **Kubernetes Deployment**

```yaml
# deployment.yaml
apiVersion: v1
kind: Pod
metadata:
  name: devsecops-pod
spec:
  containers:
  - name: devsecops
    image: devsecops-toolkit:latest
    command: ["sleep", "infinity"]
    volumeMounts:
    - name: workspace
      mountPath: /workspace
    resources:
      requests:
        memory: "1Gi"
        cpu: "500m"
      limits:
        memory: "2Gi"
        cpu: "1000m"
  volumes:
  - name: workspace
    emptyDir: {}
```

```bash
# Usage
kubectl apply -f deployment.yaml
kubectl exec -it devsecops-pod -- bash
```

---

## 🔧 Customization & Extension

### **Adding More Tools**

```dockerfile
# Add to appropriate stage
RUN TOOL_VERSION=$(curl -s https://api.github.com/repos/owner/tool/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/owner/tool/releases/download/${TOOL_VERSION}/tool-linux-amd64" \
    -O /usr/local/bin/tool && \
    chmod +x /usr/local/bin/tool
```

### **Environment-Specific Builds**

```bash
# Development (includes extra debugging tools)
docker build --target development -t devsecops-toolkit:dev .

# Production (minimal, security-hardened)
docker build --target production -t devsecops-toolkit:prod .

# Security-focused (only security tools)
docker build --target security -t devsecops-toolkit:security .
```

### **Plugin Installation at Runtime**

```bash
# Install kubectl plugins
kubectl krew install <plugin-name>

# Install additional Python packages
pip install --break-system-packages <package>

# Install additional npm packages
npm install -g <package>

# Install additional Go tools
go install <package>@latest
```

---

## 🐛 Troubleshooting

### **Common Issues & Solutions**

| Issue | Cause | Solution |
|-------|-------|----------|
| **Tools not found** | PATH issue | Check $PATH: `echo $PATH` |
| **Permission denied** | Running as non-root | Use `--user root` or fix permissions |
| **Kubectl can't connect** | Kubeconfig not mounted | Mount `~/.kube:/root/.kube` |
| **Docker socket error** | Socket not mounted | Mount `/var/run/docker.sock` |
| **Large image size** | Too many tools | Use multi-stage builds |
| **Slow build** | Too many layers | Combine RUN commands |
| **Network issues** | DNS problems | Use `--network host` |
| **Version conflicts** | Old cached layers | Use `--no-cache` flag |

### **Debugging Commands**

```bash
# Check installed versions
kubectl version --client
terraform version
helm version
docker version

# Verify tool installation
which kubectl
which terraform
which helm

# Check permissions
ls -la /usr/local/bin/

# Test connectivity
kubectl cluster-info
curl -I https://kubernetes.default.svc

# View logs
docker logs <container-id>
```

### **Performance Optimization**

```bash
# Reduce image size
docker build --squash -t devsecops-toolkit:latest .

# Remove unnecessary files
RUN rm -rf /var/cache/apk/* /tmp/* /root/.cache

# Use Alpine packages when possible
RUN apk add --no-cache <package>

# Multi-stage builds
FROM alpine:3.20 AS builder
# Build tools
FROM alpine:3.20
COPY --from=builder /usr/local/bin/* /usr/local/bin/
```

---

## 📈 Metrics & Monitoring

### **Image Metrics**

```bash
# Image size
docker images devsecops-toolkit:latest

# Layer analysis
dive devsecops-toolkit:latest

# Security vulnerabilities
trivy image --severity HIGH,CRITICAL devsecops-toolkit:latest

# SBOM
syft devsecops-toolkit:latest -o json > sbom.json
```

### **Runtime Metrics**

```bash
# Container stats
docker stats <container-id>

# Resource usage
docker exec <container> htop

# Network connections
docker exec <container> netstat -tulpn
```

---

## 🔐 Security Hardening

### **Image Hardening**

```dockerfile
# Run as non-root user
RUN addgroup -g 1000 devsecops && \
    adduser -D -u 1000 -G devsecops devsecops
USER devsecops

# Read-only filesystem
docker run --read-only \
  -v /tmp --tmpfs /tmp \
  devsecops-toolkit:latest

# Drop capabilities
docker run --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \
  devsecops-toolkit:latest

# Security profiles
docker run --security-opt seccomp=default.json \
  devsecops-toolkit:latest
```

### **Network Security**

```bash
# Isolated network
docker network create --internal devsecops-net
docker run --network devsecops-net devsecops-toolkit:latest

# No network
docker run --network none devsecops-toolkit:latest
```

---

## 📚 Additional Resources

- **Official Documentation**: See individual tool websites
- **Kubernetes**: https://kubernetes.io/docs/
- **Terraform**: https://www.terraform.io/docs
- **ArgoCD**: https://argo-cd.readthedocs.io/
- **Security**: https://kubernetes.io/docs/concepts/security/

---

## 🤝 Contributing

To add new tools:
1. Identify the appropriate stage
2. Add installation commands
3. Test thoroughly
4. Update documentation
5. Submit PR

---

## 📝 License & Maintenance

**Maintainer**: DevSecOps Team  
**Last Updated**: 2025  
**License**: MIT  
**Support**: Open an issue on GitHub

---

Like my work : ☕ [Send coffee](https://buymeacoffee.com/jaydeepgohel) and [GitHub stars](https://github.com/er-jaydeep-gohel/devsecops-toolkit).

**Built with ❤️ for DevSecOps and Cloud Security**
