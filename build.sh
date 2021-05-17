#!/bin/bash

# This script allows us to parameterise the terraform blocks which do not normally take variables.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ ! -e "$SCRIPT_DIR/.env" ]; then
    echo "Could not find .env file for environment variables."
    exit 1
fi

if [ "$1" == "--new" ]; then
    echo "Generating new cloud object storage (cos) bucket prefix"
    source "${SCRIPT_DIR}/.env"
    PREFIX=$(tr -dc 0-9 </dev/urandom | head -c 8 ; echo '')
    BUCKET_NAME=$(echo "${TF_VAR_shared_bucket}" | sed "s/^\d+-//")
    FULL_BUCKET_NAME="${PREFIX}-${BUCKET_NAME}"
    echo "Setting TF_VAR_shared_bucket to '${FULL_BUCKET_NAME}'"

    # purge the .env file and then rewrite it
    cat "${SCRIPT_DIR}/.env" | grep -v "TF_VAR_shared_bucket" > "${SCRIPT_DIR}/.env.tmp"
    echo "export TF_VAR_shared_bucket=\"${FULL_BUCKET_NAME}\"" >> "${SCRIPT_DIR}/.env.tmp"
    mv "${SCRIPT_DIR}/.env.tmp" "${SCRIPT_DIR}/.env"

    echo "Reloading environment variables"
    source "${SCRIPT_DIR}/.env"
fi

for template in $(find ${SCRIPT_DIR} -type f -iname "*\.tf\.template")
do
    DIR=$(dirname "$template")
    TEMPLATE_NAME=$(basename "$template")
    COMPILED_NAME=$(echo "$TEMPLATE_NAME" | sed "s/.template$//")
    echo "Entering $DIR"
    pushd "$DIR" > /dev/null
    echo "  Building $COMPILED_NAME"
    unset "${!TF_@}"
    if [ ! -e ".env" ]; then
        if [ -e ".env.template" ]; then
            echo "  Copying over environment template"
            cp ".env.template" ".env"
        else
            popd > /dev/null
            cd "$DIR"
            echo "[FATAL] Environment file not found in this directory and no template exists."
            exit 1
        fi
    fi
    source .env
    echo "  Using variables:"
    env | grep "TF_" | sed "s/^/    /"
    cat ${TEMPLATE_NAME} | envsubst > $COMPILED_NAME
    if [ $? != 0 ]; then
        popd > /dev/null
        cd "$DIR"
        echo "[FATAL] Failed to compile terraform template."
        exit 1
    fi
    echo "  Creating/Updating $COMPILED_NAME"
    popd > /dev/null
done
