# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# configuration file for JupyterHub
import os

c = get_config()

# use the following command to generate a token, place it in the string below:
# `openssl rand -hex 32`
token = ""
c.ConfigurableHTTPProxy.auth_token = token

# spawn single-user servers as Docker containers from the image specified in the docker-compose.yml
c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
c.DockerSpawner.image = os.environ['DOCKER_NOTEBOOK_IMAGE']
c.DockerSpawner.extra_create_kwargs.update({'command': "start-singleuser.sh"})
network_name = "jupyter-network"
c.DockerSpawner.use_internal_ip = True
c.DockerSpawner.network_name = network_name
c.DockerSpawner.extra_host_config = {
    'network_mode': network_name,
    'runtime': 'nvidia',
}
c.DockerSpawner.debug = True
# remove containers once they are stopped
c.DockerSpawner.remove = True

# these directories show up in each user's instance. They will be backed by folders on the host.
notebook_dir= "/home/deep/persistent"
data_dir = "/home/deep/shared"
lab_config_dir = "/home/deep/.jupyter/lab/user-settings"
c.DockerSpawner.notebook_dir = notebook_dir
c.DockerSpawner.volumes = {
    # NOTE: these are paths ON THE HOST, not on the hub container
    # mount the container notebook directory to a real directory on the host
    '/path/on/HOST/to/user_data/{username}': notebook_dir,
    # make the shared data dir available too
    '/path/on/HOST/to/shared_data/': data_dir,
    # preserve Jupyter Lab settings across restarts
    "/path/on/HOST/to/user_configs/{username}": lab_config_dir
}

# spawned containers will access the hub by container name on the Docker network
c.JupyterHub.hub_ip = ""  # TODO: why is this necessary?
c.JupyterHub.hub_connect_ip = "jupyterhub"
c.JupyterHub.hub_port = 8080

# expose everything through port 80
c.JupyterHub.bind_url = 'http://:80'

c.JupyterHub.cookie_secret_file = "/data/jupyterhub_cookie_secret"

c.JupyterHub.db_url='postgresql://postgres:{password}@{host}/{db}'.format(
    host = os.environ['POSTGRES_HOST'],
    password = os.environ['POSTGRES_PASSWORD'],
    db = os.environ['POSTGRES_DB'],
)

# Make it possible to add users via the admin panel
c.LocalAuthenticator.create_system_users = True
c.Authenticator.allowed_users={'kyle'}
c.Authenticator.admin_users={'kyle'}
