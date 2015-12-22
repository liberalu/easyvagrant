
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

$override_options = {
  'mysqld' => {
    'general_log_file' => '/var/log/mysql/general.log',
    'general_log' => '1'
  }
}

class { 'mysql::server':
    root_password => 'pass',
    override_options => $override_options
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

exec { "run_rtail":
    command => "rtail-server --web-port 8080 --wh 192.168.33.10 &",
    require => Exec["add_rtail"]
}

exec { "add_chmod":
    command => "sudo chmod -R 0777 /var/log/apache2 /var/log/mysql",
    require => [
        Exec["run_rtail"],
        Service['apache2']
    ]
}

exec { "rtail_apache2_access":
    command => "tail -F /var/log/apache2/webpage.local.dev_access.log | rtail --name 'apache2 access' &",
    require => Exec["add_chmod"]
}

exec { "rtail_apache2_errors":
    command => "tail -F /var/log/apache2/webpage.local.dev_error.log | rtail --name 'apache2 error' &",
    require => Exec["add_chmod"]
}

exec { "rtail_mysql_error":
    command => "tail -F /var/log/mysql/error.log | rtail --name 'mysql error' &",
    require => [
        Exec["add_chmod"],
        Service['mysql']
    ]
}

exec { "rtail_mysql_query":
    command => "tail -F /var/log/mysql/general.log | rtail --name 'mysql query' &",
        require => [
        Exec["add_chmod"],
        Service['mysql']
    ]
}


##### Other services #####

package { 'htop':
    ensure => present,
}
package { 'php-apc':
    ensure => present,
}
