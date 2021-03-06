# @summary Controls the state of the falco service
#
# Controls the state of the falco service
#
class falco::service inherits falco {
  service { 'falco':
    ensure     => $falco::service_ensure,
    enable     => $falco::service_enable,
    hasstatus  => true,
    hasrestart => $falco::service_restart,
  }
}
