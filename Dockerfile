FROM alpine@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS prefetch

WORKDIR /tmp

RUN set -ex \
 && apk add --no-cache \
      curl \
      unzip \
 && curl -sSfLo vault.zip "https://releases.hashicorp.com/vault/1.18.2/vault_1.18.2_linux_amd64.zip" \
 && unzip vault.zip


FROM quay.io/argoproj/argocd:v3.4.2@sha256:c612d570cb6d6ff29afb72932c1bfe98a1ecc234df50f8ea4873fb7066e760fc

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
