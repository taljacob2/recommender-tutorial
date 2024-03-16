# Prepare python and pip.
FROM jupyter/minimal-notebook as base

# Create virtual environment.
RUN python3 -m venv .venv

# Switch to the virtual environment.
ENV PATH="/workspace/.venv/bin:$PATH"

# Upgrade pip.
RUN pip install --upgrade pip

# Install optional jupyter theme.
RUN pip install jupyterlab_darkside_theme

# -----------------------------------------------------------------------------
FROM base as base-with-requirements

# Install requirements.txt.
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# -----------------------------------------------------------------------------
FROM base-with-requirements as image

# Prepare workspace.
WORKDIR /workspace
COPY . .

# Start jupyter notebook server entrypoint, without token.
EXPOSE 8888
ENTRYPOINT jupyter notebook --NotebookApp.token=''