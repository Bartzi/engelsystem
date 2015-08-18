class php {

  # Install the php5-fpm and php5-cli packages
  package { ['php5-fpm',
             'php5-cli',
             'php5-mysql']:
    ensure => present,
    require => Exec['apt-get update'],
  }

  # Make sure php5-fpm is running
  service { 'php5-fpm':
    ensure => running,
    require => Package['php5-fpm'],
  }

  # Disable the default nginx vhost
  #file { 'delete-www.conf':
  #  path => '/etc/php5/fpm/pool.d/www.conf',
  #  ensure => absent,
  #  require => Package['php5-fpm'],
  #}

  # Add a vhost template
  file { 'vagrant-www.conf':
    path => '/etc/php5/fpm/pool.d/www.conf2',
    ensure => file,
    require => Package['php5-fpm'],
      source => 'puppet:///modules/php/www.conf',
  }

  # Add a vhost template
  file { 'www.conf':
    path => '/etc/php5/fpm/pool.d/www.conf',
    ensure => link,
    notify => Service['php5-fpm'],
    require => File['vagrant-www.conf'],
    target => '/etc/php5/fpm/pool.d/www.conf2',
  }  
}