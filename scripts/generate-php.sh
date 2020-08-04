#!/usr/bin/env bash

PACKAGE_VERSION=${PACKAGE_VERSION:-"0.0.0"}

PHP_POST_PROCESS_FILE="$(npm bin)/prettier --write --config ./.prettierrc.php.json" \
$(npm bin)/openapi-generator generate \
  -i schema/mailinabox.yml \
  -g php \
  -t templates/php \
  -o clients/php \
  --additional-properties=variableNamingConvention=camelCase \
  --enable-post-process-file \
  --package-name=MailInABoxAPI \
  --invoker-package='MailInABoxAPI\\Client' \
  --generate-alias-as-model \
  --git-user-id=badsyntax \
  --git-repo-id=mailinabox-api-php \
  --git-host=github.com \
  --artifact-id=mailinabox/mailinabox-api \
  --artifact-version="$PACKAGE_VERSION" \
