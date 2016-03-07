# Easy vagrant

## Requirements

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/downloads.html)
- Vagrant plugins:
  - [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater€)
  - [vagrant-librarian-puppet](https://github.com/mhahn/vagrant-librarian-puppet)
  - [vagrant-triggers](https://github.com/emyl/vagrant-triggers)

## Get started

## Packages

- Apache
- PHP
- MySQL
- phpMyAdmin
- xdebug with webgrind
- rtail
- git
- tig
- gitlist

## Usage

### MySQL

There are two MySQL accounts:
1. user: root, pass: pass;
2. user: user1, pass: pass1.

### PhpMyadmin

You can access phpmyadmin directly from [http://webpage.local.dev](http://webpage.local.dev) page.

### XDebug and webgrind

Xdebug works. 
You can profiling by passing the special GET or POST parameter XDEBUG_PROFILE. For example, [http://webpage.local.dev/?XDEBUG_PROFILE](http://webpage.local.dev/?XDEBUG_PROFILE). You can look xdebug generated profile files from http://webgrind.local.dev/.
Xdebug debuging is configure.

### Git preview

You can preview your project git commits from http://git.local.dev/www/.

### Logs

You can view logs from http://192.168.33.10:8080/. There are apache errors and access, mysql errors and access logs. 

## Links

- [http://webpage.local.dev](http://webpage.local.dev) - webiste main page
- [http://phpinfo.local.dev](http://phpinfo.local.dev) - phpinfo() page
- [http://git.local.dev](http://git.local.dev) - git review page
- [http://webgrind.local.dev](http://webgrind.local.dev) - webgrind page
- [http://phpmyadmin.local.dev](http://phpmyadmin.local.dev) - phpmyadmin page
- [http://192.168.33.10:8080](http://192.168.33.10:8080) - rtail page
