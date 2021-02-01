FROM debian

#ARG TZ='Europe/Minsk'

#ENV TZ ${TZ}

#RUN apk upgrade --update \
    #&& apk add bash \
    #&& ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    #&& echo ${TZ} > /etc/timezone \
    #&& rm -rf /usr/share/nginx/html /var/cache/apk/*

RUN apt-get update &&\ 
  apt-get -y upgrade &&\ 
  apt-get -y install nginx &&\
  echo "daemon off;" >> /etc/nginx/nginx.conf

COPY Hello-ReactJS/* /var/www/html/

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx"]
