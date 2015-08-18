exec { 'apt-get update':
  path => '/usr/bin',
}

exec { 'write permissions':
  command => 'chmod +w /vagrant/import',
  path => ['/bin', '/usr/bin'],
  require => Exec['apt-get update'];
}

include nginx, php, mysql