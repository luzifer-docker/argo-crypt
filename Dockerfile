FROM alpine AS prefetch

WORKDIR /tmp

RUN set -ex \
 && apk add --no-cache \
      curl \
      unzip \
 && curl -sSfLo vault.zip "https://releases.hashicorp.com/vault/1.17.5/vault_1.17.5_linux_amd64.zip" \
 && unzip vault.zip


FROM quay.io/argoproj/argocd:v2.12.6

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
