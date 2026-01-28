FROM alpine@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS prefetch

WORKDIR /tmp

RUN set -ex \
 && apk add --no-cache \
      curl \
      unzip \
 && curl -sSfLo vault.zip "https://releases.hashicorp.com/vault/1.18.2/vault_1.18.2_linux_amd64.zip" \
 && unzip vault.zip


FROM quay.io/argoproj/argocd:v3.2.6@sha256:64e4239359438fb0ad42d46ae2061daa841ae52d4e63f94017929f7e26dd51b2

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
