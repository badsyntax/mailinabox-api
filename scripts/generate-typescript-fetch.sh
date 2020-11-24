#!/usr/bin/env bash

PACKAGE_VERSION=${PACKAGE_VERSION:-"0.0.0"}
CLIENT_PATH=./clients/typescript-fetch

TS_POST_PROCESS_FILE="$(npm bin)/prettier --write --config ./.prettierrc.ts.json" \
"$(npm bin)"/openapi-generator-cli generate \
  -i schema/mailinabox.yml \
  -g typescript-fetch \
  -t templates/typescript-fetch \
  -o "$CLIENT_PATH" \
  --additional-properties=typescriptThreePlus=true,npmName=mailinabox-api,npmVersion="$PACKAGE_VERSION" \
  --enable-post-process-file \
  --generate-alias-as-model \
  --git-user-id=badsyntax \
  --git-repo-id=mailinabox-api-ts \
  --git-host=github.com
