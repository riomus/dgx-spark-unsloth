#!/bin/bash
set -e

JUPYTER_ARGS="--ip=0.0.0.0 --port=8888 --no-browser --allow-root"

if [ -n "$JUPYTER_PASSWORD" ]; then
    mkdir -p ~/.jupyter
    HASHED_PASSWORD=$(python -c "from jupyter_server.auth import passwd; print(passwd('$JUPYTER_PASSWORD'))")
    cat > ~/.jupyter/jupyter_server_config.py <<EOF
c.ServerApp.password = '${HASHED_PASSWORD}'
c.ServerApp.token = ''
EOF
    echo "Jupyter Lab starting with password authentication."
else
    JUPYTER_ARGS="$JUPYTER_ARGS --ServerApp.token='' --ServerApp.password=''"
    echo "WARNING: Jupyter Lab starting with no authentication."
fi

exec uv run jupyter lab $JUPYTER_ARGS "$@"
