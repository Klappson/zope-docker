# The Zope-Docker - Rollout Zope-Stuff and Chill

## tl;dr
* Where should I mount for persistence?
    * /vol
* Login credentials for zope manage user?
    * dockerzope:12345
    * This can be changed in the Dockerfile or in Zope
* Login credentials for postgres?
    * user: zope
    * database: zopedb
    * pw: 12345

## The problem I want to address

The Idea behind this is that rolling out a zope-project is a pain in the arse.

ATM if you want to rollout a zope-project you have to setup the python-env, install products, create a database, prepare the database load the Data.FS and so on. If you are reading this, you might know what I'm talking about at this point

This docker will create a zope-installation where this whole spiel is already done for you!
Your zope-project will only be a dir consisting of a zoperepo-dir, which contains a ZODBsync dump and a config-dir, which will contain various config files.
(More dirs/files may be added in the future, but the spirit will be kept)

---

## What does this setup contain ATM

* Zope
    * **Batteries included!!**
    * Products.PythonScripts
    * Products.ZSQLMethods
    * Products.SiteErrorLog
    * Products.StandardCacheManagers
    * Products.ExternalMethod
    * Products.MailHost
    * _coming soon: Place a requirements.txt in the config-dir to install custom pip-packages_
* PostgreSQL
    * Containing a User (zope)
    * A Database (zopedb)
    * And prepared permissions for that user on that Database
* Zeo
* [ZODBsync](https://github.com/perfact/zodbsync)
---
## How to Use
### 1. Build the docker-image
**Linux**
```bash
./BuildImage
```

**Windows**
```cmd.exe
docker build -t klappson/docker-zope-setup .
```

### 2. Create the container
**Linux**
```bash
./StartDocker
```

**Windows**
```cmd.exe
docker run \
    -p 8080:8080 \
    -it \
    --name zope-docker \
    klappson/docker-zope-setup
```


***THAT'S IT!***
The Zope-Server will be available at `http://127.0.0.1:8080`

## Persistence and the reason we are here
Since we are here to rollout zope-projects and chill. This wouldn't make much sense if we could not shove any of our projects inside the container.

In order to to so, just add a bind-mount to your container at /vol

This can be done by adding the "--mount" parameter to your docker run command
```bash
--mount type=bind,source=<FOLDER ON YOUR MACHINE>,target=/vol
```

---

## Contents of /vol

### /vol/zoperepo
This folder will contain a [ZODBsync](https://github.com/perfact/zodbsync) dump of zope's Data.FS.

A ZODBsync dump is basically a representation of zope's folder structure but on a normal file-system. The contents of this folder will be shoved into the Data.FS on every startup of the container


### /vol/postgres_data
This folder is a postgres data dir. it's just there to ensure persistence of the postgres-DB.

Keep in mind that you should not add this dir to any git repos. You will run into problems regarding permissions and stuff


### /vol/config
This folder will contain some configs I tough most people would like to edit. If your favorite config-file is missing, feel free to create an issue (or a PR 👀).

Inside the container the files inside this dir will be symlinked to the right location

---

# Planned
* Fully include HaProxy
    * And The Possibility to enable HTTPS
* **[DONE]** Allow more configuration files to be edited
* Add Possibility to add custom Products
* Add Possibility to add a github-link as zoperepo
    * Fetch and playback everytime the container starts
* Cleanup. This whole thing is a pretty huge case of "let's just try this"
* Improve Windows compatibility