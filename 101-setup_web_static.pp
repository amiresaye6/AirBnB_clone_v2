#!/usr/bin/env bash
# automaint task 0

# Install Nginx if not installed
package { 'nginx':
  ensure => installed,
}

# Create necessary directory structure
file { ['/data', '/data/web_static', '/data/web_static/releases', '/data/web_static/shared', '/data/web_static/releases/test']:
  ensure => directory,
}

# Create a fake HTML file for testing
file { '/data/web_static/releases/test/index.html':
  ensure  => file,
  content => 'Hello World! from /data/web_static/releases/test/',
}

# Remove and recreate the symbolic link
file { '/data/web_static/current':
  ensure => link,
  target => '/data/web_static/releases/test/',
  force  => true,
}

# Set ownership of /data/ to ubuntu user and group recursively
file { '/data':
  ensure  => directory,
  owner   => 'ubuntu',
  group   => 'ubuntu',
  recurse => true,
}

# Update Nginx configuration to serve content to hbnb_static using alias
file { '/etc/nginx/sites-available/default':
  ensure  => file,
  content => "\
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    add_header X-Served-By $HOSTNAME;
    root /var/www/html;
    index index.html index.htm;

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
}",
  notify  => Service['nginx'],
}

# Restart Nginx after updating the configuration
service { 'nginx':
  ensure     => running,
  enable     => true,
  subscribe  => File['/etc/nginx/sites-available/default'],
}
