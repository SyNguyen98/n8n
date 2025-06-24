# --- CPU Only Dockerfile ---
# Use a lean base image for CPU-only environments. Ubuntu is a good choice.
FROM ubuntu:22.04

# Set environment variables to prevent interactive prompts during apt-get install
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install necessary tools like curl and ca-certificates.
# '--no-install-recommends' helps keep the image size smaller.
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    --no-install-recommends && \
    # Clean up apt caches to reduce image size
    rm -rf /var/lib/apt/lists/*

# Install Ollama by downloading and running its official install script.
# This version will install the CPU-only build of Ollama.
RUN curl -fsSL https://ollama.com/install.sh | sh

# Set the OLLAMA_HOST environment variable to make Ollama listen on all network interfaces (0.0.0.0).
# This is crucial for allowing external connections to the Ollama API from outside the Docker container,
# which is necessary for cloud deployments like Render.
ENV OLLAMA_HOST=0.0.0.0:11434

# Expose the default Ollama port. This informs Docker that the container listens on this port at runtime.
EXPOSE 11434

# Define a volume for Ollama data. This is where Ollama stores downloaded models and other persistent data.
# When deploying to Render, you will map a Persistent Disk to this path to ensure models are not lost
# on container restarts or redeployments.
VOLUME /root/.ollama

# Pull the 'nomic-embed-text' model during the Docker image build process.
# This ensures the model is already present in the image when the container starts,
# speeding up initial deployment.
# We run `ollama serve` in the background (`&`) to start the Ollama server,
# then `ollama pull` the model, list it to confirm, and finally `pkill ollama`
# to stop the temporary server used only for the pull operation.
# This makes the model part of the image's filesystem layer.
RUN (ollama serve &) && \
    ollama pull nomic-embed-text && \
    ollama list && \
    pkill ollama

# Set the default command to run when the container starts.
# This will start the Ollama server, making the API available.
CMD ["ollama", "serve"]
