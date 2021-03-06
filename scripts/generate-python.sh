#!/usr/bin/env bash

# pip install black

PACKAGE_VERSION=${PACKAGE_VERSION:-"0.0.0"}

SCHEMA="$(npm config get tmp)/mailinabox.yml"
curl -s https://raw.githubusercontent.com/mail-in-a-box/mailinabox/master/api/mailinabox.yml --output "$SCHEMA"

BLACK_PATH=$(which black)

PYTHON_POST_PROCESS_FILE="$BLACK_PATH" \
"$(npm bin)"/openapi-generator-cli generate \
  -i "$SCHEMA" \
  -g python \
  -t templates/python \
  -o clients/python \
  --additional-properties=projectName=mailinabox-api,packageName=mailinabox_api,packageVersion="$PACKAGE_VERSION",library=urllib3,packageUrl=https://github.com/badsyntax/mailinabox-api-py \
  --enable-post-process-file \
  --generate-alias-as-model \
  --git-user-id=badsyntax \
  --git-repo-id=mailinabox-api-py \
  --git-host=github.com
