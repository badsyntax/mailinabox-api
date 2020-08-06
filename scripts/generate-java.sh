#!/usr/bin/env bash

PACKAGE_VERSION=${PACKAGE_VERSION:-"0.0.0"}

JAVA_POST_PROCESS_FILE="$(npm bin)/prettier --write --config ./.prettierrc.java.json" \
$(npm bin)/openapi-generator generate \
  -i schema/mailinabox.yml \
  -g java \
  -t templates/java \
  -o clients/java \
  --additional-properties=apiPackage=com.mailinabox.api,library=jersey2,modelPackage=com.mailinabox.api.model \
  --enable-post-process-file \
  --generate-alias-as-model \
  --git-user-id=badsyntax \
  --git-repo-id=mailinabox-api-java \
  --git-host=github.com \
  --invoker-package=com.mailinabox \
  --artifact-id=mailinabox-api \
  --artifact-version="$PACKAGE_VERSION" \
