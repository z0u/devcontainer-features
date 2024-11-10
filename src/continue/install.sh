#!/bin/bash -i

set -e

mkdir -p /usr/local/share/continue

cat << EOF > "/usr/local/share/continue/models.txt"
$CHATMODEL
$AUTOCOMPLETEMODEL
$EMBEDDINGMODEL
EOF

cat << EOF > "/usr/local/share/continue/config.json"
{
  "models": [
    {
      "title": "$CHATMODEL",
      "provider": "ollama",
      "model": "$CHATMODEL"
    }
  ],
  "tabAutocompleteModel": {
    "title": "$AUTOCOMPLETEMODEL",
    "provider": "ollama",
    "model": "$AUTOCOMPLETEMODEL"
  },
  "embeddingsProvider": {
    "provider": "ollama",
    "model": "$EMBEDDINGMODEL"
  }
}
EOF

cat << "EOF" > "/usr/local/share/continue/init.sh"
#!/bin/sh
set -e
cat /usr/local/share/continue/models.txt | xargs -I % sh -x -c "ollama pull %"
mkdir -p ~/.continue
cp -v /usr/local/share/continue/config.json ~/.continue/config.json
EOF
chmod +x "/usr/local/share/continue/init.sh"

.continuerc.json
