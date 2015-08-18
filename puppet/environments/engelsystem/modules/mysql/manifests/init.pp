class mysql {

  # Install mysql
  package { ['mysql-server']:
    ensure => present,
    require => Exec['apt-get update'],
  }

  # Run mysql
  service { 'mysql':
    ensure  => running,
    require => Package['mysql-server'],
  }

  # Use a custom mysql configuration file
  file { '/etc/mysql/my.cnf':
    source  => 'puppet:///modules/mysql/my.cnf',
    require => Package['mysql-server'],
    notify  => Service['mysql'],
  }

  # run stored sql for creating a new database and adding a user
  exec { 'populate database':
    command => 'mysql -uroot < /vagrant/puppet/environments/engelsystem/modules/mysql/files/config.sql',
    path => ['/bin', '/usr/bin'],
    require => Service['mysql'];
  }

  # run stored sql for creating the base tables for the application
  exec { 'create tables':
    command => 'mysql -uroot --database=engelsystem < /vagrant/db/install.sql',
    path => ['/bin', '/usr/bin'],
    require => Exec['populate database'];
  }
}