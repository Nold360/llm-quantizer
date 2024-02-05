#!/bin/bash
set -u
set -e
LLAMA_PATH=/app
export HF_HUB_ENABLE_HF_TRANSFER=1
export HF_HUB_DISABLE_TELEMETRY=1

# We need these in envsubst later..
export MODEL_NAME=$(echo $SOURCE | awk -F/ '{print $NF}')
export CREATOR=$(echo $SOURCE | awk -F/ '{print $1}')

#HF_TOKEN=
MODEL_SUFFIX="GGUF"
huggingface-cli login --token ${HF_TOKEN} --add-to-git-credential

# MODEL_DIR=/data
# QUANTS="Q2_K Q5_K_M Q4_K_M Q8_0"
# THREADS=16
# VOCAB_TYPE=hfft

PATH=$PATH:${LLAMA_PATH}

# Input can be path to model, model name or git url
#export SOURCE=$1
MODEL_PATH="${MODEL_DIR}/${MODEL_NAME}"
CACHE_DIR=${MODEL_DIR}/.cache
OUTPUT_DIR=${MODEL_DIR}/quants/${MODEL_NAME}
mkdir -p ${OUTPUT_DIR} ${CACHE_DIR}

# 1. Obtain model
echo " ---> Obtaining Model: ${MODEL_NAME}"
huggingface-cli download --cache-dir ${CACHE_DIR} --local-dir "${MODEL_PATH}" "${SOURCE}"

# 2. Convert Model
echo "  ---> Converting Model to gguf"
if [ -f "${MODEL_PATH}/ggml-model-f16.gguf" ] ; then
  echo " ----> Skipping Converting..."
else
  python3 ${LLAMA_PATH}/convert-hf-to-gguf.py ${MODEL_PATH} || \
    python3 ${LLAMA_PATH}/convert.py ${MODEL_PATH} --pad-vocab --vocab-type ${VOCAB_TYPE}
fi
  
# 3. Quantize Model
for quant in ${QUANTS}; do
  if [ -f "${OUTPUT_DIR}/${MODEL_NAME}_${quant}.gguf" ] ; then
    echo " ---> Skipping Quant ${quant}..."
  else
    echo " ---> Quantizing to ${quant}..."
    quantize "${MODEL_PATH}/ggml-model-f16.gguf" "${OUTPUT_DIR}/${MODEL_NAME}_${quant}.gguf" "${quant}" "$THREADS"
  fi
done

# 4. Release Quant
echo " ---> Releasing Quantized Model as ${ORG}/${MODEL_NAME}-${MODEL_SUFFIX} ..."
cp $(find ${MODEL_PATH} -maxdepth 1 -type f -iname readme.md | head -1) ${OUTPUT_DIR}/README.md

cat FOOTER.md | envsubst >> ${OUTPUT_DIR}/README.md

huggingface-cli upload --repo-type model "${ORG}/${MODEL_NAME}-${MODEL_SUFFIX}" "${OUTPUT_DIR}" .

echo "Done."
