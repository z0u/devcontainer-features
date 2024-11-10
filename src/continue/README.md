
# Continue / Ollama (continue)

Configures Continue to use local models hosted in Ollama

## Example Usage

```json
"features": {
    "ghcr.io/z0u/devcontainer-features/continue:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| chatModel | The model to use for chat completions | string | llama3.2:3b |
| autocompleteModel | The model to use for autocompletion | string | starcoder2:3b |
| embeddingModel | The model to use to generate embeddings | string | nomic-embed-text |

## Customizations

### VS Code Extensions

- `Continue.continue`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/z0u/devcontainer-features/blob/main/src/continue/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
