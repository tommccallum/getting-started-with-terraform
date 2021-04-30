#!/bin/bash

# This script allows us to parameterise the terraform blocks which do not normally take variables.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

for template in "$(find ${SCRIPT_DIR} -type f -iname "*\.tf\.template")"
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
