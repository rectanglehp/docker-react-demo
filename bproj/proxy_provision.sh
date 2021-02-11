apt update
apt -y upgrade
apt -y install nginx
targitip=${target}

cat <<EOF > /etc/nginx/sites-available/default
server {
        listen 80 default_server;
        listen [::]:80 default_server; 
        server_name _;
	proxy_pass http://${target}:80;
}
EOF
systemctl restart nginx
systemctl enable nginx

