# getting started on Kyle's Jupyter Lab Hub

Welcome! The first thing you should know is that this environment is running inside of a Docker container, and when you stop your server you destroy the container. If you want your files to persist, they need to go in `~/persistent`. That directory is stored on the host server's SSD, which is fast but has limited storage. There is also `~/shared`, which is stored on an optical disk. Everyone who uses Jupyter here can see files in `~/shared`.

You can view disk usage by running `df -h /` for the SSD and `df -h ~/shared` for the optical disk.

Backups are taken of `~/persistent` every 24 hours at 08h15 UTC. `~/shared` is NOT backed up.

## Netdata

[Netdata](https://www.netdata.cloud/) is a monitoring tool that will let you see detailed statistics on things like CPU/GPU usage, RAM, disk I/O, etc. You can view it by visiting [netdata.kylrth.com](https://netdata.kylrth.com/).

## Python kernels

There are two Conda environments pre-installed in the container, `base` and `geopandas`. `base` has standard deep learning and data science libraries like PyTorch, TensorFlow, Pandas, and NLTK. You can make whatever changes you like to these environments, but remember that the changes will be lost when you restart your Jupyter Lab server.

If you want to add a new Conda environment and make it available for running Jupyter notebooks, run something like the following in the terminal:

```sh
conda create -n xgboost \
    ipykernel \
    xgboost \
    pandas \
    ...
conda run -n xgboost ipython kernel install --user --name=xgboost
```

Again, this new kernel will be lost when you shut down your Jupyter Lab server. If you want a change to persist, reach out to me about adding that change to the Docker image.
