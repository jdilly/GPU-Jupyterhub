# https://hub.docker.com/r/jupyterhub/jupyterhub/tags?name=.&page=1
# https://jupyterhub.readthedocs.io/en/stable/changelog.html
FROM jupyterhub/jupyterhub:2.3.1

RUN python3 -m pip install --upgrade pip
# https://pypi.org/project/oauthenticator/
# https://pypi.org/project/dockerspawner/
RUN pip install --no-cache-dir \
    oauthenticator==15.0.1 \
    dockerspawner==12.1.0
