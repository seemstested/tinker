#!/bin/bash
# AI Deep Dive - Main Launcher
# Stop Ollama and run experiments

echo "🚀 AI Deep Dive - Local LLM Exploration"
echo "========================================"
echo ""

# Check if Ollama is running
if pgrep -x "ollama" > /dev/null; then
    echo "⚠️  Ollama is running and using VRAM"
    echo "Stopping Ollama to free up GPU memory..."
    sudo systemctl stop ollama 2>/dev/null || killall ollama 2>/dev/null
    sleep 3
    echo "✓ Ollama stopped"
    echo ""
fi

# Show available VRAM
echo "💾 GPU Memory Status:"
nvidia-smi --query-gpu=name,memory.total,memory.free --format=csv
echo ""

# Show menu
echo "📚 Available Experiments:"
echo "1. Memory Profiling & Layer Offloading"
echo "2. Tokenization Deep Dive"
echo "3. KV Cache Analysis"
echo "4. Quantization Comparison"
echo "5. Custom Sampling Strategies"
echo "6. Run All Experiments"
echo "7. Interactive Mode (llama-cli)"
echo "8. Server Mode (llama-server)"
echo ""

read -p "Select experiment (1-8): " choice

case $choice in
    1)
        bash ~/ai-deep-dive/experiments/01_memory_profiling.sh
        ;;
    2)
        bash ~/ai-deep-dive/experiments/02_tokenization.sh
        ;;
    3)
        bash ~/ai-deep-dive/experiments/03_kv_cache.sh
        ;;
    4)
        bash ~/ai-deep-dive/experiments/04_quantization.sh
        ;;
    5)
        bash ~/ai-deep-dive/experiments/05_sampling.sh
        ;;
    6)
        echo "Running all experiments..."
        for i in {1..5}; do
            echo ""
            echo "========================================"
            echo "Running Experiment $i..."
            echo "========================================"
            bash ~/ai-deep-dive/experiments/0${i}_*.sh
            echo "Press Enter to continue..."
            read
        done
        ;;
    7)
        echo "Starting interactive mode..."
        echo "Try: --temp 0.8 -c 1024 -ngl 15"
        ~/llama.cpp/build/bin/llama-cli \
            -m ~/llama-models/Qwen3-4B-Q4_K_M.gguf \
            -ngl 15 \
            --temp 0.8 \
            -c 2048
        ;;
    8)
        echo "Starting server on port 8080..."
        echo "API will be available at: http://localhost:8080"
        ~/llama.cpp/build/bin/llama-server \
            -m ~/llama-models/Qwen3-4B-Q4_K_M.gguf \
            -ngl 15 \
            --port 8080 \
            -c 4096
        ;;
    *)
        echo "Invalid choice"
        ;;
esac
