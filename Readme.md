## Install Asec Services On WSL
------------
**If you want to keep your files on WSL**

**Copy the folder asec to `/asec`**
```bash
sudo mkdir -p /asec
sudo cp -r <file-source> /asec # sudo cp -r /mnt/d/asec/service /asec
```
**Verfiy Environment variables**
```bash
sudo nano .env
```
**Change the desired `PostgreSQL Configuration `**

**On  Port Proxy**
`LISTEN_PORT=5432` is the port where windows will expose for external connections
`WSL_IP=172.26.114.208` is the IP Address of the WSL can get using 
```bash 
# use this command to view WLS IP inside WSL, and use the IP address of eth0:
ip addr show;
```

**Now, go to the `service/scripts`**
```bash
cd /asec/service/scripts
sudo chmod +x *.sh
./create-env.sh
./create-service.sh
./setup-docker.sh
./setup-service.sh
```
**Now check the service status**
```bash
 # servicename is on .env as SERVICE_FILE
sudo systemctl status servicename.service 
# for asec.service
# sudo systemctl status asec.service
# for docker
docker ps
```

**If everything is fine, now connect from the SQL Editor Tool and Start Using Postgresql**

**Now start `powershell` run as administrator** 
```bash
# locate to services folder
cd <directory-on-windows>/scripts
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
./setup-wsl-portproxy.ps1
```
Now `Postgresql` can be connected using `Windows` IP and `LISTEN_PORT`

**WSL** Might not Start When **Windows** is reboot, in such sitations please Read guidlines for `WSL Auto Start & Keep-Alive Setup.md`

------------------