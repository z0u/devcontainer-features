#!/bin/bash -i

set -e

PULL=${PULL:-""}

# From https://github.com/itsmechlark/features/blob/0e7c373cd84e8dfd6be03594815e4304855d3911/src/postgresql/install.sh#L24
# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

# Checks if packages are installed and installs them if not
check_packages() {
	if ! dpkg -s "$@" >/dev/null 2>&1; then
		if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
			echo "Running apt-get update..."
			apt-get update -y
		fi
		apt-get -y install --no-install-recommends "$@"
	fi
}

# make sure we have curl
check_packages ca-certificates curl

mkdir -p "$OLLAMA_MODELS"

curl https://ollama.ai/install.sh | sh

# if PULL is not empty and not equal to "none", also ollama is serving, then pull the models
if [ "$PULL" != "none" ] && [ "$PULL" != "" ]; then
    # split PULL variable into array using comma as delimiter and then pass to ollama pull
    ollama serve &
    sleep 3
    echo $PULL | tr ',' '\n' | xargs -I % sh -c "ollama pull %"
fi

chown --preserve-root --recursive "${USERNAME}:root" "$OLLAMA_MODELS"

echo 'Done!'
