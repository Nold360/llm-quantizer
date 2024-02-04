FROM ghcr.io/ggerganov/llama.cpp:full

RUN pip install -U "huggingface_hub[cli]"
COPY quantizer.sh /
USER 65534
ENTRYPOINT
