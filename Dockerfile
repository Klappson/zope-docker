FROM ubuntu:latest

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt install \
        python3 \
        python3-pip \
        python3-virtualenv \
        python3-venv \
        haproxy \
        git \
        postgresql-14 \
        tree -y

RUN pip3 install zope \
    psycopg2-binary \
    Products.PythonScripts \
    Products.ZSQLMethods \
    Products.SiteErrorLog \
    Products.StandardCacheManagers \
    Products.ExternalMethod \
    Products.MailHost \
    zope.mkzeoinstance \
    Products.Sessions \
    git+https://github.com/perfact/ZPsycopgDA \
    git+https://github.com/perfact/zodbsync \
    Paste \
    requests

COPY fs/ /

RUN printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d

WORKDIR /root
RUN mkwsgiinstance -u klappson:12345 -d wsgi
RUN mkzeoinstance zeo

ENTRYPOINT [ "StartZope" ]