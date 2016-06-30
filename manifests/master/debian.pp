# debian master
class puppet::master::debian inherits puppet::master::package {

  if $puppet::master::mode == 'passenger' {
    File['/etc/default/puppetmaster'] {
      content => "# This file is managed by Puppet.\n\n# Running in passenger mode.\nSTART=no",
      notify  => Exec['stop puppetmaster service'],
    }
    exec { 'stop puppetmaster service':
      command     => 'service puppetmaster stop',
      onlyif      => 'service puppetmaster status',
      refreshonly => true,
    }
  } else {
    File['/etc/default/puppetmaster'] {
      source  => ["puppet:///modules/site_puppet/master/debian/${::fqdn}/puppetmaster",
                  "puppet:///modules/site_puppet/master/debian/${::domain}/puppetmaster",
                  'puppet:///modules/site_puppet/master/debian/puppetmaster',
                  'puppet:///modules/puppet/master/debian/puppetmaster' ],
    }
    Service['puppetmaster'] {
      hasstatus  => true,
      hasrestart => true,
      subscribe  +> File['/etc/default/puppetmaster'],
    }
  }

  file { '/etc/default/puppetmaster':
    owner   => root,
    group   => 0,
    mode    => '0644';
  }
}
