#!/bin/bash
# AI Deep Dive - Experiment 3: KV Cache Analysis
# Purpose: Understand how context window affects memory

MODEL="$HOME/llama-models/Qwen3-4B-Q4_K_M.gguf"
LLAMA_BIN="$HOME/llama.cpp/build/bin"

echo "=========================================="
echo "EXPERIMENT 3: KV Cache Memory Analysis"
echo "=========================================="
echo ""
echo "KV cache grows with context length"
echo "Testing different context sizes..."
echo ""

# Function to test with specific context size
test_context() {
    local ctx=$1
    echo "--- Context size: $ctx tokens ---"
    
    # Create prompt of approximate size
    local prompt_len=$((ctx / 2))
    local prompt=$(python3 -c "print('word ' * $prompt_len)")
    
    echo "Prompt tokens: ~$prompt_len"
    
    # Monitor VRAM
    echo "VRAM before:"
    nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | head -1
    
    # Run generation
    timeout 20 $LLAMA_BIN/llama-cli \
        -m "$MODEL" \
        -ngl 10 \
        -c $ctx \
        -n 50 \
        -p "Continue: $prompt" \
        --no-display-prompt \
        2>&1 | grep -E "(llama_new_context|llama_kv_cache|perplexity|tokens)" || echo "Run complete"
    
    echo "VRAM after:"
    nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | head -1
    echo ""
}

# Test different context sizes
test_context 256
echo "Waiting..."
sleep 3

test_context 512
echo "Waiting..."
sleep 3

test_context 1024
echo "Waiting..."
sleep 3

test_context 2048

echo "=========================================="
echo "Analysis:"
echo "- KV cache memory = 2 × layers × heads × head_dim × seq_len × 2 bytes (fp16)"
echo "- For 4B model with 32 layers, 2048 ctx = ~256MB additional VRAM"
echo "=========================================="
