#!/bin/bash
# AI Deep Dive - Experiment 2: Tokenization Deep Dive
# Purpose: Understand how text becomes tokens

MODEL="$HOME/llama-models/Qwen3-4B-Q4_K_M.gguf"
LLAMA_BIN="$HOME/llama.cpp/build/bin"

echo "=========================================="
echo "EXPERIMENT 2: Tokenization Deep Dive"
echo "=========================================="
echo ""

# Test various inputs to see tokenization
test_texts=(
    "Hello world"
    "Halo dunia"
    "こんにちは"
    "👋🌍"
    "12345"
    "   spaces   "
    "newline\nhere"
    "special!@#$%^&*()chars"
    "repetition repetition repetition"
    "The quick brown fox jumps over the lazy dog"
)

echo "Tokenizing various text samples..."
echo ""

for text in "${test_texts[@]}"; do
    echo "----------------------------------------"
    echo "Input: '$text'"
    echo "Length: ${#text} characters"
    
    # Tokenize and count
    tokens=$($LLAMA_BIN/llama-tokenize \
        -m "$MODEL" \
        -p "$text" \
        --show-scores 2>/dev/null | wc -l)
    
    echo "Tokens: $tokens"
    
    # Show actual tokens
    echo "Token breakdown:"
    $LLAMA_BIN/llama-tokenize \
        -m "$MODEL" \
        -p "$text" \
        --show-scores 2>/dev/null | head -10
    
    if [ $tokens -gt 10 ]; then
        echo "... ($((tokens - 10)) more tokens)"
    fi
    echo ""
done

echo "=========================================="
echo "Key Observations:"
echo "- Different languages use different token counts"
echo "- Special characters may be multi-token"
echo "- Repetition often reuses tokens"
echo "=========================================="
