## Install Asec Services On WSL
------------

**Verfiy Environment variables**
```bash
sudo nano .env
```
**Change the desired `PostgreSQL Configuration `**

**On  Port Proxy**
`LISTEN_PORT=5432` is the port where windows will expose for external connections, you can set it
**If you want to keep your files on WSL (Optional)**

**Copy the folder asec to `/asec` (optional)**
```bash
sudo mkdir -p /asec
sudo cp -r <file-source> /asec # sudo cp -r /mnt/d/asec/service /asec
```

**Now, go to the `service/scripts`**
```bash
#cd /asec/service/scripts
cd ../scripts
sudo chmod +x *.sh
./create-env.sh
./set-directory.sh
./create-service.sh
./setup-docker.sh
./setup-service.sh
# Optional
./pg-backup.sh # for regular backups
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