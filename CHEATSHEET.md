# 🚀 DevSecOps Toolkit - Quick Reference Cheat Sheet

## 📦 Container Management

### Docker
```bash
docker ps -a                              # List all containers
docker images                             # List images
docker build -t myapp:v1 .               # Build image
docker run -it --rm myapp:v1 bash        # Run interactive
docker exec -it <container> bash         # Access running container
docker logs -f <container>               # Follow logs
docker system prune -a                   # Clean up everything
```

### Advanced Docker
```bash
dive myapp:v1                            # Analyze image layers
docker scout cves myapp:v1               # Security scan
lazydocker                               # TUI for Docker management
```

---

## ☸️ Kubernetes - Core Operations

### Context & Configuration
```bash
kubectx                                   # List/switch contexts
kubectx <context-name>                   # Switch context
kubens                                    # List/switch namespaces
kubens <namespace>                       # Switch namespace
kubectl config get-contexts              # View all contexts
kubectl config use-context <context>     # Switch context
```

### Resource Management
```bash
kubectl get all -A                       # All resources in all namespaces
kubectl get pods -o wide                 # Pods with extra details
kubectl get nodes -o wide                # Node details
kubectl describe pod <pod-name>          # Detailed pod info
kubectl logs <pod> -f                    # Follow logs
kubectl logs <pod> -c <container>        # Specific container logs
kubectl exec -it <pod> -- bash           # Access pod shell
```

### Resource Creation/Update
```bash
kubectl apply -f manifest.yaml           # Apply configuration
kubectl create -f manifest.yaml          # Create resources
kubectl delete -f manifest.yaml          # Delete resources
kubectl replace -f manifest.yaml         # Replace resources
kubectl patch <resource> <name> -p '<json>' # Patch resource
```

### Debugging
```bash
kubectl top nodes                        # Node resource usage
kubectl top pods -A                      # Pod resource usage
kubectl get events --sort-by='.lastTimestamp' # Recent events
kubectl describe pod <pod> | grep -i error    # Find errors
```

---

## 🔍 Kubernetes - Advanced Tools

### K9s (Terminal UI)
```bash
k9s                                      # Launch K9s
# Inside K9s:
# :pods         - View pods
# :svc          - View services
# :deploy       - View deployments
# Ctrl+A        - All namespaces
# /             - Filter
# d             - Describe
# l             - Logs
# s             - Shell
```

### Stern (Multi-pod logs)
```bash
stern <pod-pattern>                      # Tail logs from matching pods
stern --namespace <ns> <pattern>         # Specific namespace
stern --all-namespaces <pattern>         # All namespaces
stern <pattern> --since 15m              # Last 15 minutes
stern <pattern> -c <container>           # Specific container
```

### Kubectl Plugins
```bash
kubectl neat get pod <pod> -o yaml       # Clean output (remove clutter)
kubectl capacity                         # Cluster capacity
kubectl-sniff <pod>                      # Packet capture
kubetail <label-selector>                # Aggregate logs
```

---

## 🛡️ Security Scanning

### Container Images
```bash
trivy image myapp:v1                     # Comprehensive scan
trivy image --severity HIGH,CRITICAL myapp:v1  # Critical only
grype myapp:v1                           # Vulnerability scan
docker scout cves myapp:v1               # Docker Scout scan
syft myapp:v1                            # Generate SBOM
```

### Kubernetes Security
```bash
kubescape scan                           # Full cluster scan
kubescape scan framework nsa             # NSA framework
kubescape scan framework mitre           # MITRE ATT&CK
kube-bench                               # CIS Benchmarks
kube-hunter --remote                     # Penetration testing
popeye                                   # Cluster sanitizer
```

### IaC Security
```bash
terrascan scan -t terraform              # Terrascan
tfsec .                                  # Terraform security
checkov -d .                             # Multi-IaC scanner
trivy config .                           # Trivy IaC scan
```

---

## 🏗️ Infrastructure as Code

### Terraform
```bash
terraform init                           # Initialize
terraform plan                           # Plan changes
terraform apply                          # Apply changes
terraform destroy                        # Destroy infrastructure
terraform fmt                            # Format code
terraform validate                       # Validate configuration
terraform state list                     # List resources
terraform output                         # Show outputs
```

### Terraform Tools
```bash
tflint                                   # Lint Terraform
terraform-docs markdown .                # Generate docs
infracost breakdown --path .             # Cost estimate
terragrunt run-all plan                  # Terragrunt multi-module
```

### OpenTofu (Terraform Alternative)
```bash
tofu init                                # Initialize
tofu plan                                # Plan changes
tofu apply                               # Apply changes
```

---

## 🔄 GitOps

### ArgoCD
```bash
argocd login <server>                    # Login
argocd app list                          # List applications
argocd app get <app>                     # Get app details
argocd app sync <app>                    # Sync application
argocd app history <app>                 # Show history
argocd app rollback <app>                # Rollback
argocd app diff <app>                    # Show diff
```

### Flux
```bash
flux check                               # Check requirements
flux bootstrap github --owner=<org> --repository=<repo>  # Bootstrap
flux create source git <name> --url=<url>  # Create source
flux get kustomizations                  # List kustomizations
flux reconcile kustomization <name>      # Force reconcile
flux suspend kustomization <name>        # Suspend
flux resume kustomization <name>         # Resume
```

### Tekton
```bash
tkn pipeline list                        # List pipelines
tkn pipelinerun list                     # List runs
tkn pipelinerun logs <run> -f            # Follow logs
tkn pipeline start <pipeline>            # Start pipeline
```

---

## 🕸️ Service Mesh

### Istio
```bash
istioctl install --set profile=demo      # Install
istioctl analyze                         # Analyze config
istioctl proxy-status                    # Check proxy status
istioctl dashboard grafana               # Open Grafana
istioctl dashboard kiali                 # Open Kiali
istioctl version                         # Version info
```

### Linkerd
```bash
linkerd check                            # Pre-flight check
linkerd install | kubectl apply -f -     # Install
linkerd dashboard                        # Open dashboard
linkerd stat deploy                      # Deployment stats
linkerd top deploy                       # Live traffic
```

### Cilium
```bash
cilium status                            # Status check
cilium connectivity test                 # Test connectivity
cilium monitor                           # Monitor traffic
```

---

## 🔐 Secret Management

### SOPS
```bash
sops -e secrets.yaml > secrets.enc.yaml  # Encrypt
sops -d secrets.enc.yaml                 # Decrypt
sops secrets.yaml                        # Edit encrypted file
```

### Age
```bash
age-keygen -o key.txt                    # Generate key
age -r <public-key> -o file.enc file.txt # Encrypt
age -d -i key.txt file.enc               # Decrypt
```

### Vault
```bash
vault login                              # Login
vault kv put secret/myapp key=value      # Store secret
vault kv get secret/myapp                # Retrieve secret
vault kv list secret/                    # List secrets
```

### Sealed Secrets
```bash
kubeseal < secret.yaml > sealed.yaml     # Seal secret
kubectl apply -f sealed.yaml             # Deploy sealed secret
```

---

## 📊 Monitoring & Observability

### Prometheus
```bash
promtool check config prometheus.yml     # Validate config
promtool query instant <url> '<query>'   # Run query
promtool test rules rules.yml            # Test rules
```

### Load Testing
```bash
# k6
k6 run script.js                         # Run test
k6 run --vus 10 --duration 30s script.js # 10 users, 30s

# vegeta
echo "GET https://example.com" | vegeta attack -duration=30s -rate=50 | vegeta report

# hey
hey -n 1000 -c 10 https://example.com    # 1000 requests, 10 concurrent
```

---

## 💰 Cost Optimization

### Kubecost
```bash
kubectl cost                             # Cluster costs
kubectl cost namespace <namespace>       # Namespace costs
kubectl cost deployment <name>           # Deployment costs
```

### Infracost
```bash
infracost breakdown --path .             # Show cost breakdown
infracost diff --path .                  # Compare changes
infracost output --format json           # JSON output
```

---

## 🔄 Backup & Recovery

### Velero
```bash
velero backup create <name>              # Create backup
velero backup get                        # List backups
velero restore create --from-backup <n>  # Restore
velero schedule create <name> --schedule="0 1 * * *"  # Daily backup
```

### Restic
```bash
restic -r /backup init                   # Initialize repository
restic -r /backup backup /data           # Backup
restic -r /backup snapshots              # List snapshots
restic -r /backup restore latest --target /restore  # Restore
```

---

## 🧪 Kubernetes Development

### Kind
```bash
kind create cluster                      # Create cluster
kind create cluster --config config.yaml # With config
kind get clusters                        # List clusters
kind delete cluster                      # Delete cluster
```

### Skaffold
```bash
skaffold dev                             # Development mode
skaffold run                             # Build & deploy
skaffold debug                           # Debug mode
skaffold delete                          # Delete deployed resources
```

### Telepresence
```bash
telepresence connect                     # Connect to cluster
telepresence list                        # List services
telepresence intercept <svc> --port 8080:80  # Intercept service
telepresence leave <svc>                 # Stop intercept
```

---

## 📝 Policy & Compliance

### OPA (Open Policy Agent)
```bash
opa eval -d policy.rego -i input.json "data.allow"  # Evaluate policy
opa test -v policies/                    # Test policies
opa run -s                               # Run server
```

### Conftest
```bash
conftest test deployment.yaml            # Test manifest
conftest test --policy policy/ manifest.yaml  # Custom policy
conftest pull                            # Pull policies
```

### Kyverno
```bash
kyverno apply policy.yaml --resource deployment.yaml  # Test policy
kyverno create policy                    # Create policy
```

---

## 🔍 API Deprecation Detection

```bash
kubepug                                  # Scan cluster
pluto detect-files -d .                  # Scan files
kubent                                   # Find deprecated APIs
```

---

## 🛠️ Developer Tools

### Git
```bash
lazygit                                  # TUI for Git
gh pr list                               # List PRs (GitHub)
gh pr create                             # Create PR
glab mr list                             # List MRs (GitLab)
```

### File Operations
```bash
bat file.txt                             # Cat with syntax highlighting
fd <pattern>                             # Fast find
fzf                                      # Fuzzy finder (interactive)
```

### HTTP Testing
```bash
http GET https://api.example.com         # GET request
http POST https://api.example.com key=value  # POST request
https https://api.example.com            # HTTPS request
```

---

## 🔎 Linting & Validation

```bash
shellcheck script.sh                     # Bash script linter
hadolint Dockerfile                      # Dockerfile linter
yamllint config.yaml                     # YAML linter
kubectl neat get pod <pod> -o yaml       # Clean Kubernetes manifest
```

---

## 🌐 Cloud Provider CLIs

### AWS
```bash
aws configure                            # Configure credentials
aws s3 ls                                # List S3 buckets
aws ec2 describe-instances               # List EC2 instances
aws eks list-clusters                    # List EKS clusters
aws eks update-kubeconfig --name <n>     # Get kubeconfig
```

### Google Cloud
```bash
gcloud init                              # Initialize
gcloud projects list                     # List projects
gcloud compute instances list            # List instances
gcloud container clusters list           # List GKE clusters
gcloud container clusters get-credentials <n>  # Get kubeconfig
```

### Azure
```bash
az login                                 # Login
az account list                          # List subscriptions
az vm list                               # List VMs
az aks list                              # List AKS clusters
az aks get-credentials --resource-group <rg> --name <n>  # Get kubeconfig
```

---

## 📦 Package Management

### Helm
```bash
helm repo add <name> <url>               # Add repository
helm repo update                         # Update repositories
helm search repo <name>                  # Search charts
helm install <name> <chart>              # Install chart
helm upgrade <name> <chart>              # Upgrade release
helm list                                # List releases
helm uninstall <name>                    # Uninstall release
```

### Kustomize
```bash
kustomize build .                        # Build manifests
kubectl apply -k .                       # Apply with kustomize
kustomize edit add resource <file>       # Add resource
```

---

## 💡 Pro Tips

### Aliases (Add to ~/.bashrc)
```bash
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deploy'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete -f'
alias klogs='kubectl logs -f'
alias kexec='kubectl exec -it'
alias kctx='kubectx'
alias kns='kubens'
alias tf='terraform'
alias tg='terragrunt'
```

### Kubernetes Shortcuts
```bash
# Set default namespace
kubectl config set-context --current --namespace=<namespace>

# Quick pod shell
kubectl run debug --rm -it --image=alpine -- sh

# Port forward
kubectl port-forward svc/<service> 8080:80

# Copy files
kubectl cp <pod>:/path/to/file ./local-file

# Quick deployment
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
```

### Performance Tips
```bash
# Speed up kubectl
source <(kubectl completion bash)
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc

# Faster context switching
echo 'export KUBECTX_IGNORE_FZF=1' >> ~/.bashrc
```

---

## 🆘 Emergency Commands

### Cluster Issues
```bash
kubectl get nodes                        # Check node status
kubectl top nodes                        # Resource usage
kubectl describe node <node>             # Node details
kubectl cordon <node>                    # Drain preparation
kubectl drain <node> --ignore-daemonsets # Drain node
kubectl uncordon <node>                  # Make schedulable
```

### Pod Issues
```bash
kubectl get pod <pod> -o yaml | kubectl neat  # Clean view
kubectl logs <pod> --previous            # Previous container logs
kubectl describe pod <pod>               # Full details
kubectl get events --field-selector involvedObject.name=<pod>  # Pod events
```

### Quick Fixes
```bash
# Restart deployment
kubectl rollout restart deployment/<name>

# Scale down/up
kubectl scale deployment/<name> --replicas=0
kubectl scale deployment/<name> --replicas=3

# Delete stuck pod
kubectl delete pod <pod> --force --grace-period=0

# Delete stuck namespace
kubectl get namespace <ns> -o json | jq '.spec.finalizers = []' | kubectl replace --raw "/api/v1/namespaces/<ns>/finalize" -f -
```

---

## 📚 Learning Resources

### Documentation
- Kubernetes: https://kubernetes.io/docs/
- Terraform: https://www.terraform.io/docs
- Helm: https://helm.sh/docs/
- ArgoCD: https://argo-cd.readthedocs.io/

### Interactive Learning
```bash
# Kubernetes playground
kubectl run busybox --rm -it --image=busybox -- sh

# Test policies
conftest test --help
opa eval --help

# Explore tools
k9s --help
stern --help
```

---

**💡 Remember**: Practice makes perfect! Use `<tool> --help` for detailed usage.

**🔄 Keep Updated**: Run `docker pull devsecops-toolkit:latest` regularly for latest tools.

**🐛 Debug**: Use `-v` or `--verbose` flags for detailed output.

**📖 Document**: Keep your own notes and share knowledge!
