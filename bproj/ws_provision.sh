apt update
apt -y upgrade
apt -y install nginx
systemctl enable nginx
systemctl start nginx
echo -n "<b>private</b>" > /var/www/html/index.html
