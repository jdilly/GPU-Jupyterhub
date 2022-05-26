# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM nvidia/cuda:11.4.2-cudnn8-devel-ubuntu20.04

MAINTAINER Kyle Roth <kylrth@gmail.com>

USER root

ARG DEBIAN_FRONTEND=noninteractive

# Nvidia has rotated their GPG keys since this image was created.
RUN apt-key del 7fa2af80 && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub

RUN apt-get update && \
    apt-get install -yq software-properties-common

RUN apt-get update && apt-get -yq dist-upgrade
RUN apt-get install -yq --no-install-recommends \
    bzip2 \
    ca-certificates \
    curl \
    fonts-liberation \
    locales \
    man \
    manpages-posix \
    sudo \
    wget
RUN yes | unminimize

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# Install Tini
ARG TINI_VERSION=0.19.0
ARG TINI_SHA256=93dcc18adc78c65a028a84799ecf8ad40c936fdfc5f2a57b1acda5a8117fa82c
RUN wget --quiet https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini && \
    echo "${TINI_SHA256} *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

COPY fix-permissions /usr/local/bin/fix-permissions
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY start-singleuser.sh /usr/local/bin/

# create deep user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group
ARG CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=deep \
    NB_UID=1000 \
    NB_GID=100
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER:$NB_GID $CONDA_DIR && \
    fix-permissions /home/$NB_USER && \
    fix-permissions $CONDA_DIR
RUN rm /usr/local/bin/fix-permissions
RUN usermod -aG sudo $NB_USER
RUN echo "deep:changeme" | chpasswd
USER $NB_USER

# configure environment for CUDA
ENV CUDA_HOME /usr/local/cuda-11.4
ENV LD_LIBRARY_PATH /usr/local/cuda-11.4:/usr/local/cuda-11.4/lib64:$LD_LIBRARY_PATH
# CUPTI libs were moved to /usr/local/cuda/lib64
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV LIBRARY_PATH $LD_LIBRARY_PATH

# install conda as non-root user
ARG MINICONDA_VERSION=py39_4.12.0
ARG MINICONDA_SUM=7843dd7d0a2c53b0df37ca8189672992
ENV PATH=$CONDA_DIR/bin:$PATH
RUN cd /tmp && \
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "${MINICONDA_SUM} *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    conda config --system --prepend channels conda-forge && \
    conda config --system --set auto_update_conda false && \
    conda config --system --set show_channel_urls true && \
    conda update --all --quiet --yes && \
    conda install --yes conda-build && conda build purge-all

# install necessary Jupyter components
RUN conda install -y \
    python \
    notebook=6.4.11 \
    jupyterhub=2.3.0 \
    jupyterlab=3.4.2 \
    jupyter \
    six

# create the .jupyter/lab dir so that when we mount user settings it doesn't create this dir as root
RUN mkdir -p /home/$NB_USER/.jupyter/lab

# configure container startup
ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"]
EXPOSE 8888
WORKDIR /home/$NB_USER
