# WordPress Stellar development Environment

## Services

- WordPress no SSL: <http://localhost:8080>
- **WordPress**: <https://localhost:8081>
- MailHog: <http://localhost:8082>
- PhpMyAdmin: <http://localhost:8083>

## Local Directories

- [`plugins/`](plugins/): WordPress Plugins

## Using custon domain

- Edit your _hosts_ file adding a cusutom domain
  - On MacOS and Linux is `/etc/hosts`
  - On [Windows](https://www.liquidweb.com/kb/edit-host-file-windows-10/) is `C:\Windows\System32\drivers\etc\hosts`
- Add a line with you custom domain

```conf
127.0.1.1 stellar-dev.localdomain stellar-dev
```

## Proxy remote media files

There are times where you have a published staging site with hundreds of media files already uploaded, and syncing them locally would take too much time or ocupy too much space in your local machine.

You can use the the local `nginx` service to proxy those files. That way you would only need to sync the database and not the media. The only requisite is that the media in the local site has the same **path** as the remote site.

For instance, if you have a file in <https://remote-site.com/wp-content/uploads/2022/11/my-image.png> you can access it in `<https://localhost:8081/wp-content/uploads/2022/11/my-image.png> without the need to download it locally.

To make this work, you should createa `.env` file with the following line:

```bash
WORDPRESS_REMOTE_URL=https://remote-site.com
```
