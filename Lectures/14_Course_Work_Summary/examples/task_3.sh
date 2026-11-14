sudo useradd dev
sudo groupadd front-end
sudo groupadd back-end
sudo usermod -aG front-end dev
sudo usermod -aG back-end dev

cp /etc/passwd ~/passwd
cd ~
chmod u=rwx,g=rw,o=r passwd
chmod 764 passwd
sudo chown dev:back-end passwd
