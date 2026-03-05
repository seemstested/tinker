#!/bin/bash
# AI Deep Dive - Experiment 1: Memory Profiling & Layer Offloading
# Purpose: Understand how VRAM usage scales with GPU layers

MODEL="$HOME/llama-models/Qwen3-4B-Q4_K_M.gguf"
LLAMA_BIN="$HOME/llama.cpp/build/bin"
PROMPT="Explain quantum computing in simple terms"

echo "=========================================="
echo "EXPERIMENT 1: Memory Profiling"
echo "Model: Qwen3-4B-Q4_K_M.gguf"
echo "GPU: RTX 3050 Laptop (4GB VRAM)"
echo "=========================================="
echo ""

# Function to run test with specific GPU layers
run_test() {
    local ngl=$1
    echo "--- Testing with -ngl $ngl (GPU layers) ---"
    
    # Monitor nvidia-smi before
    echo "VRAM before:"
    nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | head -1
    
    # Run llama-bench for quick measurement
    timeout 30 $LLAMA_BIN/llama-bench \
        -m "$MODEL" \
        -ngl $ngl \
        -p 512 \
        -n 128 \
        2>&1 | grep -E "(load|ms/tok|CUDA)" || echo "Test completed or timeout"
    
    # Monitor nvidia-smi after
    echo "VRAM after:"
    nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | head -1
    echo ""
}

# Test different GPU layer configurations
echo "Testing various GPU layer configurations..."
echo ""

# 0 layers (CPU only)
run_test 0

# 5 layers
echo "Waiting for VRAM to clear..."
sleep 5
run_test 5

# 10 layers
echo "Waiting for VRAM to clear..."
sleep 5
run_test 10

# 15 layers
echo "Waiting for VRAM to clear..."
sleep 5
run_test 15

# 20 layers (will likely OOM)
echo "Waiting for VRAM to clear..."
sleep 5
echo "--- Testing with -ngl 20 (may OOM) ---"
timeout 30 $LLAMA_BIN/llama-bench \
    -m "$MODEL" \
    -ngl 20 \
    -p 512 \
    -n 128 \
    2>&1 | tail -20

echo ""
echo "=========================================="
echo "Analysis complete!"
echo "=========================================="
