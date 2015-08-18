class nginx {

  # Install the nginx package. This relies on apt-get update
  package { 'nginx':
    ensure => 'present',
    require => Exec['apt-get update'],
  }

  # change the user that runs nginx to the vagrant user
  exec { 'change nginx user':
    command => "sed -i 's/user www-data;/user vagrant;/' /etc/nginx/nginx.conf",
    path => ['/usr/bin', '/bin'],
    require => Package['nginx'],
  }

  # Make sure that the nginx service is running
  service { 'nginx':
    ensure => running,
    require => Exec['change nginx user'],
  }

  # Add a vhost template
  file { 'vagrant-nginx':
    path => '/etc/nginx/sites-available/vhosts',
    ensure => file,
    require => Package['nginx'],
      source => 'puppet:///modules/nginx/vhosts',
  }

  # Disable the default nginx vhost
  file { 'default-nginx-disable':
    path => '/etc/nginx/sites-enabled/default',
    ensure => absent,
    require => Package['nginx'],
  }

  # Symlink our vhost in sites-enabled to enable it
  file { 'vagrant-nginx-enable':
    path => '/etc/nginx/sites-enabled/vhosts',
    target => '/etc/nginx/sites-available/vhosts',
    ensure => link,
    notify => Service['nginx'],
    require => [
      File['vagrant-nginx'],
      File['default-nginx-disable'],
    ],
  }
}
