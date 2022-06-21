FROM jupyterhub/jupyterhub:2.3.1

RUN python3 -m pip install --upgrade pip
RUN pip install --no-cache-dir \
    oauthenticator==15.0.1 \
    dockerspawner==12.1.0
