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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installer Python
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Installer Go
ENV GO_VERSION=1.21.0
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz

# Ajouter Go au PATH
ENV PATH="/usr/local/go/bin:${PATH}"

# Vérifier les installations
RUN go version && python3 --version && pip3 --version

# Définir le répertoire de travail
WORKDIR /app

# Commande par défaut (modifiable selon votre projet)
CMD ["bash"]
