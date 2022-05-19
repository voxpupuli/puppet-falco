# @summary Controls the contents of falco.yaml and sets up log rotate, if needed
#
# Controls the contents of falco.yaml and sets up log rotate, if needed
#
class falco::config inherits falco {
  file { '/etc/falco/falco.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('falco/falco.yaml.erb'),
    require => Class['falco::install'],
    notify  => Service['falco'],
  }

  $_file_output = $falco::file_output

  if ($_file_output != undef) {
    logrotate::rule { 'falco_output':
      path          => $_file_output['filename'],
      rotate        => 5,
      rotate_every  => 'day',
      size          => '1M',
      missingok     => true,
      compress      => true,
      sharedscripts => true,
      postrotate    => '/usr/bin/killall -USR1 falco',
    }
  }
}
