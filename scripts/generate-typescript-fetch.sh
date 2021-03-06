#!/usr/bin/env bash

PACKAGE_VERSION=${PACKAGE_VERSION:-"0.0.0"}
CLIENT_PATH=./clients/typescript-fetch

SCHEMA="$(npm config get tmp)/mailinabox.yml"
curl -s https://raw.githubusercontent.com/mail-in-a-box/mailinabox/master/api/mailinabox.yml --output "$SCHEMA"

TS_POST_PROCESS_FILE="$(npm bin)/prettier --write --config ./.prettierrc.ts.json" \
"$(npm bin)"/openapi-generator-cli generate \
  -i "$SCHEMA" \
  -g typescript-fetch \
  -t templates/typescript-fetch \
  -o "$CLIENT_PATH" \
  --additional-properties=typescriptThreePlus=true,npmName=mailinabox-api,npmVersion="$PACKAGE_VERSION" \
  --enable-post-process-file \
  --generate-alias-as-model \
  --git-user-id=badsyntax \
  --git-repo-id=mailinabox-api-ts \
  --git-host=github.com
