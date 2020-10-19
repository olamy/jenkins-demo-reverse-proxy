FROM ubuntu:18.04
MAINTAINER olamy@apache.org
# Default to UTF-8 file.encoding
ENV LANG C.UTF-8
RUN apt update && \
    apt upgrade -y && \
    apt install -y apache2 curl && \
    apt-get install -y --no-install-recommends curl ca-certificates fontconfig locales && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    apt -q autoremove && \
    apt -q clean -y &&   \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/cache/apt/*.bin


ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
EXPOSE 80 443

# https://wiki.jenkins-ci.org/display/JENKINS/Running+Jenkins+behind+Apache
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod ssl
RUN a2enmod headers
RUN a2ensite default-ssl
ADD generic.conf /etc/apache2/generic
ADD site-default.conf /etc/apache2/sites-available/000-default.conf
ADD site-ssl.conf /etc/apache2/sites-available/default-ssl.conf
CMD ["apache2ctl", "-X"]
