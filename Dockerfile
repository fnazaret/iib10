# © Copyright IBM Corporation 2015.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html

FROM ubuntu:16.04

LABEL maintainer "Dan Robinson <dan.robinson@uk.ibm.com>, Sam Rogers <srogers@uk.ibm.com>"

LABEL "ProductID"="447aefb5fd1342d5b893f3934dfded73" \
      "ProductName"="IBM Integration Bus" \
      "ProductVersion"="10.0.0.10"

# Install curl
RUN apt-get update && \
    apt-get install -y curl rsyslog sudo && \
    rm -rf /var/lib/apt/lists/*

# Install IIB V10 Developer edition
RUN mkdir /opt/ibm && mkdir /tmp/BARs && \
    curl http://10.0.0.1:8080/iib/10.0.0-IIB-LINUXX64-FP0010.tar.gz \
    | tar zx --exclude iib-10.0.0.10/tools --directory /opt/ibm && \
    /opt/ibm/iib-10.0.0.10/iib make registry global accept license silently

# Configure system
RUN echo "IIB_10:" > /etc/debian_chroot  && \
    touch /var/log/syslog && \
    chown syslog:adm /var/log/syslog



# Create user to run as
RUN useradd --create-home --home-dir /home/iibuser -G mqbrkrs,sudo iibuser && \
    sed -e 's/^%sudo	.*/%sudo	ALL=NOPASSWD:ALL/g' -i /etc/sudoers

# Increase security
RUN sed -i 's/sha512/sha512 minlen=8/'  /etc/pam.d/common-password && \
    sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t1/'  /etc/login.defs && \
    sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t90/'  /etc/login.defs

# Copy in script files
COPY iib_manage.sh /usr/local/bin/
COPY iib-license-check.sh /usr/local/bin/
COPY iib_env.sh /usr/local/bin/
COPY BARfiles/*.bar /tmp/BARs/
RUN chmod +rx /usr/local/bin/*.sh

# Set BASH_ENV to source mqsiprofile when using docker exec bash -c
ENV BASH_ENV=/usr/local/bin/iib_env.sh
ENV MQSI_MQTT_LOCAL_HOSTNAME=127.0.0.1

# Expose default admin port and http port
EXPOSE 4414 7800 7080

USER iibuser

# Set entrypoint to run management script
ENTRYPOINT ["iib_manage.sh"]
