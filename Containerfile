FROM python:3.10

RUN pip install -U "huggingface_hub[cli]" hf_transfer && \
    apt-get update && apt-get install -y --no-install-recommends gettext-base && \
    apt-get clean
USER 65534
