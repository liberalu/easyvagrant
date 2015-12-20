
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

class { 'apache':
    mpm_module => false,
}

class { 'apache::mod::prefork':
    startservers => '12',
}

class { 'apache::mod::php': }
class { 'apache::mod::rewrite' :}

apache::vhost { 'webpage.local.dev':
    port    => '80',
    docroot => '/vagrant',
    directories  => [
        {   path           => '/vagrant',
            allow_override => ['All'],
        },
    docroot_owner => 'vagrant',
    docroot_group => 'vagrant',
  ],
}

###### MySQL service ######

class { 'mysql::server':
    root_password => 'pass',
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
    sql      => '/vagrant/vagrant/taliaink_wp.sql',
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
}

$phpModules = [ 'imagick', 'xdebug', 'curl', 'mysql', 'cli', 'intl', 'mcrypt', 'memcache']

php::module { $phpModules: }
php::conf { 'php.ini-cli':
    path => '/etc/php5/cli/php.ini',
}

php::ini { 'php':
    value   => [
        'date.timezone = "Europe/Vilnius"',
        'xdebug.profiler_enable=0',
        ],
    target  => 'php.ini',
    service => 'apache2',
}

##### Other services #####

package { 'htop':
    ensure => present,
}
package { 'php-apc':
    ensure => present,
}
