
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin", "/etc/puppet/modules", "/etc/puppet"]
}

exec { "apt-get update":
    command => "/usr/bin/apt-get update"
}


##### Install fish shell #####

package { 'fish':
    ensure => present,
}
exec { 'fish_default':
    command => 'sudo chsh -s $(which fish) $(whoami)',
    require => Package['fish'],
}

##### Apache service #####


file { '/vagrant/www':
    ensure => 'directory',
    mode   => '0777',
}

class { 'apache':
    mpm_module => false,
    require => File['/vagrant/www']
}

class { 'apache::mod::prefork':
    startservers => '12',
}

class { 'apache::mod::php': }
class { 'apache::mod::rewrite' :}

apache::vhost { 'webpage.local.dev':
    port    => '80',
    docroot => '/vagrant/www',
    directories  => [
        {   path           => '/vagrant/www',
            allow_override => ['All'],
        },
        docroot_owner => 'vagrant',
        docroot_group => 'vagrant',
    ],
    custom_fragment => 'PHPINIDir /vagrant/',
}

###### MySQL service ######

$override_options = {
  'mysqld' => {
    'general_log_file' => '/var/log/mysql/general.log',
    'general_log' => '1'
  }
}

class { 'mysql::server':
    root_password => 'pass',
    override_options => $override_options,
    restart => true,
}


# Bind to php
class { 'mysql::bindings' :
    php_enable => true,
    client_dev => true,
    daemon_dev => true,
}


# Add new database
mysql::db { 'database':
    user     => 'user1',
    password => 'pass1',
    host     => 'localhost',
    grant    => ['ALL'],
}

##### phpinfo(); ######

apache::vhost { 'phpinfo.local.dev':  # define vhost resource
    port    => '80',
    docroot => '/var/www/phpinfo'
}

file { '/var/www/phpinfo/index.php':
  ensure => file,
  content => '<?php  phpinfo(); ?>',    # phpinfo code
  require => Package['apache2'],        # require 'apache2' package before creating
}

##### main page ######

apache::vhost { 'main.local.dev':  # define vhost resource
    port    => '80',
    docroot => '/var/www/main'
}

file { '/var/www/main/index.php':
  ensure => file,
  content => '<?php  echo "Something is going wrong"; ?>',
  require => Package['apache2'],
  mode    => '0777',
}



##### PhpMyAdmin ######

class { 'phpmyadmin': }
    ->
phpmyadmin::server{ 'default': }
    ->
phpmyadmin::vhost { 'phpmyadmin.local.dev':
    vhost_enabled => true,
    priority      => '30',
    docroot       => $phpmyadmin::params::doc_path,
} ->
# Trick to change permission
exec { 'phpmyadmin_perission':
    command => 'sudo sed -i "s/Require local/#Require local/g" /etc/apache2/conf.d/phpmyadmin.conf; sudo sed -i "s/Require ip/#Require ip/g" /etc/apache2/conf.d/phpmyadmin.conf;sudo service apache2 restart;',
}


###### PHP service ######

class { 'php':
          require  => Exec['apt-get update'],
          config_file => '/vagrant/php.ini'
    }

$phpModules = [ 'imagick', 'xdebug', 'curl', 'mysql', 'cli', 'intl', 'mcrypt', 'memcache']

php::module { $phpModules: }

##### rtail service #####

exec { "add_node":
    command => "curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -",
    require => Exec["apt-get update"]
}

package { "nodejs" :
    install_options => ["-y"],
    require => Exec["add_node"]
}

exec { "add_rtail":
    command => "sudo npm install -g rtail",
    require => Package["nodejs"]
}

##### Other services #####

package { 'htop':
    ensure => present,
}
package { 'php-apc':
    ensure => present,
}
package { 'git':
    ensure => present,
}
package { 'tig':
    ensure => present,
}
package { 'sendmail':
    ensure => present,
}


##### git list ######

apache::vhost { 'git.local.dev':  # define vhost resource
    port    => '80',
    docroot => '/var/www/git',
    directories  => [
        {   path           => '/var/www/git',
            allow_override => ['All'],
        },
    ],
}

exec { "import_git_list":
    command => "sudo wget https://s3.amazonaws.com/gitlist/gitlist-0.5.0.tar.gz -P /var/www/git && sudo tar -xvzf /var/www/git/gitlist-0.5.0.tar.gz -C /var/www/git --strip-components=1",
    require => Package['apache2'],
}

file { '/var/www/git/config.ini':
    ensure => file,
    source => '/var/www/git/config.ini-example',
    require => Exec['import_git_list'],
}
->
ini_setting { "git list path":
    ensure  => present,
    path    => '/var/www/git/config.ini',
    section => 'git',
    setting => 'repositories[]',
    value   => '/vagrant/',
}

file { '/var/www/git/cache':
    ensure => 'directory',
    mode   => '0777',
    require => Exec['import_git_list'],
}


##### webgrind install #####

apache::vhost { 'webgrind.local.dev':  # define vhost resource
    port    => '80',
    docroot => '/var/www/webgrind',
    directories  => [
        {   path           => '/var/www/webgrind',
            allow_override => ['All'],
        },
    ],
}

exec { "import_webgrind":
    command => "sudo git clone https://github.com/jokkedk/webgrind.git /var/www/webgrind/ --depth=1",
    require => Package['apache2'],
}

##### WP CLI install #####

exec { "import_wpcli":
    command => "sudo wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp && sudo chmod +x /tmp/wp-cli.phar && sudo mv /tmp/wp-cli.phar /usr/local/bin/wp",
    require => Package['apache2'],
}
