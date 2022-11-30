# Stellar WordPress Development Environment

Local WordPress development environment using only **Docker** and optionally Node.

<video src="https://user-images.githubusercontent.com/3419025/201969563-ee5f7073-6955-40c5-b766-95824b6be9a1.mp4" width="100%"></video>

<!-- toc -->

- [Features](#features)
- [Installation/Setup](#installationsetup)
- [Plugin and Theme Developmet](#plugin-and-theme-developmet)
- [Destroy vs Stop](#destroy-vs-stop)
- [Change `localhost` for a custom domain](#change-localhost-for-a-custom-domain)
  - [1. Change your `hosts` file](#1-change-your-hosts-file)
  - [2. Change the `.env` file to point to the new domain](#2-change-the-env-file-to-point-to-the-new-domain)
  - [3. (Re)build your environment](#3-rebuild-your-environment)
- [Disable HTTPS](#disable-https)
- [Proxy remote media files](#proxy-remote-media-files)
- [Creating a multisite](#creating-a-multisite)
  - [1. Changes in the `.env` file](#1-changes-in-the-env-file)
  - [2. Change the `hosts` file for **every** domain](#2-change-the-hosts-file-for-every-domain)
  - [3. (optional) Create network aliases](#3-optional-create-network-aliases)
- [4. Create the environment with 2 docker files](#4-create-the-environment-with-2-docker-files)
- [Troubleshooting](#troubleshooting)
  - [Error connecting to port 8443 (or any conrfigured port)](#error-connecting-to-port-8443-or-any-conrfigured-port)
  - ["Site Healt" says the I'm not ussing HTTPS](#site-healt-says-the-im-not-ussing-https)
  - [REST API encounter an error](#rest-api-encounter-an-error)

<!-- tocstop -->

## Features

- WordPress with SSL: <https://localhost:8443>
- MailHog (SMTP testing): <https://mail.localhost:8443>
- PhpMyAdmin: <https://pma.localhost:8443>
- You can change `localhost` for a custom domain (see below)
- You can disable SSL (see below)
- You can change all the ports (see below)
- You can change the default username and password (see below)
- You can change the MySQL connection credentials (see below)
- You can use _proxy_ remote media files to avoid big sync processes (see below)
- You can enable multisite

For a list of available tasks/commands execute

```bash
npm run
```

## Installation/Setup

```bash
git clone https://github.com/marioy47/stellar-wordpress-dev-env stellar-wordpress
cd stellar-wordpress
npm start # or `docker-compose up -d`
open https://localhost:8443/wp-admin
```

- Default WordPress username: `admin`
- Default WordPress password: `password`
- Default PhpMyAdmin/MySQL user: `wordpress`
- Default PhpMyAdmin/MySQL password: `wordpress`

## Plugin and Theme Developmet

After you startup then environment, you should have 2 new folders:

- `plugins/` that point to `/var/www/html/wp-content/plugins` of the WordPress container
- `themes/` that point to `/var/www/html/wp-content/themes` of the WordPress container

If you destroy your environment, everything in this folders **will be kept**.

## Destroy vs Stop

If you want to stop the Docker Containers, you just have to issue

```bash
npm stop
```

This will bring down the services, but will preserve the data, including MySQL databases and the WordPress installation. So it's a perfect way to pause your work to resume on a later date.

If you want to start from scratch, then you have to use the _destroy_ command:

```bash
npm run destroy
```

This will delete the MySQL data, the WordPress installation, the webserver configuration, etc. This is a good option when you are having issues, you want to start a new project, or when you want to change the development "domain".

Take into account that the content of `plugins/` and `themes/` will **never** be deleted, not even with the _destroy_ command

## Change `localhost` for a custom domain

If you are going to develop WP-JSON Api applications, or you are annoyed by _Site Health_ API notification. Is suggested that you change the domain of the development environment from "localhost" to a custom fake domain. This is also a requirement when you are going to use a _multisite_ installation (see below).

2 Things to note before starting:

- You _should_ use an **invalid** sufix like `.local` or `.devdomain` or `.localdomain` to avoid automatic redirections in your browser
- You can **not change** the domain of a working environment, you have to destroy it first

### 1. Change your `hosts` file

This is the file of your machine, not a file in a container.

- On MacOS and Linux is `/etc/hosts`
- On [Windows](https://www.liquidweb.com/kb/edit-host-file-windows-10/) is `C:\Windows\System32\drivers\etc\hosts`

You have to create a new entry on this file so the development machine understands that the custom domain (for instance `stellar.local`) points to itself.

You need to have an entry similar to the following:

```bash
127.0.0.1 localhost stellar.local mail.stellar.local pma.stellar.local
```

> Assuming that you'll use `stellar.local` as your custom environment

### 2. Change the `.env` file to point to the new domain

Create or update the file `.env`, and add or change the following line:

```bash
WORDPRESS_HOST=stellar.local
```

### 3. (Re)build your environment

```bash
npm destroy
npm start
```

## Disable HTTPS

The SSL certificate used to "secure" the web server is NOT valid since it's created by an _invalid authority_. So if you want to work without SSL you just have to add the following line to your `.env` file:

```bash
WORDPRESS_DISABLE_HTTPS=yes
```

And **rebuild** (destroy/recreate) your environment

```bash
npm destroy
npm start
```

## Proxy remote media files

There are times where you have a published staging site with hundreds of media files already uploaded, and syncing them locally would take too much time or occupy too much space in your local machine.

You can use the local `nginx` service to proxy those files. That way you would only need to sync the database and not the media. The only requisite is that the media in the local site has the same **path** as the remote site.

For instance, if you have a file in <https://remote-site.com/wp-content/uploads/2022/11/my-image.png> you can access it in <https://localhost:8443/wp-content/uploads/2022/11/my-image.png> **without** the need to download it locally.

> Note that the **path** of the file is the same, but the domain changes. That's a requirement

To make this work, you should create `.env` file with at least the following line:

```bash
WORDPRESS_REMOTE_URL=https://remote-site.com
```

This will tell `nginx` to look for the file locally **first**, and if it's not present, then look for that file on the remote site and pass it to the user.

For this you do **not** have to destroy the environment, just restart it:

```bash
npm stop
npm start
```

## Creating a multisite

If you want to use this machine for multiple projects using a multisite you have to do multiple things:

### 1. Changes in the `.env` file

- The port **has** to be the standard SSL port: `443`
- You can select a custom domain but it can **not** be `localhost`
- Have to set the `WORDPRESS_MULTISITE` flag to `1`

```bash
WORDPRESS_PORT_HTTPS=443
WORDPRESS_HOST=stellar.local
WORDPRESS_MULTISITE=1
```

### 2. Change the `hosts` file for **every** domain

The file on your machine and not a file in the container (see above to find out how to find it).

```bash
# Docker Development
127.0.0.1 stellar.local mail.stellar.local pma.stellar.local
127.0.0.1 one.stellar.local
127.0.0.1 two.stellar.local
127.0.0.1 three.stellar.local
127.0.0.1 four.stellar.local
```

### 3. (optional) Create network aliases

This will fix the _health issue_ where RPC on `Tools > Site Health`

Create a new `.yaml` file with the names of your sites:

```yaml
# docker-compose.stellar.yaml
services:
  webserver:
    networks:
      default:
        aliases:
          - one.stellar.local
          - two.stellar.local
          - three.stellar.local
          - four.stellar.local
```

## 4. Create the environment with 2 docker files

For muiltisite, you **have** to start the environment with `docker-compose` (npm start wont work)

```bash
npm destroy
docker-compose -f docker-compose.yaml -f docker-compose.stellar.yaml up -d
```

## Troubleshooting

### Error connecting to port 8443 (or any conrfigured port)

It is possible the first execution fails because `mkcert` did not finished creating the certificates before `nginx` started. The solution is to stop the environment and start it again:

```bash
docker-compose down
docker-compose up
```

Do **not** pass the `-v` option. We only need to restart the environment, not destoy it.

### "Site Healt" says the I'm not ussing HTTPS

This hapens on a multisite configuration, and is bacause the Site Creation form does not use HTTPS by default. The solution is to go to `My Sites (on the admin toolbar) > Network Admin > Sites` clic on `Edit` onder the problem site, and change `http` with `https`.

### REST API encounter an error

This happens because you are using `localhost` as the WordPress host and your development machine can not understand that `localhost` is actually a Docker container.

The solution is to use a custom _domain_ option

If you are using a multisite setup, then you have to do the "optional" _Network Aliases_ step.

## Using Lando

If you have lando installed then instead if `npm start` use

```bash
lando start
```

Some differences, between using Lando and pure Docker are:

- You'll get a `www` directory with the WordPress installation
- You can use `lando ssh` to get into the _Appserver_
- The URL's will change:
  - WordPress: <https://stellar.lndo.site>
  - PhpMyAdmin: <https://pma.stellar.lndo.site>
  - MailHog: <https://mail.stellar.lndo.site>
