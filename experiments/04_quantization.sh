#!/bin/bash
# AI Deep Dive - Experiment 4: Quantization Comparison
# Purpose: Compare different quantization levels

LLAMA_BIN="$HOME/llama.cpp/build/bin"
MODEL_DIR="$HOME/llama-models"

echo "=========================================="
echo "EXPERIMENT 4: Quantization Comparison"
echo "=========================================="
echo ""

# Check available models
echo "Available models:"
ls -lh $MODEL_DIR/*.gguf 2>/dev/null || echo "No models found in $MODEL_DIR"
echo ""

# If we have multiple quantizations, compare them
if [ $(ls $MODEL_DIR/*.gguf 2>/dev/null | wc -l) -gt 1 ]; then
    echo "Comparing different quantization levels..."
    echo ""
    
    for model in $MODEL_DIR/*.gguf; do
        echo "----------------------------------------"
        echo "Model: $(basename $model)"
        echo "Size: $(du -h $model | cut -f1)"
        
        # Test perplexity (lower is better)
        echo "Running perplexity test (sample)..."
        timeout 60 $LLAMA_BIN/llama-perplexity \
            -m "$model" \
            -ngl 10 \
            -f /dev/null \
            2>&1 | tail -5 || echo "Test timeout or error"
        
        # Test speed
        echo "Testing generation speed..."
        timeout 30 $LLAMA_BIN/llama-bench \
            -m "$model" \
            -ngl 10 \
            -p 512 \
            -n 128 \
            2>&1 | grep "ms/tok" || echo "Benchmark error"
        
        echo ""
    done
else
    echo "Only one model found. To compare quantizations:"
    echo "1. Download different Q-levels of same model"
    echo "2. Or quantize existing model:"
    echo ""
    echo "Example quantization commands:"
    echo "  $LLAMA_BIN/llama-quantize $MODEL_DIR/Qwen3-4B-Q4_K_M.gguf $MODEL_DIR/Qwen3-4B-Q3_K_M.gguf Q3_K_M"
    echo "  $LLAMA_BIN/llama-quantize $MODEL_DIR/Qwen3-4B-Q4_K_M.gguf $MODEL_DIR/Qwen3-4B-Q5_K_M.gguf Q5_K_M"
    echo ""
    echo "Available quantization types:"
    $LLAMA_BIN/llama-quantize --help 2>&1 | grep -A 20 "allowed quantization"
fi

echo "=========================================="
echo "Quantization Guide:"
echo "Q2_K = smallest, lowest quality"
echo "Q3_K = good compression, acceptable quality"
echo "Q4_K = balanced (recommended)"
echo "Q5_K = high quality, larger"
echo "Q6_K/Q8_0 = near-lossless, largest"
echo "=========================================="
