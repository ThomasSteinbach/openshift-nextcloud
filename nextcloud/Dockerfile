FROM nextcloud:latest
MAINTAINER thomas dot steinbach at aikq.de

# set mount path for external data dir
ENV NEXTCLOUD_DATA_DIR="/appdata/nextcloud"

# setup custom start script
COPY start-docker.sh /start-docker.sh
COPY postConfiguration.sh /postConfiguration.sh

# add non-root user and appropriate permissions
RUN chown -R www-data:root \
               /etc/passwd \
               /start-docker.sh \
               /postConfiguration.sh \
               /var/www/html \
               /var/lock/apache2 \
               /var/run/apache2 && \
    chmod -R g=u /etc/passwd \
                 /var/www/html \
                 /var/lock/apache2 \
                 /var/run/apache2 && \
    chmod +x /start-docker.sh \
             /postConfiguration.sh

# change service port to a non priviliged one
RUN sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/g' /etc/apache2/sites-enabled/000-default.conf && \
    sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf

# reflect changes in metadata
VOLUME /appdata
EXPOSE 8080
USER www-data

CMD ["/start-docker.sh"]
