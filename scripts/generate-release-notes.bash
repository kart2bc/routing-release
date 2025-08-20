#!/bin/bash

set -eu
set -o pipefail

THIS_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CI="${THIS_FILE_DIR}/../../wg-app-platform-runtime-ci"
. "$CI/shared/helpers/release-note-helpers.bash"
. "$CI/shared/helpers/git-helpers.bash"
REPO_NAME=$(git_get_remote_name)
REPO_PATH="${THIS_FILE_DIR}/../"
unset THIS_FILE_DIR


ROUTING_RELEASE_START_REF="${1}";
ROUTNIG_RELEASE_END_REF="${2}";
GO_MOD_LOCATION="src/code.cloudfoundry.org/go.mod";
BLOBS_LOCATION="config/blobs.yml";

get_non_bot_commits "${ROUTING_RELEASE_START_REF}" "${ROUTNIG_RELEASE_END_REF}"
echo ""

START_REF_ROUTING_API=$(git rev-parse "${ROUTING_RELEASE_START_REF}:src/code.cloudfoundry.org/routing-api")
END_REF_ROUTING_API=$(git rev-parse "${ROUTNIG_RELEASE_END_REF}:src/code.cloudfoundry.org/routing-api")
pushd src/code.cloudfoundry.org/routing-api > /dev/null
  get_non_bot_commits "${START_REF_ROUTING_API}" "${END_REF_ROUTING_API}" "routing-api"
popd > /dev/null

echo ""
display_blob_change_info "${ROUTING_RELEASE_START_REF}" "${ROUTNIG_RELEASE_END_REF}" "${BLOBS_LOCATION}"
echo ""
display_go_mod_diff "${ROUTING_RELEASE_START_REF}" "${ROUTNIG_RELEASE_END_REF}" "${GO_MOD_LOCATION}"
echo ""
display_go_mod_diff "${ROUTING_RELEASE_START_REF}" "${ROUTNIG_RELEASE_END_REF}" "src/routing_utils/nats_client/go.mod" "nats-client"
