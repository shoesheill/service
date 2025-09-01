sudo curl -fsSL https://get.docker.com -o get-docker.sh
echo "Installing Docker..."
sudo sh ./get-docker.sh
echo "Docker installed."
# sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
echo " Verify by running: docker --version"
echo "Verify running: docker ps"
sudo rm -f get-docker.sh
echo "Setup Docker completed."