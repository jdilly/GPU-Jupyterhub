# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyterhub/jupyterhub:2.0.1

# newer versions of Jupyter Hub don't have conda, and we need conda to install psycopg2 without
# building (which requires other postgres stuff to be installed)
RUN curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg && \
    install -o root -g root -m 644 conda.gpg /etc/apt/trusted.gpg.d/ && \
    echo "deb [arch=amd64] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" > /etc/apt/sources.list.d/conda.list
RUN apt-get update && apt-get install conda

# Install dockerspawner, oauth, postgres
RUN /opt/conda/bin/conda update -n root conda && \
    /opt/conda/bin/conda install -yq psycopg2=2.8.6 && \
    /opt/conda/bin/conda clean -tipsy && \
    /opt/conda/bin/pip install --no-cache-dir \
        oauthenticator==14.2.0 \
        dockerspawner==12.1.0

ENV PATH /opt/conda/bin:$PATH
