FROM debian

RUN apt-get update &&\ 
  apt-get -y upgrade &&\ 
  apt-get -y install npm git curl software-properties-common &&\
  curl -sL https://deb.nodesource.com/setup_15.x | bash -



COPY my-app/ /var/www/html/

RUN ls -lah /var/www/html/

WORKDIR "/var/www/html/"

RUN npm install
  #npx browserslist@latest --update-db &&\
  #echo "daemon off;" >> /etc/nginx/nginx.conf &&\
  #echo "npm start && nginx" > sf

EXPOSE 3000

STOPSIGNAL SIGTERM

CMD ["npm","start"]
