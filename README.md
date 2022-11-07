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
