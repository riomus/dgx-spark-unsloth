#!/bin/bash
#
export TORCH_CUDA_ARCH_LIST="12.0"
if [ ! -d ".venv" ]; then
	uv venv --system-site-packages
else
	echo "✓ Virtual environment already exists"
fi

uv sync

uv run python -m ipykernel install --user --name venv --display-name "Python (.venv)"
