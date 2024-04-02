#!/bin/bash

set -e

REPOSITORY_PATH="$(git rev-parse --show-toplevel)"
TEST_ROOT_PATH="$REPOSITORY_PATH/tests"
DEFAULT_TESTS_PATH="$TEST_ROOT_PATH/default-tests"
CHECK_ONLY_FLAG=$([[ $CHECK_ONLY == "true" ]] && echo "--checkonly" || echo "")
CMD_DEPLOY=("--manifest ./package/package.xml")

cd $REPOSITORY_PATH

echo "\n#### Initiate deploy in Organization #####"
echo "Running source deploy command with parameters -u "$USERNAME" --testlevel $TEST_LEVEL $CHECK_ONLY_FLAG " 

DEPLOYMENT_INFO="$(sfdx force:source:deploy -u "$USERNAME" ${CMD_DEPLOY[@]} --testlevel $TEST_LEVEL --runtests $(<$DEFAULT_TESTS_PATH) $CHECK_ONLY_FLAG  --wait 0 --json)"
echo $DEPLOYMENT_INFO >> ./deployment_info.json
echo ./deployment_info.json
DEPLOYMENT_ID="$(jq -r '.result.id' ./deployment_info.json)" 
sfdx force:source:deploy:report --wait 60 -i ${DEPLOYMENT_ID} -u "$USERNAME" --verbose 
 