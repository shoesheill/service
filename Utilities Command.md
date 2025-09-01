**WSL**
```bash
# View the list of wsl
wsl --list --verbose
# View available wsl
wsl --list --online
#Install Distro and restart terminal once
wsl --install -d Ubuntu
wsl --install -d <disto-name>
wls --unregister <disto-name>
# Set default distro
wsl.exe --set-default Ubuntu
wsl.exe --set-default-version 2
```

**Docker Commands**
```bash
docker compose up -d # docker compose up
docker compose up -d --build # build and docker compose 
docker compose --env-file/../.env up/down ... # pass environment for docker compose up or down
docker logs <containter-id> # for docker logs
docker compose down # for down dockers dockers
docker compoose down -v # down running docker container and remove volumes
docker ps # for docker containers running
docker ps -a # for all docker containers
docker stop <container-id> # stop docker container
docker start <container-id> # start docker container
docker restart <container-id> # restart docker container
docker rm <container-id> # remove docker container, use rm -f to force deleteion
docker prune # remove unused docker containers
docker images ls # list docker images
docker images rm <image-id> # remove docker image
docker images prune # remove unused dockers images
docker volumes ls # list docker volumes
docker volumes rm <volume-id> # remove specific docker volumes
docker volumes prune # remove unused docker volumes
```

**asec.service**
```bash
sudo systemctl start asec.service # start service, when the service starts (if stopped) asec/service/scripts/start.sh will execute
sudo systemctl stop asec.service #  asec/service/scripts/stop.sh will execute
sudo systemctl enable asec.service
sudo systemctl status asec.service
sudo systemctl restart asec.service #  asec/service/scripts/start.sh will execute
```

**Postgresql**
```bash
docker exec -it <docker-name> psql -U <postgres-username> -d <db-name> # start psql on cli mode
# docker exec -it asec_postgres psql -U postgres -d postgres
docker exec -it asec_postgres cat /etc/postgresql/pg_hba.conf
docker exec -it asec_postgres cat /etc/postgresql/postgresql.conf
SHOW config_file; # show config file path
SHOW hba_file; # show pg_hba file path
SHOW data_directory; # show directory
\l              # list databases
\dt             # list tables
\dx             # list extensions

sudo -i -u postgres
psql
# Or access directly
sudo -u postgres psql
# Check the port where postgresql is running
sudo ss -ltnp | grep postgres
 #Check if the postgresql is running
psql -h 127.0.0.1 -U postgres -d postgres -W
# If running in anothe port, check connection
psql -h 127.0.0.1 -p 5433 -U postgres -d postgres -W
```