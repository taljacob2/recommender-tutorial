# Prepare python and pip.
FROM jupyter/minimal-notebook as base

# Turn off progress bar, because it may throw `RuntimeError: can't start new thread`.
RUN pip config --user set global.progress_bar off

# Upgrade pip.
RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org --upgrade pip

# Install optional jupyter theme.
RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org jupyterlab_darkside_theme

# -----------------------------------------------------------------------------
FROM base as base-with-requirements

# Prepare workspace.
WORKDIR /workspace

# Create virtual environment.
RUN python3 -m venv .venv

# Switch to the virtual environment.
ENV PATH="/workspace/.venv/bin:$PATH"

# Install requirements.txt.
COPY requirements.txt requirements.txt
RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt

# -----------------------------------------------------------------------------
FROM base-with-requirements as image

COPY . .

# Start jupyter notebook server entrypoint, without token.
EXPOSE 8888
ENTRYPOINT jupyter notebook --NotebookApp.token=''
