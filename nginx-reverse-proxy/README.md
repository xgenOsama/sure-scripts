# configure nginx proxy for pfsense firewall

```shell
# Install Certbot (Let’s Encrypt client):
sudo apt update && sudo apt install certbot python3-certbot-nginx -y
# Obtain and install an SSL certificate:
sudo certbot --nginx -d surewebsite.com
# auto renew certificates
sudo certbot renew --dry-run


# create selfsigned certificate for testing only 
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/surewebsite.key -out /etc/ssl/certs/surewebsite.com.crt


server {
    listen 443 ssl;
    server_name sureproxy.com;

    ssl_certificate /etc/ssl/private/surewebsite.crt;
    ssl_certificate_key /etc/ssl/private/surewebsite.key;

    location / {
        proxy_pass http://192.168.15.148;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

server {
    listen 443 ssl;
    server_name surewebsite.com;

    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

    location / {
        proxy_pass http://192.168.15.148;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

```