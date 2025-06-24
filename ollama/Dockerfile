# --- GPU Optimized Dockerfile (Recommended for Performance) ---
# Use an NVIDIA CUDA base image that includes the necessary drivers and CUDA toolkit.
# Replace '12.1.0-cudnn8-runtime-ubuntu22.04' with a version compatible with your GPU and system.
FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

# Set environment variables to prevent interactive prompts during apt-get install
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install necessary tools like curl, ca-certificates, and build-essential
# build-essential is often needed by Ollama's install script for CUDA/cuBLAS detection and compilation
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    build-essential \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install Ollama
# The install.sh script automatically detects CUDA support and builds with cuBLAS if available
RUN curl -fsSL https://ollama.com/install.sh | sh

# Set OLLAMA_HOST to listen on all network interfaces (0.0.0.0)
# This is crucial for accessing Ollama from outside the Docker container.
ENV OLLAMA_HOST=0.0.0.0:11434

# Expose the default Ollama port
EXPOSE 11434

# Volume for Ollama data to persist models and other data
# This is where Ollama stores its models. It's good practice to mount an external volume to this path.
VOLUME /root/.ollama

# Pull the nomic-embed-text model during the Docker image build process.
# This makes the model available immediately when the container starts.
# We run `ollama serve` in the background first, then pull, then kill it.
# This ensures Ollama is running to accept the pull command.
RUN (ollama serve &) && \
    ollama pull nomic-embed-text && \
    ollama list && \
    pkill ollama

# Command to run Ollama when the container starts
CMD ["ollama", "serve"]


# --- CPU Only Dockerfile (Use if no GPU is available or required) ---
# FROM ubuntu:22.04

# ENV DEBIAN_FRONTEND=noninteractive

# RUN apt-get update && apt-get install -y \
#     curl \
#     ca-certificates \
#     --no-install-recommends && \
#     rm -rf /var/lib/apt/lists/*

# RUN curl -fsSL https://ollama.com/install.sh | sh

# ENV OLLAMA_HOST=0.0.0.0:11434

# EXPOSE 11434

# VOLUME /root/.ollama

# RUN (ollama serve &) && \
#     ollama pull nomic-embed-text && \
#     ollama list && \
#     pkill ollama

# CMD ["ollama", "serve"]
