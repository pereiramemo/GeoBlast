#!/bin/bash

set -o errexit

# readlink -m substitute 
function realpath() {
  CURRENT_DIR=$(pwd)
  DIR=$(dirname ${1})
  FILE=$(basename ${1})
  cd "${DIR}"
  echo "$(pwd)/${FILE}"
  cd "${CURRENT_DIR}"
}


if [[ "${1}" == "--help" ]]; then
  docker run \
  --detach=false \
  --rm \
  --user $(id -u):$(id -g) \
  epereira/geoblast:latest --help
  exit 0
fi

if [[ "$#" -lt 2 ]]; then
  echo -e "Failed. Missing parameters.\nSee geoblast_runner.sh --help"
  exit
fi

if [[ -f "${1}" ]]; then
  INPUT_FILE=$(basename ${1})
  INPUT_DIR_HOST=$(dirname $(realpath ${1}))
  shift
fi

if [[ ! -f "${1}" ]]; then
  OUTPUT_DIR=$(basename ${1})
  OUTPUT_DIR_HOST=$(dirname $(realpath ${1}))
  shift
fi

# if [[ "${1}" != "--"* ]]; then
#   echo -e "Positional parameters were not processed correctly.\nSee geoblast_runner.sh --help"
#   exit
# fi

# Links within the container
CONTAINER_SRC_DIR=/input
CONTAINER_DST_DIR=/output

docker run \
--volume /etc/passwd:/etc/passwd:ro \
--volume /etc/group:/etc/group:ro \
--volume ${INPUT_DIR_HOST}:${CONTAINER_SRC_DIR}:rw \
--volume ${OUTPUT_DIR_HOST}:${CONTAINER_DST_DIR}:rw \
--detach=false \
--rm \
--user $(id -u):$(id -g) \
epereira/geoblast:latest \
--input "${CONTAINER_SRC_DIR}/${INPUT_FILE}" \
--output_dir "${OUTPUT_DIR}" \
$@
