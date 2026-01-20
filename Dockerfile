FROM node:24-bookworm

# ---- System deps + CLI utilities ----
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    git \
    unzip \
    wget \
    gnupg \
    lsb-release \
    software-properties-common \
    # Playwright deps
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpangocairo-1.0-0 \
    libpango-1.0-0 \
    libgtk-3-0 \
    libx11-xcb1 \
    fonts-liberation \
    xdg-utils \
    # CLI utilities
    jq \
    make \
    vim \
    ripgrep \
    fd-find \
    # Networking tools
    lsof \
    net-tools \
    iproute2 \
    dnsutils \
    iputils-ping \
    traceroute \
    tcpdump \
    # Binary debugging
    strace \
    gdb \
    binutils \
    # Database clients
    postgresql-client \
    redis-tools \
    # Build deps for bash
    gcc \
    libncurses-dev \
    libreadline-dev \
    --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

# ---- Bash 5.3 (latest) ----
ENV BASH_VERSION=5.3
RUN curl -fsSL https://ftp.gnu.org/gnu/bash/bash-${BASH_VERSION}.tar.gz | tar -xz -C /tmp \
 && cd /tmp/bash-${BASH_VERSION} \
 && ./configure --prefix=/usr/local \
 && make -j$(nproc) \
 && make install \
 && rm -rf /tmp/bash-${BASH_VERSION} \
 && ln -sf /usr/local/bin/bash /bin/bash

# fd is installed as fdfind on Debian, create symlink
RUN ln -s $(which fdfind) /usr/local/bin/fd

# ---- Python ----
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    --no-install-recommends \
 && rm -rf /var/lib/apt/lists/* \
 && ln -s /usr/bin/python3 /usr/local/bin/python

# ---- Go ----
ENV GO_VERSION=1.25.6
RUN ARCH=$(dpkg --print-architecture) \
 && curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz \
  | tar -C /usr/local -xz
ENV PATH="/usr/local/go/bin:${PATH}"

# ---- Rust ----
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH="/usr/local/cargo/bin:${PATH}"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable

# ---- yq (YAML processor) ----
RUN ARCH=$(dpkg --print-architecture) \
 && curl -fsSL https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${ARCH} -o /usr/local/bin/yq \
 && chmod +x /usr/local/bin/yq

# ---- Docker CLI ----
RUN ARCH=$(dpkg --print-architecture) \
 && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
 && echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list \
 && apt-get update && apt-get install -y docker-ce-cli --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

# ---- kubectl ----
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | gpg --dearmor -o /usr/share/keyrings/kubernetes-apt-keyring.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /" > /etc/apt/sources.list.d/kubernetes.list \
 && apt-get update && apt-get install -y kubectl --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

# ---- AWS CLI v2 ----
RUN ARCH=$(uname -m) \
 && curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o /tmp/awscliv2.zip \
 && unzip -q /tmp/awscliv2.zip -d /tmp \
 && /tmp/aws/install \
 && rm -rf /tmp/aws /tmp/awscliv2.zip

# ---- Google Cloud CLI ----
RUN curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
 && apt-get update && apt-get install -y google-cloud-cli --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

# ---- Azure CLI ----
RUN ARCH=$(dpkg --print-architecture) \
 && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg \
 && echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ bookworm main" > /etc/apt/sources.list.d/azure-cli.list \
 && apt-get update && apt-get install -y azure-cli --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

# ---- Terraform ----
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com bookworm main" > /etc/apt/sources.list.d/hashicorp.list \
 && apt-get update && apt-get install -y terraform --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

# ---- Create non-root user ----
RUN useradd -m -s /usr/local/bin/bash claude \
 && mkdir -p /app \
 && chown claude:claude /app \
 && mkdir -p /Users/tomas \
 && ln -s /home/claude/.claude /Users/tomas/.claude

# ---- Playwright ----
ENV PLAYWRIGHT_BROWSERS_PATH=/home/claude/.cache/ms-playwright
RUN npm cache clean --force \
 && npm install -g @playwright/test \
 && npx playwright install chromium \
 && mkdir -p /opt/google/chrome \
 && ln -s /home/claude/.cache/ms-playwright/chromium-1200/chrome-linux/chrome /opt/google/chrome/chrome \
 && chown -R claude:claude /home/claude/.cache

# ---- Claude Code (as non-root user) ----
USER claude
RUN curl -fsSL https://claude.ai/install.sh | bash
ENV PATH="/home/claude/.local/bin:${PATH}"

# ---- Claude config + plugins ----
USER root
COPY config/settings.json /home/claude/.claude/settings.json
COPY plugins/simple-statusline.sh /home/claude/.claude/simple-statusline.sh
COPY config/.bashrc /home/claude/.bashrc
COPY config/CLAUDE.md /home/claude/CLAUDE.md
RUN chmod +x /home/claude/.claude/simple-statusline.sh \
 && chown -R claude:claude /home/claude/.claude /home/claude/.bashrc /home/claude/CLAUDE.md

# ---- Test script ----
COPY test-installs.sh /usr/local/bin/test-installs
RUN chmod +x /usr/local/bin/test-installs

# ---- Switch to non-root user ----
USER claude
WORKDIR /app

# ---- Default: bash shell ----
ENTRYPOINT ["/usr/local/bin/bash"]
