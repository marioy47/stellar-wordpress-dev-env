# Stellar WordPress Development Environment

Local WordPress development environment using [Docker](https://docker.com) **or** [Lando](https://lando.dev). Using Lando is recommended since it avoids the usage of **custom ports**.

<video src="https://user-images.githubusercontent.com/3419025/201969563-ee5f7073-6955-40c5-b766-95824b6be9a1.mp4" width="100%"></video>

<!-- toc -->

- [Description](#description)
- [Installation/Setup](#installationsetup)
- [Plugin and Theme Development](#plugin-and-theme-development)
- [Destroy vs Stop](#destroy-vs-stop)
- [Developing offline](#developing-offline)
- [Proxy remote media files (Only o Docker)](#proxy-remote-media-files-only-o-docker)
- [Docker](#docker)
- [NPM commands](#npm-commands)
- [Troubleshooting](#troubleshooting)
  - ["Site Healt" says the I'm not ussing HTTPS](#site-healt-says-the-im-not-ussing-https)
  - [REST API encounter an error](#rest-api-encounter-an-error)

<!-- tocstop -->

## Description

Spinning up this development environment will do the following:

- Download, install and configure the required containers to run WordPress in a **multisite** fashion.
  - This includes a **database** container (MariaDB) and a **object cache** container (Redis)
- Download and configure a [PhpMyAdmin](https://phpmyadmin.net) container so you can manage your MariaDB database.
- Download and configure a [MailHog](https://github.com/mailhog/MailHog) smtp mail catcher to review the emails sent by WordPress.

You can access each service in the following URLs:

- WordPress: <https://stellarwp.lndo.site>
- MailHog (SMTP testing): <https://stellarwp-mail.lndo.site>
- PhpMyAdmin: <https://stellarwp-pma.lndo.site>

Take into account that if you use Docker instead of Lando, you can enable/disable SSL and manage the port for each service BUT you'll loose the **multisite** functionality since WordPress has some issues while being used in non standard ports.

## Installation/Setup

Note: If you opt for using Docker instead of Lando, you can use `npm run ...` instead of `lando ..` on the following commands.

```bash
git clone https://github.com/marioy47/stellar-wordpress-dev-env stellar-wordpress
cd stellar-wordpress
lando start
open https://stellarwp.lndo.site/wp-admin
```

- Default WordPress username: `admin`
- Default WordPress password: `password`
- Default PhpMyAdmin/MySQL user: `wordpress`
- Default PhpMyAdmin/MySQL password: `wordpress`

## Plugin and Theme Development

After you startup then environment, you should have 3 new folders:

- `plugins/` that points to `/var/www/html/wp-content/plugins` of the WordPress container
- `themes/` that points to `/var/www/html/wp-content/themes` of the WordPress container
- `wp-www/` contains the WordPress core files. This should be removed if you need to **start over**

If you destroy your environment, everything in this folders **will be kept**.

## Destroy vs Stop

If you want to stop the Docker Containers (Lando uses Docker behind the scenes) to preserve your battery or just want to swich projects, you just have to issue

```bash
lando stop # Or if you are using docker: `npm stop`
```

If you want to start from scratch, then you can use the _destroy_ command:

```bash
lando destroy # Or if you are using docker `npm run destroy`
rm -rf wp-www
```

This will delete the MySQL data, the WordPress installation, the webserver configuration, etc. This is a good option when you are having issues, you want to start a new project, or when you want to change the development "domain".

Take into account that the content of `plugins/`, `themes/` and `wp-www/` will **never** be deleted for you, not even with the _destroy_ command

## Developing offline

If you execute `dig stellarwp.lndo.site` you'll see that the `stellarwp.lndo.site` domain is actually valid and it points to `127.0.0.1`. That's one of the reasons why you don't have to make DNS change in order to use this dev environment, this also means that you **need** internet access to start developing.

If you want to get around this issue, then you have to change your _hosts_ file. This is a file of your machine, not a file in a container.

- On MacOS and Linux is `/etc/hosts`
- On [Windows](https://www.liquidweb.com/kb/edit-host-file-windows-10/) is `C:\Windows\System32\drivers\etc\hosts`

You need to have an entry _similar_ to the following:

```bash
127.0.0.1 localhost localhost.localdomain *.lndo.site
```

The important bit is `*.lndo.site` on the line that says `127.0.0.1`

## Proxy remote media files (Only o Docker)

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

## Docker

If you are using docker, you can use a `.env` file to:

- Disable SSL
- Change all the ports
- Change the default username and password
- Change the MySQL connection credentials
- Use _proxy_ remote media files to avoid big sync processes

Take a look at the [`.env.example`](.env.example) file comments for an explanation of what can be achieved.

## NPM commands

For a list of available tasks/commands execute

```bash
npm run
```

## Troubleshooting

### "Site Healt" says the I'm not ussing HTTPS

This hapens on a multisite configuration, and is bacause the Site Creation form does not use HTTPS by default. The solution is to go to `My Sites (on the admin toolbar) > Network Admin > Sites` clic on `Edit` onder the problem site, and change `http` with `https`.

### REST API encounter an error

This happens because you are using `localhost` as the WordPress host and your development machine can not understand that `localhost` is actually a Docker container.
