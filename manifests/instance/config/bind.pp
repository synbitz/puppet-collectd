define collectd::instance::config::bind (
  $url='http://localhost:8053',
  $opcodes=true,
  $qtypes=true,
  $serverstats=true,
  $zonemaintstats=true,
  $resolverstats=false,
  $memorystats=true,
  $zones=undef,
  $version='present'
) {

  if $name != 'default' {
    $instance = $name
  } else {
    $instance = ''
  }

  case $::operatingsystemrelease {
    /^[56]\./: {
      if !defined(Package['collectd-bind']) {
        package { 'collectd-bind':
          ensure  => $version,
        }
      }

      file { "/etc/collectd${instance}.d/bind":
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }

      file { "/etc/collectd${instance}.d/bind/init.conf":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('collectd/plugins/bind.conf.erb'),
      }

      Collectd::Instance::Config[$title] -> Collectd::Instance::Config::Bind[$title] ~> Collectd::Instance::Service[$title]
    }
    default: { notice("operatingsystemrelease ${::operatingsystemrelease} is not supported") }
  }
}
