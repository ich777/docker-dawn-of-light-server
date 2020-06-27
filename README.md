# Dawn of Light Server in Docker optimized for Unraid
This Docker will download and install Dawn of Light Server and run it.

ATTENTION: First Startup can take very long since it downloads the gameserver files!

CONSOLE: To connect to the console open up the terminal on the host machine and type in: 'docker exec -u dol -ti NAMEOFYOURCONTAINER screen -xS DoL' (without quotes) to exit the screen session press CTRL+A and then CTRL+D or simply close the terminal window in the first place.

Update Notice: Simply restart the container if a newer version of the game is available.


## Env params

| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for gamefiles | /dol |
| GAME_PARAMS | Commandline startup parameters (if not needed leave empty) | *empty* |
| UMASK | User file permission mask for newly created files | 000 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| DATA_PERM | Data permissions for main storage folder | 770 |

# Run example
```
docker run --name Dawn-of-Light-Server -d \
    -p 10300:10300 \
    -p 10400:10400 \
    -p 10400:10400/udp \
    --env 'UMASK=000' \
    --env 'DATA_PERM=770' \
    --env 'UID=99' \
    --env 'GID=100' \
    --volume /mnt/user/appdata/dawn-of-light:/dol \
    --restart=unless-stopped \
    ich777/dawn-of-light-server:latest
```

This Docker was mainly created for the use with Unraid, if you don’t use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/