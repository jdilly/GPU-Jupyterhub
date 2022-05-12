FROM jupyterhub/jupyterhub:2.3.0

RUN python3 -m pip install --upgrade pip
RUN pip install --no-cache-dir \
    oauthenticator==14.2.0 \
    dockerspawner==12.1.0
