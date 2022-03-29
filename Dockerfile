FROM jupyterhub/jupyterhub:2.2.2

RUN pip install --no-cache-dir \
    oauthenticator==14.2.0 \
    dockerspawner==12.1.0
