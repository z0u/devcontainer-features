#!/bin/bash -i

set -e

PULL=${PULL:-""}

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

tee "${OLLAMA_MODELS}/container-post-start.sh" > /dev/null << EOF
#!/bin/sh
set -e
chown --recursive "$_CONTAINER_USER:root" "$OLLAMA_MODELS"
EOF
chmod +x "${OLLAMA_MODELS}/container-post-start.sh"

echo 'Done!'
