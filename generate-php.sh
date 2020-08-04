#!/usr/bin/env bash

PHP_POST_PROCESS_FILE="$(npm bin)/prettier --write --config ./.prettierrc.php.json" \
$(npm bin)/openapi-generator generate \
  -i schema/mailinabox.yml \
  -g php \
  -o clients/php \
  --additional-properties=variableNamingConvention=camelCase \
  --enable-post-process-file \
  --package-name=MailInABoxAPI \
  --invoker-package='MailInABoxAPI\\Client' \
  --generate-alias-as-model
