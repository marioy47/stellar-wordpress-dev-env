# WordPress Stellar development Environment

Local WordPress development environment using only **Docker** and optionally Node.

## Services

- WordPress with SSL: <https://stellar.local:8443>
- MailHog (SMTP testing): <http://mail.stellar.local:8443>
- PhpMyAdmin: <http://pma.stellar.local:8443>

## Usage

1. Edit your `/etc/hosts` file
2. Start the environment

### 1. Edit your _hosts_ file adding the `stellar.local` custom domain

You have to create a new entry on this file so the development machine understands that the custom domain (in this case `stellar.local`) points to itself.

- On MacOS and Linux is `/etc/hosts`
- On [Windows](https://www.liquidweb.com/kb/edit-host-file-windows-10/) is `C:\Windows\System32\drivers\etc\hosts`

You need to have an entry similar to the following:

```bash
127.0.0.1 localhost stellar.local mail.stellar.local pma.stellar.local
```

> Notice that you can change the domain using a [`.env`](.env.example) file (see below on how to do that)

### 2. Start the environment

```bash
cd path/to/repo
docker-compose up mkcert
docker-compose up -d
```

> Note 1:
> You can omit the `-d` flag if you want to review the logs on the terminal

> Note 2:
> The `docker-compose up mkcert` is to create the SSL certs and _minimize_ issues with the Nginx web-service.

## Troubleshooting

### Error connecting to port 8443 (or any conrfigured port)

It is possible the first execution fails because `mkcert` did not finished creating the certificates before `nginx` started. The solution is to stop the environment and start it again:

```bash
docker-compose down
docker-compose up
```

## Proxy remote media files

There are times where you have a published staging site with hundreds of media files already uploaded, and syncing them locally would take too much time or occupy too much space in your local machine.

You can use the local `nginx` service to proxy those files. That way you would only need to sync the database and not the media. The only requisite is that the media in the local site has the same **path** as the remote site.

For instance, if you have a file in <https://remote-site.com/wp-content/uploads/2022/11/my-image.png> you can access it in `<https://stellar.local:8443/wp-content/uploads/2022/11/my-image.png> without the need to download it locally.

To make this work, you should create `.env` file with at least the following line:

```bash
WORDPRESS_REMOTE_URL=https://remote-site.com
```
