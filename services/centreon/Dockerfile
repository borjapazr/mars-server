FROM centos:7.9.2009

ARG TIMEZONE Europe/Paris
EXPOSE 80

# Update system
RUN yum update -y

# Fix systemctl
COPY scripts/systemctl.py /usr/bin/systemctl.py
RUN cp -f /usr/bin/systemctl /usr/bin/systemctl.original \
  && chmod +x /usr/bin/systemctl.py \
  && cp -f /usr/bin/systemctl.py /usr/bin/systemctl

# Install required repositories
## Install Redhat Software Collections repository
RUN yum install -y centos-release-scl
## Install Remi repository
RUN yum install -y yum-utils
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php80
## Install Centreon repository
RUN yum install -y https://yum.centreon.com/standard/22.04/el7/stable/noarch/RPMS/centreon-release-22.04-3.el7.centos.noarch.rpm

# Installation of Centreon Central Server
RUN yum install -y centreon-central

# Configuration
RUN echo "date.timezone = $TIMEZONE" >> /etc/php.d/50-centreon.ini
RUN systemctl restart php-fpm
RUN systemctl enable php-fpm httpd24-httpd centreon cbd centengine gorgoned snmptrapd centreontrapd snmpd

# Add scripts
COPY scripts/enable-monitoring.sh /scripts/enable-monitoring.sh
RUN chmod +x /scripts/enable-monitoring.sh

CMD /usr/bin/systemctl
