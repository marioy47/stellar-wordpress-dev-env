# Stellar WordPress Development Environment

Local WordPress development environment using only **Docker** and optionally Node.

- WordPress with SSL: <https://localhost:8443>
- MailHog (SMTP testing): <https://mail.localhost:8443>
- PhpMyAdmin: <https://pma.localhost:8443>

<video src="demo.mp4" width="100%"></video>

Notes:

- You can change `localhost` for a custom domain (see below)
- You can disable SSL (see below)
- You can change all the ports (see below)
- You can change the default username and password (see below)

## Setup

```bash
git clone https://github.com/marioy47/stellar-wordpress-dev-env stellar-wp
cd stellar-wp
docker-compose up -d
open https://localhost:8443/wp-admin
```

- Default username: `admin`
- Default password: `password`

## Developing

After you startup then environment, you should have 2 new folders:

- `plugins/` with all your plugins
- `themes/` with all your themes

If you destroy your environment, everything in this folders **will be kept**.

## Destroy the environment

```bash
docker-compose down -v
```

The `-v` option will remove the following

- Any database data
- The WordPress installation
- Any certificate data

Content on `plgins/` and `themes/` will allways be kept

## Customization

### Change `localhost` for a custom domain

Thigs to note:

- You _should_ use an **invalid** sufix like `.local` or `.devdomain` or `.localdomain` to avoid redirection in your browser
- You can **not change** the domain of a working environment, you have to destroy it first

#### 1. Change your `hosts` file configuring your new domain

You have to create a new entry on this file so the development machine understands that the custom domain (for instance `stellar.local`) points to itself.

- On MacOS and Linux is `/etc/hosts`
- On [Windows](https://www.liquidweb.com/kb/edit-host-file-windows-10/) is `C:\Windows\System32\drivers\etc\hosts`

You need to have an entry similar to the following:

```bash
127.0.0.1 localhost stellar.local mail.stellar.local pma.stellar.local
```

#### 2. Change the your `.env` file to point to the new domain

In you `.env` add or change the following line:

```bash
WORDPRESS_HOST=stellar.local
```

#### 3. (Re)build your environment

```bash
docker-compose down -v
docker-compse up -d
```

### Disable HTTPS

The SSL certificate used to "secure" the web server is NOT valid since it's created by an _invalid authority_. So if you want to work without SSL you just have to add the following line to your `.env` file:

```bash
WORDPRESS_DISABLE_HTTPS=yes
```

And **rebuild** (destroy/recreate) your environment

### Proxy remote media files

There are times where you have a published staging site with hundreds of media files already uploaded, and syncing them locally would take too much time or occupy too much space in your local machine.

You can use the local `nginx` service to proxy those files. That way you would only need to sync the database and not the media. The only requisite is that the media in the local site has the same **path** as the remote site.

For instance, if you have a file in <https://remote-site.com/wp-content/uploads/2022/11/my-image.png> you can access it in <https://localhost:8443/wp-content/uploads/2022/11/my-image.png> **without** the need to download it locally.

> Note that the **path** of the file is the same, but the domain changes. That's a requirement

To make this work, you should create `.env` file with at least the following line:

```bash
WORDPRESS_REMOTE_URL=https://remote-site.com
```

This will tell `nginx` to look for the file locally **first**, and if it's not present, then look for that file on the remote site and pass it to the user.

## Troubleshooting

### Error connecting to port 8443 (or any conrfigured port)

It is possible the first execution fails because `mkcert` did not finished creating the certificates before `nginx` started. The solution is to stop the environment and start it again:

```bash
docker-compose down
docker-compose up
```

Do **not** pass the `-v` option. We only need to restart the environment, not destoy it.
