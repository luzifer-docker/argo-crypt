FROM alpine@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS prefetch

WORKDIR /tmp

RUN set -ex \
 && apk add --no-cache \
      curl \
      unzip \
 && curl -sSfLo vault.zip "https://releases.hashicorp.com/vault/1.18.2/vault_1.18.2_linux_amd64.zip" \
 && unzip vault.zip


FROM quay.io/argoproj/argocd:v3.0.11@sha256:1cb4ede2fc4a6332c128d9ba29d19e8cb5b76f9260dc47550a4b3b154269ff86

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
