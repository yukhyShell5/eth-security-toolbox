# Utiliser une image de base minimale
FROM debian:bullseye-slim

# Définir les métadonnées
LABEL maintainer="votre.email@example.com"
LABEL description="Image Debian Bullseye avec Go et Python"

# Installer les dépendances essentielles
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    git \
    build-essential \
    ca-certificates \
    gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Configurer Git avec une identité par défaut
RUN git config --global user.name "Docker User" \
    && git config --global user.email "docker@example.com"


# Installer Python
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Installer Go
ENV GO_VERSION=1.22.0
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz

# Ajouter Go au PATH
ENV PATH="/usr/local/go/bin:${PATH}"


# Installer Rust via rustup
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y \
    && . $HOME/.cargo/env \
    && rustup update

# Ajouter Rust au PATH
ENV PATH="/root/.cargo/bin:${PATH}"


# Installer solc (via solc-select)
RUN pip3 install solc-select \
    && solc-select install all \
    && solc-select use 0.8.0


# Installer Foundry
RUN curl -L https://foundry.paradigm.xyz | bash \
    && /root/.foundry/bin/foundryup

# Ajouter Foundry au PATH
ENV PATH="/root/.foundry/bin:${PATH}"

# Installer Crytic-compile et ses dépendances
RUN pip3 install crytic-compile

# Installer Medusa
RUN git clone https://github.com/crytic/medusa \
    && cd medusa \
    && go build -trimpath -o medusa \
    && mv medusa /usr/local/bin/ \
    && cd .. \
    && rm -rf medusa

# Vérifier les installations
RUN go version \
    && python3 --version \
    && pip3 --version \
    && rustc --version \
    && solc --version \
    && forge --version \
    && cast --version \
    && anvil --version \
    && medusa --version \
    && crytic-compile --version


# Définir le répertoire de travail
WORKDIR /app

# Commande par défaut (modifiable selon votre projet)
CMD ["bash"]
