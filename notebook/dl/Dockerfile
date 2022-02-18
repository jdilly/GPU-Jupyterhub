# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM base-notebook-gpu

MAINTAINER Kyle Roth <kylrth@gmail.com>

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ant \
    bc \
    build-essential \
    cmake \
    cm-super \
    curl \
    default-jdk \
    doxygen \
    dvipng \
    ffmpeg \
    freeglut3-dev \
    gfortran \
    git \
    gnupg2 \
    g++ \
    inkscape \
    jed \
    less \
    libavcodec-dev \
    libavformat-dev \
    libcupti-dev \
    libcurl3-dev \
    libdc1394-22-dev \
    libeigen3-dev \
    libffi-dev \
    libfreetype6-dev \
    libgl1-mesa-glx \
    libhdf5-dev \
    libjpeg-dev \
    liblapack-dev \
    liblcms2-dev \
    libopenblas-dev \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libopenexr-dev \
    libpng-dev \
    libsm6 \
    libssl-dev \
    libswscale-dev \
    libtbb-dev \
    libtheora-dev \
    libtiff5-dev \
    libv4l-dev \
    libvips \
    libvips-dev \
    libvips-tools \
    libvorbis-dev \
    libvtk6-dev \
    libwebp-dev \
    libx264-dev \
    libxext-dev \
    libxine2-dev \
    libxrender1 \
    libxvidcore-dev \
    libzmq3-dev \
    lmodern \
    openssh-client \
    pandoc \
    pkg-config \
    qt5-default \
    rsync \
    texlive-latex-extra \
    tmux \
    unzip \
    vim \
    yasm \
    zlib1g-dev

RUN apt-get autoremove -y && \
    apt-get autoclean && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG NB_USER=deep \
    NB_UID=1000 \
    NB_GID=100
USER $NB_USER

# install Go and leave the update-golang.sh command available for the user
ARG GOVERSION=1.17.7
RUN git clone https://github.com/udhos/update-golang
USER root
RUN cd /home/$NB_USER/update-golang && sed -i 's|wget -O|wget --quiet -O|' update-golang.sh
# We won't run with sudo here to avoid providing the password, so we'll modify the script so it can
# run as root.
RUN cd /home/$NB_USER/update-golang && sed -i 's|$SUDO_USER|'"$NB_USER"'|' update-golang.sh
RUN cd /home/$NB_USER/update-golang && sed -i 's|$SUDO_UID|'"$NB_UID"'|' update-golang.sh
RUN cd /home/$NB_USER/update-golang && sed -i 's|$SUDO_GID|'"$NB_GID"'|' update-golang.sh
RUN cd /home/$NB_USER/update-golang && RELEASE=$GOVERSION ./update-golang.sh -declutter
RUN cd /home/$NB_USER/update-golang && git reset --hard
USER $NB_USER

ENV SHELL=/bin/bash \
    EDITOR=vim

# rename the base kernel and give it a cool icon
RUN sed -i 's|Python 3 (ipykernel)|base|' /opt/conda/share/jupyter/kernels/python3/kernel.json
COPY torch_tf_32.png /opt/conda/share/jupyter/kernels/python3/logo-32x32.png
COPY torch_tf_64.png /opt/conda/share/jupyter/kernels/python3/logo-64x64.png

# install Pytorch (force CUDA version even if building with default runtime)
RUN conda install --yes \
    pytorch=1.10.2=*cuda* \
    cudatoolkit=11.3.1 \
    -c pytorch -c nvidia
# install TensorFlow
RUN conda install --yes \
    tensorflow-gpu=2.6.0
# version other important data science packages
RUN conda install --yes \
    scikit-image=0.19.1 \
    scikit-learn=1.0.2 \
    scipy=1.8.0 \
    matplotlib=3.5.1
# no need to version these other things, but we will add them after the others so we get the latest
# when the cache is busted
RUN conda install --yes \
    black \
    Cython \
    Flask \
    h5py \
    ipykernel \
    ipython \
    nose \
    numpy \
    pandas \
    pandarallel \
    path.py \
    Pillow \
    pyyaml \
    seaborn \
    setuptools \
    statsmodels \
    tqdm \
    wheel

# We'll install geopandas in a separate env because its dependencies are pretty different
RUN conda create -n geopandas \
    ipykernel \
    geopandas=0.10.2 \
    pandas \
    pandarallel \
    scikit-image \
    scikit-learn \
    scipy \
    matplotlib
RUN conda run -n geopandas ipython kernel install --user --name=geopandas
COPY geopandas_32.png /home/deep/.local/share/jupyter/kernels/geopandas/logo-32x32.png
COPY geopandas_64.png /home/deep/.local/share/jupyter/kernels/geopandas/logo-64x64.png

RUN conda build purge-all
RUN conda init bash

# import matplotlib the first time to build the font cache
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"

# clean up any temporary data
USER root
RUN rm -rf /tmp/* /var/tmp/*
USER $NB_USER

EXPOSE 5000 6006