```shell
# install squid
sudo add-apt-repository ppa:ubuntu-security-proposed
sudo apt update
sudo apt install squid-openssl -y

# edit iptables 

# edit file /etc/squid/squid.conf with 
# HTTP Proxy (Intercept Mode)
http_port 3128
#http_port 3128 intercept
sudo iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 80 -j REDIRECT --to-port 3128
sudo iptables -t nat -A PREROUTING -i ens33 -p tcp --dport 443 -j REDIRECT --to-port 3129
sudo iptables -A INPUT -p tcp --dport 3129 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 3128 -j ACCEPT
sudo iptables-save

echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo sysctl -w net.ipv4.ip_forward=1

# To make it persistent across reboots, add this line to :
net.ipv4.ip_forward = 1
# Then apply the changes:
sudo sysctl -p


# to make this changes still
sudo apt install iptables-persistent
sudo netfilter-persistent save

# create certificate for squid 
cd /etc/squid
sudo openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout key.pem -out cert.pem -subj "/C=US/ST=Test/L=Test/O=Squid Proxy/CN=Squid"
sudo cp cert.pem /usr/local/share/ca-certificates/squid.crt
sudo update-ca-certificates


/usr/lib/squid/security_file_certgen -c -s /var/lib/squid/ssl_db -M 4MB
chown -R proxy:proxy /var/lib/squid/ssl_db
chmod -R 750 /var/lib/squid/ssl_db

##################### squid conf vi /etc/squid/squid.conf ##########################################
# HTTPS Transparent Proxy (Intercept Mode)
http_port 3128
#http_port 3128 intercept

# HTTPS Transparent Proxy (Intercept Mode)
https_port 3129 intercept ssl-bump cert=/etc/squid/cert.pem key=/etc/squid/key.pem

sslcrtd_program /usr/lib/squid/security_file_certgen -s /var/lib/squid/ssl_db -M 4MB
sslcrtd_children 32 startup=5 idle=1

# Define ACLs
acl allowed_sites dstdomain "/etc/squid/allowed_hosts.txt"
acl localnet src 192.168.15.0/24
acl SSL_ports port 443
acl Safe_ports port 80 443 3128 3129 22
acl CONNECT method CONNECT

# SSL Bump Configuration
acl step1 at_step SslBump1
ssl_bump peek step1
ssl_bump splice allowed_sites
ssl_bump bump all

# Enforce allowed_sites for localnet
http_access allow localnet allowed_sites
# Deny all other traffic
http_access deny all
##################### squid conf vi /etc/squid/squid.conf ##########################################

# restart squid
sudo service squid restart
```