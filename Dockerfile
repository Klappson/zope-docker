FROM ubuntu:latest

RUN apt update
RUN apt install python3 python3-pip python3-virtualenv python3-venv haproxy git -y

COPY fs/ /

WORKDIR /root

RUN chmod +x StartZope

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
    Paste

RUN mkwsgiinstance -u klappson:12345 -d wsgi

ENTRYPOINT [ "/root/StartZope" ]