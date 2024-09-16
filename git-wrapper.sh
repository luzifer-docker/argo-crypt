#!/bin/bash

$(dirname $0)/git.bin "$@"
EC=$?

if [ "$1" = "checkout" -a -f ".git-crypt-key" -a ! "$GIT_CRYPT_RUNNING" = "true" ]; then
  export GIT_CRYPT_RUNNING=true
  export VAULT_TOKEN=$(vault write -field=token auth/approle/login role_id="${VAULT_ROLE_ID:-}")

  tmpfile=$(mktemp)
  vault read -field=key "secret/git-crypt/$(<.git-crypt-key)" | base64 -d >${tmpfile}
  git-crypt unlock ${tmpfile}
  rm ${tmpfile}
fi

exit $EC
