# GPU-Jupyterhub

This repo contains the docker-compose.yml for defining the dependencies to run a Jupyter Hub Docker container that spawns Jupyter Lab instances that can use the GPU. It's forked from [this repo](https://github.com/whlteXbread/GPU-Jupyterhub), with the following changes:

- get rid of unnecessary options
- update CUDA, tini, Miniconda, and Jupyter
- deactivate SSL (I use a reverse proxy)
- (TODO) switch to Jupyter Lab instead of Jupyter Notebook by default

## usage

See my [blog post](https://kylrth.com/post/post/jupyter-lab/).
