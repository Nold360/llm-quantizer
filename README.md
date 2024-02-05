# LLM Quantizer Pipeline

Basic bash script using llama.cpp & huggingface-cli in a container. 

## Pipeline Steps
  1. Download `SOURCE` Model from Huggingface
  2. Quantize Model using llama.cpp quantizer (See `${QUANTS}`)
  3. Add `FOOTER.md` to original README.md using envsubst
  4. Upload quantized model to HF

## Required Variables
  - `HF_TOKEN`: Huggingface (write) API Token
  - `SOURCE`: Source Model from HF, format: `org/moden-name`
  - `ORG`: User/Organization used to reupload quantized model

