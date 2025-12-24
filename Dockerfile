FROM alpine@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62 AS prefetch

WORKDIR /tmp

RUN set -ex \
 && apk add --no-cache \
      curl \
      unzip \
 && curl -sSfLo vault.zip "https://releases.hashicorp.com/vault/1.18.2/vault_1.18.2_linux_amd64.zip" \
 && unzip vault.zip


FROM quay.io/argoproj/argocd:v3.2.3@sha256:9ab6baab65a6b283044a7d7b7dbe50f589564de9c8898d67c77d84b2b5df46bc

USER root

RUN apt-get update \
 && apt-get install -y \
      git-crypt \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && mv /usr/bin/git /usr/bin/git.bin

COPY                  git-wrapper.sh  /usr/bin/git
COPY --from=prefetch  /tmp/vault      /usr/bin/vault

USER 999
