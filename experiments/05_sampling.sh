#!/bin/bash
# AI Deep Dive - Experiment 5: Custom Sampling
# Purpose: Explore different sampling strategies

MODEL="$HOME/llama-models/Qwen3-4B-Q4_K_M.gguf"
LLAMA_BIN="$HOME/llama.cpp/build/bin"
PROMPT="Once upon a time in a distant galaxy"

echo "=========================================="
echo "EXPERIMENT 5: Sampling Strategy Comparison"
echo "=========================================="
echo ""
echo "Prompt: '$PROMPT'"
echo ""

# Function to generate with specific sampling
generate_with_sampling() {
    local name=$1
    shift
    local args="$@"
    
    echo "----------------------------------------"
    echo "Strategy: $name"
    echo "Parameters: $args"
    echo ""
    echo "Output:"
    
    timeout 15 $LLAMA_BIN/llama-cli \
        -m "$MODEL" \
        -ngl 10 \
        -p "$PROMPT" \
        -n 100 \
        --no-display-prompt \
        $args \
        2>/dev/null
    
    echo ""
    echo ""
}

# 1. Greedy decoding (deterministic)
generate_with_sampling "Greedy (temp=0)" "--temp 0"

# 2. Low temperature (focused)
generate_with_sampling "Low temp (temp=0.3)" "--temp 0.3"

# 3. Medium temperature (balanced)
generate_with_sampling "Medium temp (temp=0.7)" "--temp 0.7"

# 4. High temperature (creative)
generate_with_sampling "High temp (temp=1.2)" "--temp 1.2"

# 5. Top-p sampling (nucleus)
generate_with_sampling "Top-p=0.9" "--temp 0.8 --top-p 0.9"

# 6. Top-k sampling
generate_with_sampling "Top-k=40" "--temp 0.8 --top-k 40"

# 7. Combined sampling
generate_with_sampling "Top-k=50 + Top-p=0.95" "--temp 0.8 --top-k 50 --top-p 0.95"

# 8. Repeat penalty
generate_with_sampling "Repeat penalty=1.1" "--temp 0.8 --repeat-penalty 1.1"

echo "=========================================="
echo "Sampling Guide:"
echo "- temp=0: Deterministic, repetitive"
echo "- temp=0.7-0.8: Good balance"
echo "- temp>1.0: More random/creative"
echo "- top-p: Limits to cumulative probability"
echo "- top-k: Limits to k most likely tokens"
echo "- repeat_penalty: Reduces repetition"
echo "=========================================="
