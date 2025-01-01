# Luzifer / ets2

This is a dockerized version of the ETS2 Gameserver.

## Setup

- Provide a persistent directory for Steam-Client and Game-Data files
- Mount it to `/home/steam/.local/share` in the container
- Run the container, it will
  - install / update the game
  - create the game-content in the `Euro Truck Simulator 2` folder in your mount
  - wait for you to provide the required files in the game-content directory

To automatically install the required files provide a `.tar.gz` file containing the `server_packages.sii` and `server_packages.dat` at the root level in a publically accessible URL and set the `GAMEDATA_URL` environment variable. That file will automatically get downloaded and unpacked into the game-content directory at every start. If you also include your `server_config.sii` into that archive it also will be unpacked to the game-content directory.

Using the `GAMEDATA_URL` mechanic you could for example use an `emptyDir` deployment on Kubernetes to avoid storing the gamefiles. This is not recommended though as it requires downloading the Steam client and gamefiles on every launch.

To connect (without setting up port-forwarding) see the `server.log.txt` in the gamefiles directory and copy the search-id from there. If you set the `server_logon_token`, this should be stable and you should be able to bookmark it.

## Updating

To update the game just restart the container.
