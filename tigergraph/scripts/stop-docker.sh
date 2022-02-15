#!/bin/bash

set -eu
set -o pipefail

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ..

. scripts/vars.sh

docker stop ${TG_CONTAINER_NAME} || echo "No container ${TG_CONTAINER_NAME} found"
