################################################################################
# DevSecOps Alpine-based Multi-Tool Container
################################################################################
# Purpose: Comprehensive DevSecOps toolchain for Kubernetes, Cloud, Security,
#          Infrastructure as Code, and Container operations
# Base Image: Alpine Linux 3.20 (Lightweight and secure)
# Maintained by: DevSecOps Consultant - Jaydeep Gohel (er.jaydeepgohel@gmail.com)
# Last Updated: 2025
################################################################################

FROM alpine:3.20

################################################################################
# STAGE 1: ENVIRONMENT SETUP
################################################################################

# Set environment variables for consistent behavior
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    DEBIAN_FRONTEND=noninteractive

# Set timezone (modify as needed)
ENV TZ=Asia/Kolkata

################################################################################
# STAGE 2: BASE SYSTEM PACKAGES & UTILITIES
################################################################################

# Update system and install core utilities
RUN apk update && apk upgrade && \
    apk add --no-cache \
    # Shell & Terminal
    bash \
    bash-completion \
    tmux \
    # Editors
    vim \
    nano \
    neovim \
    # Core Tools
    curl \
    wget \
    git \
    openssh-client \
    sudo \
    ca-certificates \
    # Archive Tools
    unzip \
    zip \
    tar \
    xz \
    # JSON/YAML Processing
    jq \
    # Documentation
    groff \
    less \
    # Python & Build Tools
    python3 \
    py3-pip \
    build-base \
    libffi-dev \
    openssl-dev \
    openssl \
    gpg \
    # Timezone Support
    tzdata && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone 

# Install basic utilities and dependencies
RUN apk add --no-cache \
    python3-dev \
    musl-dev \
    gcc \
    cargo \
    make


################################################################################
# STAGE 3: NETWORKING & DIAGNOSTICS TOOLS
################################################################################

RUN apk add --no-cache \
    # Network Analysis
    netcat-openbsd \
    busybox \
    tcpdump \
    nmap \
    nmap-scripts \
    mtr \
    fping \
    ngrep \
    # DNS Tools
    bind-tools \
    # Network Interface Tools
    net-tools \
    iproute2 \
    # System Monitoring
    htop \
    iftop \
    iotop \
    strace \
    lsof \
    # Search Tools
    ripgrep

################################################################################
# STAGE 4: PROGRAMMING LANGUAGES & RUNTIMES
################################################################################

# Install Java
RUN apk add --no-cache openjdk11 && \
    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk && \
    export PATH=$JAVA_HOME/bin:$PATH

# Install Go
RUN apk add --no-cache curl tar bash && \
    GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1 | sed 's/go//') && \
    echo "Installing Go ${GO_VERSION}..." && \
    curl -L "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    ln -sf /usr/local/go/bin/go /usr/local/bin/go && \
    rm /tmp/go.tar.gz && \
    go version

# Install Node.js and NPM
RUN apk add --no-cache nodejs npm

################################################################################
# STAGE 5: CLOUD CLI TOOLS
################################################################################

# AWS CLI (from Alpine packages)
RUN apk add --no-cache aws-cli

# AWS IAM Authenticator
RUN curl -Lo aws-iam-authenticator \
    https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/latest/download/aws-iam-authenticator-linux-amd64 && \
    chmod +x ./aws-iam-authenticator && \
    mv ./aws-iam-authenticator /usr/local/bin/

# Google Cloud SDK
RUN curl -O https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz && \
    tar -xzf google-cloud-sdk.tar.gz && \
    ./google-cloud-sdk/install.sh --quiet && \
    rm google-cloud-sdk.tar.gz && \
    rm -rf google-cloud-sdk/.install/.tmp
ENV PATH=/google-cloud-sdk/bin:$PATH

# Azure CLI (in virtual environment to avoid conflicts)
RUN python3 -m venv /opt/azure-cli && \
    /opt/azure-cli/bin/pip install --upgrade pip && \
    /opt/azure-cli/bin/pip install --no-cache-dir azure-cli && \
    ln -s /opt/azure-cli/bin/az /usr/local/bin/az

################################################################################
# STAGE 6: CONTAINER & ORCHESTRATION TOOLS
################################################################################

# Docker CLI & Docker Compose
RUN apk add --no-cache docker-cli docker-compose

# Kubernetes CLI (kubectl) - Latest stable version
RUN KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt) && \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Helm - Kubernetes Package Manager
RUN HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    curl -LO "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar -xzvf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf linux-amd64 helm-${HELM_VERSION}-linux-amd64.tar.gz

# K9s - Kubernetes TUI
RUN apk add --no-cache k9s

# Kind - Kubernetes in Docker
RUN curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64 && \
    chmod +x ./kind && \
    mv ./kind /usr/local/bin/kind

################################################################################
# STAGE 7: KUBECTL PLUGINS & UTILITIES
################################################################################

# kubectx & kubens - Context and Namespace switching
RUN KUBECTX_VERSION=$(curl -s https://api.github.com/repos/ahmetb/kubectx/releases/latest | \
    sed -n 's/.*"tag_name": "v\([0-9.]*\)".*/\1/p') && \
    echo $KUBECTX_VERSION > /tmp/kubectx_version.txt && \
    wget https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubectx_v${KUBECTX_VERSION}_linux_x86_64.tar.gz \
    -O kubectx.tar.gz && \
    tar -xzvf kubectx.tar.gz && \
    mv kubectx /usr/local/bin/kubectx && \
    rm kubectx.tar.gz && \
    wget https://github.com/ahmetb/kubectx/releases/download/v${KUBECTX_VERSION}/kubens_v${KUBECTX_VERSION}_linux_x86_64.tar.gz \
    -O kubens.tar.gz && \
    tar -xzvf kubens.tar.gz && \
    mv kubens /usr/local/bin/kubens && \
    rm kubens.tar.gz /tmp/kubectx_version.txt

# Stern - Multi-pod log tailing
RUN STERN_VERSION=$(curl -s https://api.github.com/repos/stern/stern/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    curl -Lo stern https://github.com/stern/stern/releases/download/${STERN_VERSION}/stern_${STERN_VERSION#v}_linux_amd64.tar.gz && \
    tar -xzf stern && \
    chmod +x stern && \
    mv stern /usr/local/bin/stern && \
    rm -f stern_*

# kubectl-neat - Clean Kubernetes manifests
RUN KUBECTL_NEAT_VERSION=$(curl -s https://api.github.com/repos/itaysk/kubectl-neat/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget https://github.com/itaysk/kubectl-neat/releases/download/${KUBECTL_NEAT_VERSION}/kubectl-neat_linux_amd64.tar.gz && \
    tar -xzvf kubectl-neat_linux_amd64.tar.gz && \
    mv kubectl-neat /usr/local/bin/ && \
    rm kubectl-neat_linux_amd64.tar.gz

# Kubetail - Aggregate logs from multiple pods
RUN wget https://raw.githubusercontent.com/johanhaleby/kubetail/master/kubetail && \
    chmod +x kubetail && \
    mv kubetail /usr/local/bin/kubetail

# kube-capacity - Resource capacity analyzer
RUN KUBE_CAPACITY_VERSION=$(curl -s https://api.github.com/repos/robscott/kube-capacity/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget https://github.com/robscott/kube-capacity/releases/download/${KUBE_CAPACITY_VERSION}/kube-capacity_${KUBE_CAPACITY_VERSION}_Linux_x86_64.tar.gz && \
    tar -xzvf kube-capacity_${KUBE_CAPACITY_VERSION}_Linux_x86_64.tar.gz && \
    mv kube-capacity /usr/local/bin/ && \
    rm kube-capacity_${KUBE_CAPACITY_VERSION}_Linux_x86_64.tar.gz

# Popeye - Kubernetes cluster sanitizer
RUN POPEYE_VERSION=$(curl -s https://api.github.com/repos/derailed/popeye/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget https://github.com/derailed/popeye/releases/download/${POPEYE_VERSION}/popeye_linux_amd64.tar.gz && \
    tar -xzvf popeye_linux_amd64.tar.gz && \
    mv popeye /usr/local/bin/ && \
    rm popeye_linux_amd64.tar.gz

# ksniff - Packet capture for Kubernetes pods
RUN mkdir -p /tmp/ksniff && cd /tmp/ksniff && \
    KSNIFF_VERSION=$(curl -s https://api.github.com/repos/eldadru/ksniff/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget https://github.com/eldadru/ksniff/releases/download/${KSNIFF_VERSION}/ksniff.zip && \
    unzip ksniff.zip && \
    mv kubectl-sniff /usr/local/bin/kubectl-sniff && \
    mv static-tcpdump /usr/local/bin/static-tcpdump && \
    cd / && rm -rf /tmp/ksniff

################################################################################
# STAGE 8: INFRASTRUCTURE AS CODE (IaC) TOOLS
################################################################################

# Terraform - Infrastructure provisioning
RUN TF_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | \
    jq -r .current_version | sed 's/^v//') && \
    wget -O terraform.zip \
    "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip" && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/terraform && \
    chmod +x /usr/local/bin/terraform && \
    rm terraform.zip

# Ansible - Configuration management
RUN apk add --no-cache ansible

# OpenTofu - Open-source Terraform alternative
RUN OPENTOFU_VERSION=$(curl -s https://api.github.com/repos/opentofu/opentofu/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/^v//') && \
    mkdir -p /tmp/opentofu && cd /tmp/opentofu && \
    wget "https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_linux_amd64.zip" -O tofu.zip && \
    unzip tofu.zip && \
    mv tofu /usr/local/bin/ && \
    chmod +x /usr/local/bin/tofu && \
    rm tofu.zip && cd / && rm -rf /tmp/opentofu


# Terragrunt - Terraform wrapper (must match Terraform version please see docs - https://terragrunt.gruntwork.io/docs/getting-started/install/)
RUN TERRAGRUNT_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64" -O /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

# tflint - Terraform linter
RUN TFLINT_VERSION=$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip" && \
    unzip tflint_linux_amd64.zip && \
    mv tflint /usr/local/bin/ && \
    chmod +x /usr/local/bin/tflint && \
    rm tflint_linux_amd64.zip

# terraform-docs - Generate documentation from Terraform modules
RUN TFDOCS_VERSION=$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/terraform-docs/terraform-docs/releases/download/${TFDOCS_VERSION}/terraform-docs-${TFDOCS_VERSION}-linux-amd64.tar.gz" && \
    tar -xzf terraform-docs-${TFDOCS_VERSION}-linux-amd64.tar.gz && \
    mv terraform-docs /usr/local/bin/ && \
    chmod +x /usr/local/bin/terraform-docs && \
    rm -f terraform-docs-*

# Pulumi - Modern Infrastructure as Code
RUN curl -fsSL https://get.pulumi.com | sh && \
    mv /root/.pulumi/bin/pulumi /usr/local/bin/

################################################################################
# STAGE 9: SERVICE MESH TOOLS
################################################################################

# Istioctl - Istio service mesh CLI
RUN ISTIO_VERSION=$(curl -s https://api.github.com/repos/istio/istio/releases/latest | \
    jq -r .tag_name) && \
    curl -sSLo /tmp/istio.tar.gz \
    "https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION#v}-linux-amd64.tar.gz" && \
    tar -xzf /tmp/istio.tar.gz -C /tmp && \
    mv /tmp/istio-${ISTIO_VERSION#v}/bin/istioctl /usr/local/bin/ && \
    rm -rf /tmp/istio*

# Cilium CLI - eBPF-based networking
RUN curl -L --silent \
    https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz | \
    tar -xz -C /tmp && \
    mv /tmp/cilium /usr/local/bin/ && \
    chmod +x /usr/local/bin/cilium

# Calicoctl - Calico network policy CLI
RUN CALICOCTL_URL=$(curl -s https://api.github.com/repos/projectcalico/calico/releases/latest | \
    grep browser_download_url | grep calicoctl-linux-amd64 | cut -d '"' -f 4) && \
    curl -L $CALICOCTL_URL -o /usr/local/bin/calicoctl && \
    chmod +x /usr/local/bin/calicoctl

# Linkerd CLI - Lightweight service mesh
RUN curl -fsL https://run.linkerd.io/install | sh && \
    mv /root/.linkerd2/bin/linkerd /usr/local/bin/

################################################################################
# STAGE 10: CI/CD & GITOPS TOOLS
################################################################################

# ArgoCD CLI - Declarative GitOps
RUN ARGOCD_VERSION=$(curl -s https://api.github.com/repos/argoproj/argo-cd/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    curl -sSL -o /usr/local/bin/argocd \
    "https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64" && \
    chmod +x /usr/local/bin/argocd

# Flux CLI - GitOps toolkit
RUN curl -s https://fluxcd.io/install.sh | bash && \
    mv /usr/local/bin/flux /usr/local/bin/flux || true

# Tekton CLI (tkn) - Cloud-native CI/CD
RUN TKN_VERSION=$(curl -s https://api.github.com/repos/tektoncd/cli/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/tektoncd/cli/releases/download/${TKN_VERSION}/tkn_${TKN_VERSION#v}_Linux_x86_64.tar.gz" && \
    tar -xzf tkn_${TKN_VERSION#v}_Linux_x86_64.tar.gz && \
    mv tkn /usr/local/bin/ && \
    chmod +x /usr/local/bin/tkn && \
    rm -f tkn_*

# GitHub CLI
RUN GH_VERSION=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | \
    grep tag_name | cut -d '"' -f 4 | sed 's/^v//') && \
    wget "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz" && \
    tar -xzf gh_${GH_VERSION}_linux_amd64.tar.gz && \
    mv gh_${GH_VERSION}_linux_amd64/bin/gh /usr/local/bin/ && \
    rm -rf gh_*

# GitLab CLI (glab)
RUN GLAB_VERSION=$(curl -s https://api.github.com/repos/profclems/glab/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    mkdir -p /tmp/glab && cd /tmp/glab && \
    wget "https://github.com/profclems/glab/releases/download/${GLAB_VERSION}/glab_${GLAB_VERSION#v}_Linux_x86_64.tar.gz" && \
    tar -xzf glab_${GLAB_VERSION#v}_Linux_x86_64.tar.gz && \
    mv bin/glab /usr/local/bin/ && \
    rm -rf bin glab_* && cd / && rm -rf /tmp/glab

################################################################################
# STAGE 11: SECURITY SCANNING TOOLS
################################################################################

## Trivy : scanning tool that provides vulnerability detection for operating systems 
RUN LATEST_TRIVY=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    echo "Installing Trivy ${LATEST_TRIVY}" && \
    curl -L -o /tmp/trivy.tar.gz "https://github.com/aquasecurity/trivy/releases/download/${LATEST_TRIVY}/trivy_${LATEST_TRIVY#v}_Linux-64bit.tar.gz" && \
    tar -xzf /tmp/trivy.tar.gz -C /usr/local/bin trivy && \
    chmod +x /usr/local/bin/trivy && \
    rm /tmp/trivy.tar.gz


# Kubescape - Kubernetes security platform
RUN bash -c "curl -s https://raw.githubusercontent.com/kubescape/kubescape/master/install.sh | bash"    


# Kube-bench - CIS Kubernetes benchmark
RUN KUBEBENCH_VERSION=$(curl -s https://api.github.com/repos/aquasecurity/kube-bench/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/aquasecurity/kube-bench/releases/download/${KUBEBENCH_VERSION}/kube-bench_${KUBEBENCH_VERSION#v}_linux_amd64.tar.gz" && \
    tar -xzf kube-bench_${KUBEBENCH_VERSION#v}_linux_amd64.tar.gz && \
    mv kube-bench /usr/local/bin/ && \
    rm -f kube-bench_*

# kube-hunter - Security scanner for Kubernetes
RUN python3 -m venv /opt/kube-hunter && \
    /opt/kube-hunter/bin/pip install --no-cache-dir kube-hunter && \
    ln -s /opt/kube-hunter/bin/kube-hunter /usr/local/bin/kube-hunter

# Starboard CLI - Kubernetes native security toolkit
RUN STARBOARD_VERSION=$(curl -s https://api.github.com/repos/aquasecurity/starboard/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    curl -L -o starboard.tar.gz "https://github.com/aquasecurity/starboard/releases/download/${STARBOARD_VERSION}/starboard_linux_x86_64.tar.gz" && \
    tar -xzf starboard.tar.gz && \
    chmod +x starboard && \
    mv starboard /usr/local/bin/ && \
    rm -f starboard.tar.gz

# Terrascan - IaC security scanner
RUN curl -L "$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep -o -E "https://.+?_Linux_x86_64.tar.gz")" > terrascan.tar.gz && \
    tar -xf terrascan.tar.gz && \
    mv terrascan /usr/local/bin/ && \
    rm terrascan.tar.gz

# Checkov - IaC static analysis
RUN python3 -m venv /opt/checkov && \
    /opt/checkov/bin/pip install --no-cache-dir checkov && \
    ln -s /opt/checkov/bin/checkov /usr/local/bin/checkov

# tfsec - Terraform security scanner (now part of trivy)
RUN TFSEC_VERSION=$(curl -s https://api.github.com/repos/aquasecurity/tfsec/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/aquasecurity/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-amd64" \
    -O /usr/local/bin/tfsec && \
    chmod +x /usr/local/bin/tfsec

# Grype - Vulnerability scanner for container images
RUN curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | \
    sh -s -- -b /usr/local/bin

# Cosign - Container signing and verification
RUN apk add --no-cache cosign

# Syft - SBOM generator
RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | \
    sh -s -- -b /usr/local/bin

# Docker Scout - Container image analysis
RUN curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh

# Snyk CLI - Security scanning platform
RUN npm install -g snyk

# Falco - Cloud-native runtime security (client only)
RUN FALCO_VERSION=$(curl -s https://api.github.com/repos/falcosecurity/falco/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://download.falco.org/packages/bin/x86_64/falco-${FALCO_VERSION#v}-x86_64.tar.gz" && \
    tar -xzf falco-${FALCO_VERSION#v}-x86_64.tar.gz && \
    mv falco-${FALCO_VERSION#v}-x86_64/usr/bin/falco /usr/local/bin/ || true && \
    rm -rf falco-*

# CloudSploit - Cloud security scanner
RUN git clone https://github.com/aquasecurity/cloudsploit.git /opt/cloudsploit && \
    cd /opt/cloudsploit && \
    npm install && \
    ln -s /opt/cloudsploit/index.js /usr/local/bin/cloudsploit && \
    chmod +x /usr/local/bin/cloudsploit

################################################################################
# STAGE 12: SECRET MANAGEMENT TOOLS
################################################################################

# SOPS - Secrets Operations
RUN SOPS_VERSION=$(curl -s https://api.github.com/repos/getsops/sops/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64" \
    -O /usr/local/bin/sops && \
    chmod +x /usr/local/bin/sops

# age - Modern encryption tool
RUN AGE_VERSION=$(curl -s https://api.github.com/repos/FiloSottile/age/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/FiloSottile/age/releases/download/${AGE_VERSION}/age-${AGE_VERSION}-linux-amd64.tar.gz" && \
    tar -xzf age-${AGE_VERSION}-linux-amd64.tar.gz && \
    mv age/age /usr/local/bin/ && \
    mv age/age-keygen /usr/local/bin/ && \
    rm -rf age age-*

# Vault CLI - HashiCorp Vault client
RUN VAULT_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/vault | jq -r .current_version) && \
    mkdir -p /tmp/vault && cd /tmp/vault && \
    wget "https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip" && \
    unzip vault_${VAULT_VERSION}_linux_amd64.zip && \
    mv vault /usr/local/bin/ && \
    chmod +x /usr/local/bin/vault && \
    rm vault_* && rm -rf /tmp/vault

# Sealed Secrets (kubeseal)
RUN KUBESEAL_VERSION=$(curl -s https://api.github.com/repos/bitnami-labs/sealed-secrets/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/bitnami-labs/sealed-secrets/releases/download/${KUBESEAL_VERSION}/kubeseal-${KUBESEAL_VERSION#v}-linux-amd64.tar.gz" && \
    tar -xzf kubeseal-${KUBESEAL_VERSION#v}-linux-amd64.tar.gz && \
    mv kubeseal /usr/local/bin/ && \
    chmod +x /usr/local/bin/kubeseal && \
    rm -f kubeseal-*

################################################################################
# STAGE 13: OBSERVABILITY & MONITORING TOOLS
################################################################################

# Prometheus CLI tools (promtool)
RUN PROM_VERSION=$(curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/prometheus/prometheus/releases/download/${PROM_VERSION}/prometheus-${PROM_VERSION#v}.linux-amd64.tar.gz" && \
    tar -xzf prometheus-${PROM_VERSION#v}.linux-amd64.tar.gz && \
    mv prometheus-${PROM_VERSION#v}.linux-amd64/promtool /usr/local/bin/ && \
    rm -rf prometheus-*

# Grafana's k6 - Load testing tool
RUN K6_VERSION=$(curl -s https://api.github.com/repos/grafana/k6/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/grafana/k6/releases/download/${K6_VERSION}/k6-${K6_VERSION}-linux-amd64.tar.gz" && \
    tar -xzf k6-${K6_VERSION}-linux-amd64.tar.gz && \
    mv k6-${K6_VERSION}-linux-amd64/k6 /usr/local/bin/ && \
    rm -rf k6-*

# OpenTelemetry CLI
RUN OTEL_VERSION=$(curl -s https://api.github.com/repos/open-telemetry/opentelemetry-collector-releases/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/${OTEL_VERSION}/otelcol_${OTEL_VERSION#v}_linux_amd64.tar.gz" && \
    tar -xzf otelcol_${OTEL_VERSION#v}_linux_amd64.tar.gz && \
    mv otelcol /usr/local/bin/otelcol-contrib && \
    rm -f otelcol_*

################################################################################
# STAGE 14: DATA PROCESSING & UTILITIES
################################################################################

# yq - YAML processor (like jq for YAML)
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
    -O /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq

# ShellCheck - Shell script linter
RUN SHELLCHECK_VERSION=$(curl -s https://api.github.com/repos/koalaman/shellcheck/releases/latest | \
    awk -F '["]' '/tag_name/ {print $4}') && \
    wget "https://github.com/koalaman/shellcheck/releases/download/${SHELLCHECK_VERSION}/shellcheck-${SHELLCHECK_VERSION}.linux.x86_64.tar.xz" \
    -O shellcheck.tar.xz && \
    tar -xvf shellcheck.tar.xz && \
    mv shellcheck-${SHELLCHECK_VERSION}/shellcheck /usr/local/bin/ && \
    chmod +x /usr/local/bin/shellcheck && \
    rm -rf shellcheck*

# hadolint - Dockerfile linter
RUN HADOLINT_VERSION=$(curl -s https://api.github.com/repos/hadolint/hadolint/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64" \
    -O /usr/local/bin/hadolint && \
    chmod +x /usr/local/bin/hadolint

# yamllint - YAML linter
RUN python3 -m venv /opt/yamllint && \
    /opt/yamllint/bin/pip install --no-cache-dir yamllint && \
    ln -s /opt/yamllint/bin/yamllint /usr/local/bin/yamllint

# PostgreSQL Client
RUN apk add --no-cache postgresql16-client

# MySQL/MariaDB Client
RUN apk add --no-cache mariadb-client

# MongoDB tools
RUN wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.9.4.tgz && \
    tar -xzf mongodb-database-tools-ubuntu2204-x86_64-100.9.4.tgz && \
    mv mongodb-database-tools-ubuntu2204-x86_64-100.9.4/bin/* /usr/local/bin/ && \
    rm -rf mongodb-database-tools-*

# Redis CLI
RUN apk add --no-cache redis

# GraphViz - Graph visualization
RUN apk add --no-cache graphviz

################################################################################
# STAGE 15: POLICY & COMPLIANCE TOOLS
################################################################################

# Open Policy Agent (OPA)
RUN OPA_VERSION=$(curl -s https://api.github.com/repos/open-policy-agent/opa/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/open-policy-agent/opa/releases/download/${OPA_VERSION}/opa_linux_amd64_static" \
    -O /usr/local/bin/opa && \
    chmod +x /usr/local/bin/opa

# Conftest - Policy testing
RUN CONFTEST_VERSION=$(curl -s https://api.github.com/repos/open-policy-agent/conftest/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/open-policy-agent/conftest/releases/download/${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION#v}_Linux_x86_64.tar.gz" && \
    tar -xzf conftest_${CONFTEST_VERSION#v}_Linux_x86_64.tar.gz && \
    mv conftest /usr/local/bin/ && \
    rm -f conftest_*

# Gatekeeper Policy Manager
RUN GATEKEEPER_VERSION=$(curl -s https://api.github.com/repos/open-policy-agent/gatekeeper/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/open-policy-agent/gatekeeper/releases/download/${GATEKEEPER_VERSION}/gator-${GATEKEEPER_VERSION}-linux-amd64.tar.gz" && \
    tar -xzf gator-${GATEKEEPER_VERSION}-linux-amd64.tar.gz && \
    mv gator /usr/local/bin/ && \
    rm -f gator-*

# Kyverno CLI - Kubernetes policy engine
RUN KYVERNO_VERSION=$(curl -s https://api.github.com/repos/kyverno/kyverno/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/kyverno/kyverno/releases/download/${KYVERNO_VERSION}/kyverno-cli_${KYVERNO_VERSION}_linux_x86_64.tar.gz" && \
    tar -xzf kyverno-cli_${KYVERNO_VERSION}_linux_x86_64.tar.gz && \
    mv kyverno /usr/local/bin/ && \
    rm -f kyverno-cli_*

################################################################################
# STAGE 16: COST OPTIMIZATION & FINOPS TOOLS
################################################################################

# Kubecost CLI
RUN KUBECOST_VERSION=$(curl -s https://api.github.com/repos/kubecost/kubectl-cost/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/kubecost/kubectl-cost/releases/download/${KUBECOST_VERSION}/kubectl-cost-linux-amd64.tar.gz" && \
    tar -xzf kubectl-cost-linux-amd64.tar.gz && \
    mv kubectl-cost /usr/local/bin/ && \
    chmod +x /usr/local/bin/kubectl-cost && \
    rm -f kubectl-cost-*

# Infracost - Cloud cost estimates for Terraform
RUN curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

################################################################################
# STAGE 17: BACKUP & DISASTER RECOVERY
################################################################################

# Velero - Kubernetes backup tool
RUN VELERO_VERSION=$(curl -s https://api.github.com/repos/vmware-tanzu/velero/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/vmware-tanzu/velero/releases/download/${VELERO_VERSION}/velero-${VELERO_VERSION}-linux-amd64.tar.gz" && \
    tar -xzf velero-${VELERO_VERSION}-linux-amd64.tar.gz && \
    mv velero-${VELERO_VERSION}-linux-amd64/velero /usr/local/bin/ && \
    rm -rf velero-*

# Restic - Backup program
RUN RESTIC_VERSION=$(curl -s https://api.github.com/repos/restic/restic/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/restic/restic/releases/download/${RESTIC_VERSION}/restic_${RESTIC_VERSION#v}_linux_amd64.bz2" && \
    bunzip2 restic_${RESTIC_VERSION#v}_linux_amd64.bz2 && \
    mv restic_${RESTIC_VERSION#v}_linux_amd64 /usr/local/bin/restic && \
    chmod +x /usr/local/bin/restic

################################################################################
# STAGE 18: DEVELOPER TOOLS & UTILITIES
################################################################################

# lazygit - Simple terminal UI for git
RUN LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz" && \
    tar -xzf lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz && \
    mv lazygit /usr/local/bin/ && \
    rm -f lazygit_*

# lazydocker - Simple terminal UI for docker
RUN LAZYDOCKER_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/jesseduffield/lazydocker/releases/download/${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION#v}_Linux_x86_64.tar.gz" && \
    tar -xzf lazydocker_${LAZYDOCKER_VERSION#v}_Linux_x86_64.tar.gz && \
    mv lazydocker /usr/local/bin/ && \
    rm -f lazydocker_*

# dive - Docker image layer analyzer
RUN DIVE_VERSION=$(curl -s https://api.github.com/repos/wagoodman/dive/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/wagoodman/dive/releases/download/${DIVE_VERSION}/dive_${DIVE_VERSION#v}_linux_amd64.tar.gz" && \
    tar -xzf dive_${DIVE_VERSION#v}_linux_amd64.tar.gz && \
    mv dive /usr/local/bin/ && \
    rm -f dive_*

# bat - Better cat with syntax highlighting
RUN BAT_VERSION=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/sharkdp/bat/releases/download/${BAT_VERSION}/bat-${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz" && \
    tar -xzf bat-${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz && \
    mv bat-${BAT_VERSION}-x86_64-unknown-linux-musl/bat /usr/local/bin/ && \
    rm -rf bat-*

# fd - Better find
RUN FD_VERSION=$(curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/sharkdp/fd/releases/download/${FD_VERSION}/fd-${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz" && \
    tar -xzf fd-${FD_VERSION}-x86_64-unknown-linux-musl.tar.gz && \
    mv fd-${FD_VERSION}-x86_64-unknown-linux-musl/fd /usr/local/bin/ && \
    rm -rf fd-*

# fzf - Fuzzy finder
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install --bin && \
    mv ~/.fzf/bin/fzf /usr/local/bin/

# HTTPie - Modern HTTP client
RUN python3 -m venv /opt/httpie && \
    /opt/httpie/bin/pip install --no-cache-dir httpie && \
    ln -s /opt/httpie/bin/http /usr/local/bin/http && \
    ln -s /opt/httpie/bin/https /usr/local/bin/https

################################################################################
# STAGE 19: PERFORMANCE & BENCHMARKING TOOLS
################################################################################

# vegeta - HTTP load testing tool
RUN VEGETA_VERSION=$(curl -s https://api.github.com/repos/tsenart/vegeta/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/tsenart/vegeta/releases/download/${VEGETA_VERSION}/vegeta_${VEGETA_VERSION#v}_linux_amd64.tar.gz" && \
    tar -xzf vegeta_${VEGETA_VERSION#v}_linux_amd64.tar.gz && \
    mv vegeta /usr/local/bin/ && \
    rm -f vegeta_*

# hey - HTTP load generator
RUN go install github.com/rakyll/hey@latest && \
    mv /root/go/bin/hey /usr/local/bin/

# wrk - Modern HTTP benchmarking tool
RUN apk add --no-cache wrk

################################################################################
# STAGE 20: EDITOR & TERMINAL CONFIGURATION
################################################################################

# Configure tmux with modern settings
RUN cd /root && \
    git clone --single-branch https://github.com/gpakosz/.tmux.git && \
    ln -s -f .tmux/.tmux.conf && \
    cp .tmux/.tmux.conf.local .

# Configure Neovim with NvChad
RUN git clone https://github.com/NvChad/starter ~/.config/nvim

################################################################################
# STAGE 21: ADDITIONAL RECOMMENDED TOOLS
################################################################################

# kubepug - Kubernetes deprecated API scanner
RUN KUBEPUG_VERSION=$(curl -s https://api.github.com/repos/kubepug/kubepug/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/kubepug/kubepug/releases/download/${KUBEPUG_VERSION}/kubepug_linux_amd64.tar.gz" && \
    tar -xzf kubepug_linux_amd64.tar.gz && \
    mv kubepug /usr/local/bin/ && \
    rm -f kubepug_*

# pluto - Kubernetes deprecated API versions checker
RUN PLUTO_VERSION=$(curl -s https://api.github.com/repos/FairwindsOps/pluto/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/FairwindsOps/pluto/releases/download/${PLUTO_VERSION}/pluto_${PLUTO_VERSION#v}_linux_amd64.tar.gz" && \
    tar -xzf pluto_${PLUTO_VERSION#v}_linux_amd64.tar.gz && \
    mv pluto /usr/local/bin/ && \
    rm -f pluto_*

# kube-no-trouble (kubent) - Find deprecated Kubernetes APIs
RUN KUBENT_VERSION=$(curl -s https://api.github.com/repos/doitintl/kube-no-trouble/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/doitintl/kube-no-trouble/releases/download/${KUBENT_VERSION}/kubent-${KUBENT_VERSION#v}-linux-amd64.tar.gz" && \
    tar -xzf kubent-${KUBENT_VERSION#v}-linux-amd64.tar.gz && \
    mv kubent /usr/local/bin/ && \
    rm -f kubent-*

# krew - kubectl plugin manager
RUN set -x && \
    KREW_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/krew/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/kubernetes-sigs/krew/releases/download/${KREW_VERSION}/krew-linux_amd64.tar.gz" && \
    tar -xzf krew-linux_amd64.tar.gz && \
    ./krew-linux_amd64 install krew && \
    rm -f krew-linux_amd64*

ENV PATH="${PATH}:/root/.krew/bin"

# Kubebuilder - SDK for building Kubernetes APIs
RUN KUBEBUILDER_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/kubebuilder/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/kubernetes-sigs/kubebuilder/releases/download/${KUBEBUILDER_VERSION}/kubebuilder_linux_amd64" \
    -O /usr/local/bin/kubebuilder && \
    chmod +x /usr/local/bin/kubebuilder

# Skaffold - CI/CD for Kubernetes
RUN curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64 && \
    chmod +x skaffold && \
    mv skaffold /usr/local/bin/

# Starship - Cross-shell prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- --yes --bin-dir /usr/local/bin && \
    echo 'eval "$(starship init bash)"' >> /root/.bashrc 

# Telepresence - Local development against remote Kubernetes
RUN TELEPRESENCE_VERSION=$(curl -s https://api.github.com/repos/telepresenceio/telepresence/releases/latest | \
    grep tag_name | cut -d '"' -f 4) && \
    wget "https://github.com/telepresenceio/telepresence/releases/download/${TELEPRESENCE_VERSION}/telepresence-linux-amd64" \
    -O /usr/local/bin/telepresence && \
    chmod +x /usr/local/bin/telepresence

# Kustomize - Kubernetes configuration management
RUN KUSTOMIZE_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases | \
    grep tag_name | grep kustomize/v | head -1 | cut -d '"' -f 4 | cut -d '/' -f 2) && \
    wget "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" && \
    tar -xzf kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
    mv kustomize /usr/local/bin/ && \
    rm -f kustomize_*

# Jsonnet - Data templating language
RUN go install github.com/google/go-jsonnet/cmd/jsonnet@latest && \
    mv /root/go/bin/jsonnet /usr/local/bin/

# k6 extensions
RUN go install go.k6.io/xk6/cmd/xk6@latest && \
    mv /root/go/bin/xk6 /usr/local/bin/

################################################################################
# CLEANUP & FINALIZATION
################################################################################

# Clean up package cache and temporary files
RUN rm -rf /var/cache/apk/* \
    /tmp/* \
    /root/.cache \
    /root/go/pkg \
    /root/go/src

# Create useful directories
RUN mkdir -p /workspace /scripts /configs

# Set bash as default shell
SHELL ["/bin/bash", "-c"]

# Set working directory
WORKDIR /workspace

# Add version information
RUN echo "DevSecOps Multi-Tool Container" > /etc/motd && \
    echo "Built on: $(date)" >> /etc/motd && \
    echo "=====================================" >> /etc/motd && \
    echo "" >> /etc/motd

RUN adduser -D devsecops && \
    echo "devsecops ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo 'eval "$(starship init bash)"' >> /home/devsecops/.bashrc && \
    chown devsecops:devsecops /home/devsecops/.bashrc

USER devsecops

# Default command
CMD ["bash"]

################################################################################
# BUILD INFORMATION
################################################################################
# Build: docker build -t devsecops-toolkit:latest .
# Run: docker run -it --rm -v ~/.kube:/root/.kube -v $(pwd):/workspace devsecops-toolkit:latest
# Size Optimization: Use multi-stage builds for production
# Security: Run security scans with: docker scout cves <image>
################################################################################
