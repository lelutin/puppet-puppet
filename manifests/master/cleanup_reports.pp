class puppet::master::cleanup_reports {
  # clean up reports older than $puppetmaster_cleanup_reports days
  file { '/etc/cron.daily/puppet_reports_cleanup':
    content => "#!/bin/bash\nfind ${puppet::master::reports_dir} -maxdepth 2 -type f -ctime +${puppet::master::cleanup_reports} -exec rm {} \\;\n",
    owner => root, group => 0, mode => 0700;
  }

  # Clean up non-working cronjob set up by past versions of this class
  # https://gitlab.com/shared-puppet-modules-group/puppet/issues/9
  file { '/etc/cron.daily/puppet_reports_cleanup.sh':
    ensure => absent,
  }
}
