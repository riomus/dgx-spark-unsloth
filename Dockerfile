FROM nvcr.io/nvidia/pytorch:25.10-py3

# Environment configuration
ENV TORCH_CUDA_ARCH_LIST="12.0"
ENV DEBIAN_FRONTEND=noninteractive
ENV UV_LINK_MODE=copy
ENV HF_HUB_ENABLE_HF_TRANSFER=1
ENV PYTHONUNBUFFERED=1

# Install uv from official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

WORKDIR /workspace

# Copy dependency files first for layer caching
COPY pyproject.toml uv.lock python-version ./

# Create venv inheriting system site-packages (torch, triton from base image)
RUN uv venv --system-site-packages

# Install all dependencies (including xformers from source — slow first build)
RUN uv sync --extra gpu --frozen

# Register the venv as a Jupyter kernel
RUN uv run python -m ipykernel install --user --name venv --display-name "Python (.venv)"

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy project files (notebook, README, etc.)
COPY . .

EXPOSE 8888

ENTRYPOINT ["/entrypoint.sh"]
