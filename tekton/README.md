# LLM Quantizer Tekton Pipeline

This folder contains everything needed to run the [tekton](https://tekton.dev) quantizer pipeline.

This pipeline offers a typical CI/CD process, with a flow including:
 - fetching a huggingface model repository as the source
 - convert to GGUF
 - quantize
 - test a quantized model using llama.cpp
 - release quantized model to hf

## Tasks
```
├── tasks
│   ├── gguf-quantize.yml
│   ├── hf-download.yml
│   ├── hf-gguf-convert.yml
│   ├── hf-upload.yml
│   ├── llama-chat.yml
│   ├── llm-eval.yml
│   └── prepare-release.yml
```

## Pipelines

```
├── pipelines
│   └── llama-quantizer.yml
```

## PipelineRuns

```
├── pipelineRuns
│   └── run-llama-quantizer.yml
```
