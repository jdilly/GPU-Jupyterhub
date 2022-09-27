# https://hub.docker.com/r/jupyterhub/jupyterhub/tags?name=.&page=1
# https://jupyterhub.readthedocs.io/en/stable/changelog.html
FROM jupyterhub/jupyterhub:3.0.0

RUN python3 -m pip install --upgrade pip
# https://pypi.org/project/oauthenticator/
# https://pypi.org/project/dockerspawner/
RUN pip install --no-cache-dir \
    oauthenticator==15.1.0 \
    dockerspawner==12.1.0
