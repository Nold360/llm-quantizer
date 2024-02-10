# LLM Quantizer Pipeline

Simple LLM quantization pipeline using woodpecker-ci, llama.cpp & huggingface-cli in a container. 

## Pipeline Steps
  1. Download `MODEL_ID` Model from Huggingface
  2. Convert Model to GGUF f16
  3. Quantize Model using llama.cpp quantizer (See `$QUANTS`)
  4. Add `FOOTER.md` to original README.md using envsubst
  5. Release Quantized Model to HF

## Required Variables
  - `HF_TOKEN`: Huggingface (write) API Token
  - `MODEL_ID`: Source Model from HF, format: `org/model-name`
  - `ORG`: User/Organization used to reupload quantized model

