# Unsloth on DGX Spark

## Quick Start (Docker Compose)

1. Enter the DGX
    ```bash
    ssh <user>@<IP>
    ```
2. Clone the repo
    ```bash
    git clone https://github.com/kreuzhofer/dgx-spark-unsloth.git
    cd dgx-spark-unsloth
    ```
3. Build and run
    ```bash
    JUPYTER_PASSWORD=mysecretpassword docker compose up --build
    ```
    The first build will take a while (xformers compiles from source). Subsequent starts are fast.

4. Port-forward and open Jupyter Lab at `http://localhost:8888`

### Environment variables

| Variable | Description |
|---|---|
| `JUPYTER_PASSWORD` | Password for Jupyter Lab. Takes priority over token. |
| `JUPYTER_TOKEN` | Token for Jupyter Lab. Used if password is not set. |
| `WANDB_API_KEY` | Weights & Biases API key (optional). |

### Useful commands

```bash
# Rebuild after dependency changes
docker compose build

# Get a shell inside the container
docker compose run --rm unsloth bash
```

---

## Manual Setup (without Docker Compose)

1. Enter the DGX
    ```bash
    ssh <user>@<IP>
    ```
2. Clone the repo
    ```bash
    git clone https://github.com/kreuzhofer/dgx-spark-unsloth.git
    ```
3. Run NVidia image

    Check for latest NVidia pytorch version in [their registry](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch)

    ```bash
    docker run --gpus all --ulimit memlock=-1 -it --ulimit stack=67108864 -it --entrypoint /usr/bin/bash  -v "$PWD"/dgx-spark-unsloth:/workspace -p 8888:8888  --rm nvcr.io/nvidia/pytorch:25.10-py3
    ```
4. Install UV
5. Create venv and install project
    ```bash
    sh -c install.sh
    ```
6. Start Jupyter lab
    ```bash
    uv run jupyter lab
    ```
7. Port-forward/use Nvidia sync - and enter the Jupyter Lab
