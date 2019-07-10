FROM lsiobase/alpine:3.10

# install packages
RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache \
	logrotate \
	# install nginx and nfs-client
	nginx \
	nfs-utils && \
 echo "**** configure nginx ****" && \
 echo 'fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> \
	/etc/nginx/fastcgi_params && \
 rm -f /etc/nginx/conf.d/default.conf && \
 echo "**** fix logrotate ****" && \
 sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
 sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' \
	/etc/periodic/daily/logrotate

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config
