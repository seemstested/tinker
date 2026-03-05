# Tinker

Hands-on exploration of local Large Language Models. Deep dive into how LLMs work under the hood using llama.cpp.

## Quick Start

```bash
git clone https://github.com/yourusername/tinker.git
cd tinker
./run.sh
```

## What's Inside

- **Memory Profiling** - Understand VRAM usage with GPU layer offloading
- **Tokenization** - See how text becomes tokens
- **KV Cache** - Analyze context window impact
- **Quantization** - Compare Q-levels (Q2_K to Q8_0)
- **Sampling** - Explore temperature, top-p, top-k strategies

## Requirements

- NVIDIA GPU with CUDA (tested on RTX 3050 4GB)
- llama.cpp (CUDA build)
- GGUF model (e.g., Qwen3-4B-Q4_K_M.gguf)

## Why Tinker?

The best way to understand AI is to run it locally, break things, and see what happens.

## License

MIT
# tinker
