#!/usr/bin/env bash
# web stack auto deployment on servers
# Install Nginx if not installed
if ! command -v nginx &> /dev/null; then
    echo "Nginx is not installed. Proceeding with installation..."
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo service nginx start
    sudo ufw allow 'Nginx HTTP'
    sudo chown -R "$USER":"$USER" /var/www/html
    sudo chmod -R 755 /var/www
    cp /var/www/html/index.nginx-debian.html /var/www/html/index.nginx-debian.html.bckp
    echo -e "Hello World! from /var/www/html" | dd status=none of=/var/www/html/index.nginx-debian.html
    sudo service nginx restart
fi

# Create necessary directory structure if not already existing
sudo mkdir -p "/data/web_static/releases/test/"
sudo mkdir -p "/data/web_static/shared/test/"
sudo chown -R ubuntu:ubuntu /data/

# Create a fake HTML file /data/web_static/releases/test/index.html
echo -e "Hello World! from /data/web_static/releases/test/" | sudo dd status=none of=/data/web_static/releases/test/index.html

# Remove and recreate the symbolic link
if [ -L "/data/web_static/current" ]; then
    sudo rm "/data/web_static/current"
fi
sudo ln -s "/data/web_static/releases/test/" "/data/web_static/current"

# Update the Nginx configuration
sudo printf '%s' 'server {
    listen 80 default_server;
    listen [::]:80 default_server;
    add_header X-Served-By $HOSTNAME;
    root   /var/www/html;
    index  index.html index.htm;

    location /redirect_me {
        return 301 https://google.com/;
    }

    location /hbnb_static {
        alias /data/web_static/current/;
    }

    error_page 404 /404.html;
    location /404 {
        root /var/www/html;
        internal;
    }
}' | sudo tee /etc/nginx/sites-available/default >/dev/null

# Restart Nginx
sudo service nginx restart
